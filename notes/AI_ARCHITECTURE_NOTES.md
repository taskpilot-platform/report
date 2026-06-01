# AI_ARCHITECTURE_NOTES

Scope:
- Focused only on AI architecture and design patterns.
- Source files read were limited to the requested AI classes, selected `taskpilot-contracts` port interfaces, `application.yml` AI config, profile config files for AI overrides, and model-only `.env` lines.
- No source code was modified.
- No Typst was generated.
- No secrets are included here.

---

## 1. Which AI providers are configured?

Configured providers:

1. Google Gemini
- Implemented with LangChain4j `GoogleAiGeminiStreamingChatModel`.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/config/AiModelConfig.java`, class `AiModelConfig`, method `geminiStreamingModel(String modelName)`.

2. GitHub Models via OpenAI Official SDK
- Implemented with `OpenAiOfficialStreamingChatModel` and `.isGitHubModels(true)`.
- Evidence: `AiModelConfig.gpt4oFallbackModel`, `AiModelConfig.gpt4oFallbackTextModel`, `AiModelConfig.deepSeekReasoningModel`, `AiModelConfig.deepSeekReasoningTextModel`.

3. Groq via OpenAI-compatible API
- Implemented with `OpenAiOfficialStreamingChatModel` / `OpenAiOfficialChatModel` and `.baseUrl(groqBaseUrl)`.
- Beans are conditional on `ai.groq.enabled=true`.
- Evidence: `AiModelConfig.groqOssReasoningModel`, `AiModelConfig.groqOssReasoningTextModel`, `AiModelConfig.groqGatekeeperModel`, all annotated with `@ConditionalOnProperty(value = "ai.groq.enabled", havingValue = "true")`.

---

## 2. Which exact model names are used?

Configured model names from `application.yml`:

- Gemini primary default: `gemini-2.5-pro`
  - Evidence: `taskpilot-app/src/main/resources/application.yml`, property `ai.gemini.model-name: ${AI_GEMINI_MODEL:gemini-2.5-pro}`.

- Gemini fallback 1 default: `gemini-2.5-flash`
  - Evidence: `application.yml`, property `ai.gemini.fallback1-model`.

- Gemini fallback 2 default: `gemini-2.5-flash-lite`
  - Evidence: `application.yml`, property `ai.gemini.fallback2-model`.

- Gemini fallback 3 default: `gemini-2.0-flash`
  - Evidence: `application.yml`, property `ai.gemini.fallback3-model`.

- Gemini fallback 4 default: `gemini-1.5-pro`
  - Evidence: `application.yml`, property `ai.gemini.fallback4-model`.

- GitHub fallback model default: `gpt-4o`
  - Evidence: `application.yml`, property `ai.github.fallback-model: ${AI_GITHUB_FALLBACK_MODEL:gpt-4o}`.

- GitHub reasoning model default: `DeepSeek-R1`
  - Evidence: `application.yml`, property `ai.github.reasoning-model: ${AI_GITHUB_REASONING_MODEL:DeepSeek-R1}`.

- Groq reasoning model default: `openai/gpt-oss-120b`
  - Evidence: `application.yml`, property `ai.groq.reasoning-model`.

- Groq gatekeeper model default: `llama-3.1-8b-instant`
  - Evidence: `application.yml`, property `ai.groq.gatekeeper-model`.

Observed local model overrides from model-only `.env` lines:

- `AI_GEMINI_MODEL=gemini-3.1-flash-lite-preview`
- `AI_GITHUB_FALLBACK_MODEL=gpt-4.1-mini`
- `AI_GROQ_ENABLED=true`
- `AI_GROQ_GATEKEEPER_MODEL=llama-3.1-8b-instant`

Evidence:
- `taskpilot/.env`, model-only variables above.
- No API keys, tokens, passwords, or endpoint credentials are reproduced in this note.

Important wording:
- The report can say "application defaults are X; observed local `.env` model overrides are Y."
- Avoid saying every runtime environment always uses the `.env` values unless that deployment environment is explicitly confirmed.

---

## 3. Which provider/model is primary?

Primary model bean:
- `geminiFlashModel`
- Provider: Google Gemini
- Model name property: `ai.gemini.model-name`
- App default from `application.yml`: `gemini-2.5-pro`
- Observed local `.env` override: `gemini-3.1-flash-lite-preview`

Evidence:
- `AiModelConfig.geminiFlashModel` is annotated with `@Primary` and `@Bean("geminiFlashModel")`.
- `SmartRoutingService` constructor injects `@Qualifier("geminiFlashModel") StreamingChatModel geminiPrimaryModel`.
- `SmartRoutingService.getPrimaryModel()` returns `geminiPrimaryModel`.

Report-safe phrasing:
- "The AI module defines Gemini as the primary streaming chat model through the `geminiFlashModel` bean. The actual model name is configured by `ai.gemini.model-name`."

---

## 4. Is there automatic fallback? Where is it implemented?

Yes, there is automatic fallback behavior for streaming chat. Also note one naming nuance: the GitHub/OpenAI-compatible `gpt4oFallbackModel` can be selected directly by `SmartRoutingService.route` as the light/default route, while timeout/error fallback is a separate runtime behavior in `AiStreamingService`.

Fallback pieces:

1. Gemini waterfall fallback
- `SmartRoutingService.getNextGeminiFallback(StreamingChatModel currentModel)` moves from primary Gemini to Gemini fallback models, limited by `ai.gemini.waterfall-max-attempts`, then exits to the external fallback model.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/service/SmartRoutingService.java`, method `getNextGeminiFallback`, helper `maxGeminiAttempts`, helper `externalFallbackAfter`.

2. External fallback model
- `SmartRoutingService.getFallbackModel()` returns the GitHub/OpenAI fallback model.
- The same fallback-named model can also be used as the normal light/default route when the request is not heavy context and does not likely need tools.
- Evidence: `SmartRoutingService.getFallbackModel`; `SmartRoutingService.route` final branch returns `gpt4oFallbackModel`.

3. Fallback trigger during stream
- `AiStreamingService.handleFirstResponseTimeout` switches to `routingService.getNextGeminiFallback(model)` when current model is Gemini, otherwise `routingService.getFallbackModel()`.
- `AiStreamingService.streamRound` also switches fallback on model errors using the same routing service methods.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/service/AiStreamingService.java`, methods `handleFirstResponseTimeout`, `streamRound`, calls to `routingService.getNextGeminiFallback(model)` and `routingService.getFallbackModel()`.

Report-safe phrasing:
- "The GitHub/OpenAI-compatible fallback-named model has two roles: it can be selected directly by `SmartRoutingService` as a light/default route, and it can also be used by `AiStreamingService` as a runtime timeout/error fallback."

Do not claim:
- Do not claim every AI endpoint uses the same fallback. `AutoAssignmentService.generateExplanation` directly uses `deepSeekModel` and catches errors with a textual fallback message, not the same routing waterfall.
- Evidence: `AutoAssignmentService.generateExplanation`.

---

## 5. How does SmartRoutingService choose a route/model?

`SmartRoutingService.route(String userMessage, String contextHistory)` chooses a model through ordered checks:

1. Normalize user input.
- Evidence: `SmartRoutingService.route`, `SmartRoutingService.normalize`.

2. Detect direct assignment execution and pending action confirmation.
- Direct assignment execution: `SmartRoutingService.isDirectAssignmentExecution`.
- Pending confirmation: `SmartRoutingService.isPendingActionConfirmation`.
- If either is true, `requiresAHP` is forced to false.
- Evidence: `SmartRoutingService.route`, local variables `directAssignmentExecution`, `pendingActionConfirmation`, `requiresAHP`.

3. Detect assignment recommendation intent.
- Calls `resolveRequiresAHP(userMessage)`.
- `resolveRequiresAHP` calls `gatekeeperService.requiresAHP(userMessage)` and falls back to configured keywords when gatekeeper fails.
- Evidence: `SmartRoutingService.resolveRequiresAHP`.

4. Estimate request size.
- Uses `tokenEstimationUtil.estimateTotal(userMessage, contextHistory)`.
- If above `ai.routing.token-threshold`, routes to reasoning model.
- Evidence: `SmartRoutingService.route`, variables `estimatedTokens`, `heavyContext`.

5. Choose route:
- If `requiresAHP`: route to reasoning model from `getReasoningModel()`.
- Else if heavy context: route to reasoning model from `getReasoningModel()`.
- Else if likely tool usage: route to Gemini primary.
- Else: route to the GitHub/OpenAI fallback-named model as the light/default route.
- Evidence: `SmartRoutingService.route`.

6. Reasoning model selection:
- `getReasoningModel()` returns Groq reasoning model when `groqEnabled` and Groq bean exists; otherwise GitHub reasoning model.
- Evidence: `SmartRoutingService.getReasoningModel`.

Report-safe phrasing:
- "SmartRoutingService is a rule-based router with token-size routing, assignment recommendation intent checks, tool-friendly routing to Gemini, and a GitHub/OpenAI-compatible light/default route."

Do not claim:
- Do not claim it is a learned router or adaptive model router. Evidence shows rule-based branching in `SmartRoutingService.route`.

---

## 6. How does tool calling work?

Tool calling flow:

1. Tool declaration
- Tool methods are annotated with LangChain4j `@Tool` in `TaskPilotAiTools`.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/tools/TaskPilotAiTools.java`, methods such as `getMyProjects`, `getProjectStatus`, `getMemberWorkload`, `getTaskDetails`, `assignTaskToMember`, `recommendAssignmentCandidates`, `createTask`, `createSprint`.

2. Tool registration
- `ToolCallingRegistryService.init()` creates a LangChain4j `ToolService`, registers `taskPilotAiTools`, then stores tool specifications and executors.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/service/ToolCallingRegistryService.java`, methods `init`, `toolSpecifications`, `toolSpecificationsByName`, `execute`.

3. Tool specs passed into model request
- `AiStreamingService.streamRound` retrieves `toolCallingRegistryService.toolSpecifications()` and attaches them to `ChatRequest.builder()`.
- If `requiresAHP` is true on round 0, it narrows tools to `recommendAssignmentCandidates` with `toolSpecificationsByName("recommendAssignmentCandidates")`.
- Evidence: `AiStreamingService.streamRound`.

4. Tool execution
- `AiStreamingService.executeTools` loops over `ToolExecutionRequest`s.
- It sets `ToolExecutionContext` with userId/sessionId/userInput, calls `toolCallingRegistryService.execute(request)`, sends an SSE `tool` event, records tool summaries, and returns LangChain4j `ToolExecutionResultMessage`s.
- Evidence: `AiStreamingService.executeTools`.

5. Tool loop control
- `AiStreamingService` limits tool rounds with `MAX_TOOL_ROUNDS = 4`.
- It limits repeated same-tool execution with `MAX_CONSECUTIVE_SAME_TOOL_EXECUTIONS = 3`.
- Evidence: `AiStreamingService` constants and `streamRound`.

6. Final response after tool data
- Tool results are injected into the conversation as tool result messages or flattened system memory before final text generation.
- Evidence: `AiStreamingService.streamRound`, `AiStreamingService.sanitizeHistoryForTools`, `AiStreamingService.forceTextOnlyResponse`.

Report-safe phrasing:
- "Tool calling is implemented through LangChain4j tool annotations, a registry service, streaming orchestration, and bounded tool execution rounds."

---

## 7. How does pending action confirmation work?

Pending action confirmation is a human-in-the-loop, deferred-command pattern-like implementation.

Flow:

1. Write tools do not directly execute immediately.
- Write operations return `pendingAiActionService.create(...)` with a summary, arguments, optional preview, and a `Supplier<Object>` executor.
- Evidence:
  - `TaskPilotAiTools.assignTaskToMember`
  - `TaskPilotAiTools.recommendAndAssignTask`
  - `TaskPilotAiTools.updateTaskStatus`
  - `TaskPilotAiTools.createTask`
  - `TaskPilotAiTools.createSprint`
  - `TaskPilotAiTools.startSprint`
  - `TaskPilotAiTools.completeSprint`
  - `TaskPilotAiTools.assignTaskToSprint`

2. Pending actions are stored in memory.
- `PendingAiActionService.create` stores a `PendingAction` in a `ConcurrentHashMap`.
- Each action has `userId`, `sessionId`, `toolName`, `summary`, `arguments`, `preview`, expiration time, and executor.
- TTL is 10 minutes.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/service/PendingAiActionService.java`, fields `ACTION_TTL`, `actions`, method `create`, record `PendingAction`.

3. Confirmation must include the action id and a confirmation keyword.
- `TaskPilotAiTools.confirmPendingAction` first checks `isCurrentUserConfirming(actionId)`.
- `isCurrentUserConfirming` normalizes user input and requires both the action id and a confirmation token such as `confirm`, `confirmed`, `xac nhan`, `dong y`, `thuc hien`, or `apply`.
- Evidence: `TaskPilotAiTools.confirmPendingAction`, `TaskPilotAiTools.isCurrentUserConfirming`.

4. Ownership is enforced.
- `PendingAiActionService.confirm` removes the action, checks same `userId` and `sessionId`, then runs `action.executor().get()`.
- `PendingAiActionService.cancel` checks ownership before removing.
- Evidence: `PendingAiActionService.confirm`, `PendingAiActionService.cancel`.

Limitations:
- Pending actions are in-memory only; they will not survive backend restart.
- Evidence: `PendingAiActionService.actions = new ConcurrentHashMap<>()`.

Report-safe phrasing:
- "Write tools use a human-in-the-loop deferred execution model. The implementation is command-like because each pending action captures an executable `Supplier<Object>`."

---

## 8. How does auto-assignment work?

Auto-assignment flow:

1. Public service entrypoints
- `AutoAssignmentService.recommend(...)`: recommends candidates, generates an AI explanation for top candidates, and writes an AI audit log.
- `AutoAssignmentService.recommendCandidates(...)`: returns scored candidates without explanation.
- Evidence: `taskpilot-ai/src/main/java/com/taskpilot/ai/service/AutoAssignmentService.java`, methods `recommend`, `recommendCandidates`.

2. Data sources through ports
- Project members: `ProjectMemberPort.findProjectMembers`.
- Recent performance: `ProjectMemberPort.findRecentPerformanceScores`.
- User profile/workload/status: `UserPort.findById`.
- User skills: `UserSkillPort.findByUserIdWithSkill`.
- Project heuristic config: `ProjectPort.findById`.
- Evidence: `AutoAssignmentService` fields `ProjectMemberPort`, `UserSkillPort`, `UserPort`, `ProjectPort`; method calls in `recommendCandidates`, `buildRawCandidate`, `calculateTimeDecayPerformanceScore`, `resolveHeuristicMode`.

3. Candidate filtering
- Filters out unavailable users with status `DEACTIVATED` or `OOO`.
- Evidence: `AutoAssignmentService.isUnavailable`, called by `buildRawCandidate`.

4. Score components
- Fit score: based on required skill matching and skill level.
- Load score: normalized current workload from 0 to 100.
- Performance score: time-decayed recent performance blended with project performance prior.
- Evidence:
  - `AutoAssignmentService.calculateFitScore`
  - `AutoAssignmentService.normalizeLoad`
  - `AutoAssignmentService.calculateTimeDecayPerformanceScore`
  - constants `PERFORMANCE_WINDOW_SIZE`, `DECAY_WEIGHTS`, `NEUTRAL_PERFORMANCE_PRIOR`

5. Heuristic mode / strategy-like scoring
- `resolveHeuristicMode(projectId)` reads project heuristic mode through `ProjectPort`.
- `heuristicStrategyFactory.resolve(mode)` returns a `HeuristicStrategy`.
- `buildCandidateScore` calls `strategy.normalize(...)` and `strategy.score(...)`.
- Evidence: `AutoAssignmentService.resolveHeuristicMode`, `AutoAssignmentService.computeCandidates`, `AutoAssignmentService.buildCandidateScore`.

6. Ranking
- Candidates are sorted by `CandidateScore.getTotalScore()` descending.
- Evidence: `AutoAssignmentService.computeCandidates`.

7. Explanation and logging
- `recommend` uses top 3 candidates and `generateExplanation(...)` with `deepSeekModel`.
- `saveAutoAssignLog(...)` builds an `AiLogEntity` and saves through `AiAuditPort`.
- Evidence: `AutoAssignmentService.generateExplanation`, `AutoAssignmentService.saveAutoAssignLog`.

Important wording:
- The source uses "AHP" wording in prompts/tool descriptions, but the scoped implementation evidence shows weighted heuristic scoring over fit/load/performance. Do not claim full formal AHP pairwise comparison unless additional algorithm documentation supports it.

Report-safe phrasing:
- "Auto-assignment uses heuristic, strategy-like scoring over skill fit, workload, and performance, then optionally asks a reasoning model to explain the top candidates."

---

## 9. Which design patterns are visible in the AI module?

Visible or pattern-like designs:

1. Configuration / Bean Factory pattern-like
- `AiModelConfig` centralizes construction of AI model beans.
- Evidence: `AiModelConfig` methods `geminiFlashModel`, `gpt4oFallbackModel`, `deepSeekReasoningModel`, `groqOssReasoningModel`.

2. Router / Strategy selection pattern-like
- `SmartRoutingService.route` selects among model candidates based on rules.
- Evidence: `SmartRoutingService.route`, `getReasoningModel`, `getFallbackModel`, `getPrimaryModel`.

3. Fallback Chain pattern-like
- Gemini primary and fallback models form a waterfall, then external fallback.
- Evidence: `SmartRoutingService.getNextGeminiFallback`, `externalFallbackAfter`; `AiStreamingService.handleFirstResponseTimeout`, `AiStreamingService.streamRound`.

4. Registry pattern
- Tool specs and executors are registered once and accessed by name.
- Evidence: `ToolCallingRegistryService.init`, `toolSpecifications`, `toolSpecificationsByName`, `execute`.

5. Command pattern-like / Deferred Command
- Pending write actions store executable `Supplier<Object>` functions and execute them only after confirmation.
- Evidence: `PendingAiActionService.create`, `PendingAiActionService.confirm`, `TaskPilotAiTools` write tools.

6. Strategy pattern-like for scoring
- `AutoAssignmentService` uses `HeuristicStrategyFactory.resolve(mode)` and `HeuristicStrategy` to normalize and score.
- Evidence: `AutoAssignmentService.recommendCandidates`, `AutoAssignmentService.buildCandidateScore`.
- Caveat: The strategy implementation classes were outside this scoped read, so report as "strategy-like" unless those files are also inspected.

7. Audit Log pattern
- AI request/response/tool metadata is persisted asynchronously.
- Evidence: `AiLogService.saveLog`; calls from `AiStreamingService` and `AutoAssignmentService.saveAutoAssignLog`.

8. Streaming/Event pattern-like
- AI response is streamed via `SseEmitter` events (`phase`, `model`, `token`, `tool`, `done`, `error`).
- Evidence: `AiStreamingService.streamChat`, `AiStreamingService.safeSend`.

---

## 10. Which architectural patterns are visible in inter-module communication?

Visible inter-module communication pattern:

1. Port-based communication
- AI code depends on interfaces from `taskpilot-contracts`, not directly on concrete project/user services.
- Evidence:
  - `TaskPilotAiTools` depends on `ProjectMemberPort`, `ProjectInsightsPort`, `MemberAnalyticsPort`, `SprintQueryPort`, `TaskCommentQueryPort`, `TaskCommandPort`.
  - `AutoAssignmentService` depends on `ProjectMemberPort`, `UserSkillPort`, `UserPort`, `ProjectPort`.

2. Contract package as boundary
- Port interfaces live in `taskpilot-contracts`.
- Evidence:
  - `taskpilot-contracts/src/main/java/com/taskpilot/contracts/aiquery/port/out/TaskCommandPort.java`
  - `ProjectInsightsPort.java`
  - `MemberAnalyticsPort.java`
  - `SprintQueryPort.java`
  - `TaskCommentQueryPort.java`
  - `taskpilot-contracts/src/main/java/com/taskpilot/contracts/assignment/port/out/ProjectMemberPort.java`
  - `ProjectPort.java`
  - `UserPort.java`
  - `UserSkillPort.java`

3. DTO-based crossing
- AI communicates with other modules through DTO records in contracts.
- Evidence:
  - `ProjectOverviewDto`, `ProjectStatusDto`, `TaskDetailDto`, `TaskSummaryDto`, `MemberWorkloadDto`, `SprintSummaryDto`, `ProjectMemberDto`, `UserProfileDto`, `UserSkillDto`.

Report-safe phrasing:
- "Inter-module communication is contract/port-based. AI uses interfaces from `taskpilot-contracts` to query or command project/user data."

---

## 11. Is Port & Adapter / Hexagonal-inspired architecture a safe claim?

Safe claim:
- Yes, "Port & Adapter-inspired" or "Hexagonal-inspired" is safe for the AI module, based on scoped evidence.

Why:
- AI services and tools depend on port interfaces from `taskpilot-contracts`.
- Examples:
  - `TaskPilotAiTools` depends on `TaskCommandPort`, `ProjectInsightsPort`, `MemberAnalyticsPort`, `SprintQueryPort`, `TaskCommentQueryPort`.
  - `AutoAssignmentService` depends on `ProjectMemberPort`, `UserSkillPort`, `UserPort`, `ProjectPort`.
- Evidence: `TaskPilotAiTools` field declarations/imports; `AutoAssignmentService` field declarations/imports; contract interface files under `taskpilot-contracts`.

Strict claim to avoid:
- Do not state "the whole backend is a textbook Hexagonal Architecture" from this scoped read.
- Reason: this note did not inspect all module adapters/controllers/repositories, only AI-side dependency direction and contract interfaces.

Best wording:
- "The AI module follows a Port & Adapter-inspired style for inter-module communication: it depends on contracts/ports instead of concrete user/project services."

---

## 12. What should the report safely claim?

Safe report claims:

1. "The AI module is provider-agnostic at the service layer through Spring-configured LangChain4j model beans."
- Evidence: `AiModelConfig` beans and `SmartRoutingService` constructor injection by qualifiers.

2. "Gemini is configured as the primary streaming model; the GitHub/OpenAI-compatible fallback-named model can act as a light/default route and as a runtime fallback target, while GitHub/OpenAI-compatible and Groq reasoning models cover reasoning routes."
- Evidence: `AiModelConfig.geminiFlashModel`, `SmartRoutingService.getReasoningModel`, `SmartRoutingService.getFallbackModel`.

3. "Routing is rule-based."
- Evidence: `SmartRoutingService.route`.

4. "The stream pipeline supports phases, token streaming, tool events, finalization, timeout/error fallback, and audit logging."
- Evidence: `AiStreamingService.streamChat`, `streamRound`, `handleFirstResponseTimeout`, `executeTools`, `safeSend`, `aiLogService.saveLog`.

5. "Tool calling is implemented via LangChain4j `@Tool` methods registered by a tool registry."
- Evidence: `TaskPilotAiTools` and `ToolCallingRegistryService`.

6. "Write actions are protected by a human confirmation step."
- Evidence: `TaskPilotAiTools` write methods, `PendingAiActionService`.

7. "Auto-assignment is heuristic/strategy-like scoring over skill fit, workload, and performance, with optional AI-generated explanation."
- Evidence: `AutoAssignmentService.recommendCandidates`, `calculateFitScore`, `calculateTimeDecayPerformanceScore`, `generateExplanation`.

8. "AI inter-module calls are contract/port-based and therefore Port & Adapter-inspired."
- Evidence: AI classes depending on `taskpilot-contracts` port interfaces.

---

## 13. What should the report NOT claim?

Avoid these claims:

1. Do not claim "all AI is powered by Gemini."
- Evidence against: `AiModelConfig` configures Gemini, GitHub/OpenAI-compatible, and Groq models.

2. Do not claim "Groq is always active."
- Evidence: Groq beans are conditional on `ai.groq.enabled=true` in `AiModelConfig`; `application.yml` default is false, while local `.env` has `AI_GROQ_ENABLED=true`.

3. Do not claim "SmartRoutingService uses machine learning to choose models."
- Evidence: `SmartRoutingService.route` uses explicit rules, token thresholds, keywords/gatekeeper, and branching.

4. Do not claim "the fallback system guarantees successful response."
- Evidence: fallback exists, but `AiStreamingService` still emits `FAILED` and `error` events in failure paths.

5. Do not claim "pending actions are durable."
- Evidence: `PendingAiActionService` stores actions in an in-memory `ConcurrentHashMap`.

6. Do not claim "auto-assignment is a complete formal AHP implementation" from these files alone.
- Evidence: `AutoAssignmentService` implements heuristic scoring over fit/load/performance via `HeuristicStrategy`, but this scoped read did not verify pairwise comparison matrices or a full AHP workflow.

7. Do not claim "the whole backend is strict Hexagonal Architecture."
- Evidence: scoped read only confirms AI-side port usage and contract interfaces. Use "Port & Adapter-inspired" or "Hexagonal-inspired" instead.

8. Do not expose actual API keys, access tokens, database credentials, or provider secrets in the report.
- Evidence: config files contain secret-bearing variables, but report only needs provider/model names and property names.

---

## 14. AI context management

Context management is implemented through a combination of persisted chat messages, a LangChain4j chat memory store, token estimation, context compaction, and history sanitization.

1. Chat sessions and messages are persisted separately.

| Concern | Evidence |
|---|---|
| Chat sessions are created/listed/read/deleted by user. | `taskpilot-ai/src/main/java/com/taskpilot/ai/service/ChatSessionService.java`, class `ChatSessionService`, methods `createSession`, `getUserSessions`, `getSession`, `deleteSession`, `updateTitle`. |
| Chat message history is read by session after access validation. | `taskpilot-ai/src/main/java/com/taskpilot/ai/service/ChatMessageService.java`, class `ChatMessageService`, method `getMessages`; `ChatSessionRepository.findByIdAndUserId`. |
| Stream requests persist the user message before routing. | `taskpilot-ai/src/main/java/com/taskpilot/ai/service/AiStreamingService.java`, class `AiStreamingService`, method `streamChat`, call to `messageRepository.save(ChatMessageEntity.builder()...)`. |
| Assistant responses are persisted after generation. | `AiStreamingService.streamRound` and `AiStreamingService.forceTextOnlyResponse`, calls to `messageRepository.save(ChatMessageEntity.builder().sender(SenderType.ASSISTANT)...)`. |

2. LangChain4j memory is stored through JPA.

| Concern | Evidence |
|---|---|
| Per-session memory uses `MessageWindowChatMemory`. | `SessionChatMemoryService.memoryForSession`, builder with `.id(sessionId)`, `.maxMessages(memoryMaxMessages)`, `.chatMemoryStore(chatMemoryStore)`. |
| Memory payload is stored in table/entity `ai_chat_memories`. | `taskpilot-ai/src/main/java/com/taskpilot/ai/entity/AiChatMemoryEntity.java`, class `AiChatMemoryEntity`, fields `sessionId`, `messagesJson`; table annotation `@Table(name = "ai_chat_memories")`. |
| JPA memory store serializes/deserializes LangChain4j messages as JSON. | `taskpilot-ai/src/main/java/com/taskpilot/ai/memory/JpaChatMemoryStore.java`, methods `getMessages`, `updateMessages`, `deleteMessages`; uses `ChatMessageDeserializer.messagesFromJson` and `ChatMessageSerializer.messagesToJson`. |

3. Memory bootstrap and append flow.

| Concern | Evidence |
|---|---|
| User message append bootstraps memory from recent persisted `chat_messages` when memory is empty. | `SessionChatMemoryService.appendUserMessage`, `bootstrapFromChatMessages`; repository method `ChatMessageRepository.findLastNBySessionId`. |
| Assistant messages are sanitized before being stored into memory. | `SessionChatMemoryService.appendAssistantMessage`, `sanitizeAssistantMessage`; removes `<think>...</think>` and truncates long assistant memory content. |
| User input is normalized/truncated before memory insert when char/token limits are exceeded. | `SessionChatMemoryService.normalizeUserInputForMemory`; uses `tokenCountEstimator.estimateTokenCountInText`. |

4. Request context is compacted before model calls.

| Concern | Evidence |
|---|---|
| Stream builds system prompt + memory history before routing. | `AiStreamingService.streamChat`, calls `buildSystemPrompt`, `sessionChatMemoryService.appendUserMessage`, `withSystemPrompt`, `compactHistoryForRequest`. |
| Long request history is compacted by keeping system prompt, summarizing older messages, and retaining a tail window. | `AiStreamingService.compactHistoryForRequest`, `buildCompactedMessages`, `buildCompactSummary`; config fields `maxContextTokens`, `contextTailMessages`, `compactSummaryMaxChars`, `compactMessageMaxChars`. |
| Token count is estimated with LangChain4j token estimator, with char fallback. | `AiStreamingService.estimateTokens`. |
| Separate routing token estimation uses a simple char-per-token estimate. | `taskpilot-ai/src/main/java/com/taskpilot/ai/util/TokenEstimationUtil.java`, class `TokenEstimationUtil`, methods `estimate`, `estimateTotal`; used in `SmartRoutingService.route`. |

5. Tool history is sanitized before additional model rounds.

| Concern | Evidence |
|---|---|
| AI messages with tool calls are flattened to plain text before reuse. | `AiStreamingService.sanitizeHistoryForTools`, branch for `AiMessage aiMsg && aiMsg.hasToolExecutionRequests()`. |
| Tool results are injected as `SystemMessage` ground-truth memory. | `AiStreamingService.sanitizeHistoryForTools`, branch for `ToolExecutionResultMessage`. |
| After assignment recommendation/tool result rounds, the service can force text-only generation to avoid repeated tool calls. | `AiStreamingService.streamRound`, branches guarded by the code variable `requiresAHP` calling `forceTextOnlyResponse`; method `forceTextOnlyResponse`. |

6. Heavy context routing.

| Concern | Evidence |
|---|---|
| Heavy context is detected by `estimatedTokens > tokenThreshold`. | `SmartRoutingService.route`, variables `estimatedTokens`, `heavyContext`; property `ai.routing.token-threshold` from `application.yml`. |
| Heavy context routes to reasoning model. | `SmartRoutingService.route`, heavy context branch calls `getReasoningModel()` and returns `RoutingDecision(reasoningModel, name, false)`. |

Report-safe phrasing:
- "The AI Copilot keeps per-session context through persisted chat messages and a JPA-backed LangChain4j memory window, then compacts and sanitizes context before model calls."

Do not claim:
- Do not claim RAG is implemented. These files show chat memory and context compaction, not retrieval-augmented generation over a document/vector store.

---

## 15. Model usage matrix

| Use case | Service/class | Model/provider | Runtime fallback behavior | Evidence / note |
|---|---|---|---|---|
| Normal chat, no heavy context, no likely tool use | `SmartRoutingService.route` | GitHub/OpenAI fallback-named model from `ai.github.fallback-model`, used here as the light/default route | Timeout/error fallback is a separate `AiStreamingService` runtime path | `SmartRoutingService.route` final branch returns `gpt4oFallbackModel`; `AiStreamingService.streamRound` and `handleFirstResponseTimeout` call fallback helpers. |
| Tool-friendly chat / likely tool use | `SmartRoutingService.route` + `AiStreamingService.streamRound` | Gemini primary from `ai.gemini.model-name` | Gemini waterfall, then external fallback | `SmartRoutingService.route` `likelyNeedsTools` branch returns `geminiPrimaryModel`; fallback evidence: `SmartRoutingService.getNextGeminiFallback`, `AiStreamingService.handleFirstResponseTimeout`. |
| Heavy context | `SmartRoutingService.route` | Reasoning model from `getReasoningModel()` | Groq if enabled and bean exists, otherwise GitHub reasoning model | `SmartRoutingService.route` heavy context branch; `SmartRoutingService.getReasoningModel`. |
| Assignment recommendation intent detection in router | `SmartRoutingService.route` + `GatekeeperService.requiresAHP` | Reasoning model for response/tool orchestration when the code variable `requiresAHP` is true | Groq reasoning if enabled, else GitHub reasoning | `SmartRoutingService.resolveRequiresAHP`, `SmartRoutingService.route`, `getReasoningModel`. Keep report wording as assignment recommendation intent/heuristic routing, not full formal AHP runtime. |
| Tool calling | `AiStreamingService.streamRound` + `ToolCallingRegistryService` | Selected route model receives tool specs | Streaming fallback applies if timeout/error occurs | `AiStreamingService.streamRound` attaches `toolSpecifications`; `ToolCallingRegistryService.toolSpecifications`; fallback paths in `streamRound` and `handleFirstResponseTimeout`. |
| Auto-assignment explanation | `AutoAssignmentService.generateExplanation` | `deepSeekModel`, injected with `@Qualifier("deepSeekReasoningModel")` | Textual fallback message only; not the streaming waterfall | `AutoAssignmentService.generateExplanation` catches errors and returns "AI explanation unavailable..." / "AI explanation could not be generated...". |
| Gatekeeper intent classifier | `GatekeeperService.init` / `requiresAHP` | Groq gatekeeper model when `groqGatekeeperModel` bean is available | Keyword fallback | `GatekeeperService.init` uses `ObjectProvider<ChatModel>` with `@Qualifier("groqGatekeeperModel")`; `requiresAHP` falls back to `fallbackRequiresAHP`. |

Report-safe phrasing:
- "Model usage is route-specific: Gemini is primary for tool-friendly streaming, the GitHub/OpenAI-compatible fallback-named model can serve as the light/default route, timeout/error fallback is handled separately at runtime, and Groq can provide reasoning/gatekeeper models when enabled."

---

## 16. AI routing/config property table

Non-secret AI properties visible in `application.yml`:

| Property | Purpose | Default | Env override | Evidence |
|---|---|---|---|---|
| `ai.gemini.model-name` | Gemini primary streaming model | `gemini-2.5-pro` | `AI_GEMINI_MODEL` | `taskpilot-app/src/main/resources/application.yml`, property `ai.gemini.model-name`; consumed by `AiModelConfig.geminiFlashModel` and `SmartRoutingService.geminiModelName`. |
| `ai.gemini.fallback1-model` | Gemini waterfall fallback 1 | `gemini-2.5-flash` | `AI_GEMINI_FALLBACK1_MODEL` | `application.yml`; consumed by `AiModelConfig.geminiFallback1Model` and `SmartRoutingService.getNextGeminiFallback`. |
| `ai.gemini.fallback2-model` | Gemini waterfall fallback 2 | `gemini-2.5-flash-lite` | `AI_GEMINI_FALLBACK2_MODEL` | `application.yml`; consumed by `AiModelConfig.geminiFallback2Model` and `SmartRoutingService.getNextGeminiFallback`. |
| `ai.gemini.fallback3-model` | Gemini waterfall fallback 3 | `gemini-2.0-flash` | `AI_GEMINI_FALLBACK3_MODEL` | `application.yml`; consumed by `AiModelConfig.geminiFallback3Model` and `SmartRoutingService.getNextGeminiFallback`. |
| `ai.gemini.fallback4-model` | Gemini waterfall fallback 4 | `gemini-1.5-pro` | `AI_GEMINI_FALLBACK4_MODEL` | `application.yml`; consumed by `AiModelConfig.geminiFallback4Model` and `SmartRoutingService.getNextGeminiFallback`. |
| `ai.gemini.waterfall-max-attempts` | Max Gemini attempts before external fallback | `3` | `AI_GEMINI_WATERFALL_MAX_ATTEMPTS` | `application.yml`; consumed by `SmartRoutingService.maxGeminiAttempts`. |
| `ai.gemini.timeout-seconds` | Gemini model timeout | `20` | `AI_GEMINI_TIMEOUT_SECONDS` | `application.yml`; consumed by `AiModelConfig.geminiStreamingModel`. |
| `ai.github.fallback-model` | GitHub/OpenAI-compatible fallback-named model; can be selected as the light/default route by `SmartRoutingService` | `gpt-4o` | `AI_GITHUB_FALLBACK_MODEL` | `application.yml`; consumed by `AiModelConfig.gpt4oFallbackModel`, `SmartRoutingService.fallbackModelName`. |
| `ai.github.reasoning-model` | GitHub/OpenAI-compatible reasoning model | `DeepSeek-R1` | `AI_GITHUB_REASONING_MODEL` | `application.yml`; consumed by `AiModelConfig.deepSeekReasoningModel`, `SmartRoutingService.deepSeekReasoningModelName`. |
| `ai.groq.enabled` | Enables Groq beans/routes | `false` | `AI_GROQ_ENABLED` | `application.yml`; consumed by `AiModelConfig` `@ConditionalOnProperty` and `SmartRoutingService.groqEnabled`. |
| `ai.groq.base-url` | Groq OpenAI-compatible API base URL | `https://api.groq.com/openai/v1` | `AI_GROQ_BASE_URL` | `application.yml`; consumed by `AiModelConfig.groqOssReasoningModel`, `groqOssReasoningTextModel`, `groqGatekeeperModel`. |
| `ai.groq.reasoning-model` | Groq reasoning model | `openai/gpt-oss-120b` | `AI_GROQ_REASONING_MODEL` | `application.yml`; consumed by `AiModelConfig.groqOssReasoningModel`, `SmartRoutingService.groqReasoningModelName`. |
| `ai.groq.gatekeeper-model` | Groq intent classifier model | `llama-3.1-8b-instant` | `AI_GROQ_GATEKEEPER_MODEL` | `application.yml`; consumed by `AiModelConfig.groqGatekeeperModel`. |
| `ai.routing.token-threshold` | Heavy-context routing threshold | `6000` | `AI_TOKEN_THRESHOLD` | `application.yml`; consumed by `SmartRoutingService.tokenThreshold`. |
| `ai.routing.tool-keywords` | Keyword list for likely tool use | default comma-separated list | `AI_TOOL_KEYWORDS` | `application.yml`; consumed by `SmartRoutingService.toolKeywordsRaw`. |
| `ai.routing.ahp-fallback-keywords` | Keyword fallback for assignment recommendation intent | default comma-separated list | `AI_AHP_FALLBACK_KEYWORDS` | `application.yml`; consumed by `SmartRoutingService.ahpFallbackKeywordsRaw`. |
| `ai.chat.history-size` | Max message window in session memory | `10` in `application.yml`, `6` fallback in code | `AI_HISTORY_SIZE` | `application.yml`; consumed by `SessionChatMemoryService.memoryMaxMessages`. |
| `ai.chat.memory-max-tokens` | Max request context tokens before compaction | `7000` | `AI_MEMORY_MAX_TOKENS` | `application.yml`; consumed by `AiStreamingService.maxContextTokens`. |
| `ai.chat.context-tail-messages` | Number of recent messages kept in compacted context | `6` | `AI_CONTEXT_TAIL_MESSAGES` | `application.yml`; consumed by `AiStreamingService.contextTailMessages`. |
| `ai.chat.stream-first-response-timeout-seconds` | First-token timeout before fallback path | `3` in `application.yml`, `25` fallback in code | `AI_STREAM_FIRST_RESPONSE_TIMEOUT_SECONDS` | `application.yml`; consumed by `AiStreamingService.streamFirstResponseTimeoutSeconds`. |

Observed local model-only overrides:

| Env override | Observed local value | Evidence |
|---|---|---|
| `AI_GEMINI_MODEL` | `gemini-3.1-flash-lite-preview` | `taskpilot/.env`, model-only line. |
| `AI_GITHUB_FALLBACK_MODEL` | `gpt-4.1-mini` | `taskpilot/.env`, model-only line. |
| `AI_GROQ_ENABLED` | `true` | `taskpilot/.env`, model-only line. |
| `AI_GROQ_GATEKEEPER_MODEL` | `llama-3.1-8b-instant` | `taskpilot/.env`, model-only line. |

Do not include:
- Secret-bearing variables such as API keys, tokens, database passwords, or object storage credentials.

---

## 17. AI safety and permission guard

AI tool safety is implemented through read/write separation, human-in-the-loop confirmation for write tools, user/session ownership checks, and delegated domain authorization through ports/services.

1. Read vs write tools.

| Tool category | Tool methods | Evidence |
|---|---|---|
| Read/query tools | `getMyProjects`, `getProjectStatus`, `getMemberWorkload`, `getProjectMembers`, `getMemberWorkloadByMemberId`, `getTaskDetails`, `findBestCandidates`, `recommendAssignmentCandidates`, `getUpcomingProjects`, `findProjectsDue`, `getTasksByProject`, `getUnassignedTasksByProject`, `getSubtasks`, `getTaskComments`, `getSprintsByProject`, `getSprintBacklog`, `getSprintBoard` | `TaskPilotAiTools.java`, `@Tool` methods listed. |
| Write/deferred tools | `assignTaskToMember`, `recommendAndAssignTask`, `updateTaskStatus`, `createTask`, `createSprint`, `startSprint`, `completeSprint`, `assignTaskToSprint` | `TaskPilotAiTools.java`, each method returns `pendingAiActionService.create(...)`. |
| Confirm/cancel tools | `confirmPendingAction`, `cancelPendingAction` | `TaskPilotAiTools.confirmPendingAction`, `TaskPilotAiTools.cancelPendingAction`. |

2. Write actions require pending confirmation.

| Safety mechanism | Evidence |
|---|---|
| Write tools capture a summary, arguments, optional preview, and executor instead of immediately executing. | `TaskPilotAiTools.assignTaskToMember`, `recommendAndAssignTask`, `updateTaskStatus`, `createTask`, `createSprint`, `startSprint`, `completeSprint`, `assignTaskToSprint`; all call `PendingAiActionService.create`. |
| Confirmation requires the exact action id plus confirmation keyword in current user input. | `TaskPilotAiTools.confirmPendingAction`, `TaskPilotAiTools.isCurrentUserConfirming`. |
| Pending action has 10 minute TTL. | `PendingAiActionService.ACTION_TTL`. |
| Action confirmation checks same user and same session before execution. | `PendingAiActionService.confirm`; checks `action.userId().equals(userId)` and `action.sessionId().equals(sessionId)`. |
| Action cancellation checks ownership before removal. | `PendingAiActionService.cancel`. |

3. Tool execution context prevents tools from relying on model-provided user identity.

| Safety mechanism | Evidence |
|---|---|
| Runtime user/session/input context is set server-side before tool execution. | `AiStreamingService.executeTools`, call to `ToolExecutionContext.set(new ToolExecutionContext.Context(userId, sessionId, userInput))`. |
| Tool methods read current user/session from `ToolExecutionContext`. | `TaskPilotAiTools` methods call `ToolExecutionContext.requireUserId()` and write tools also call `ToolExecutionContext.requireSessionId()`. |

4. Domain permission checks are delegated through ports and downstream services.

| Safety mechanism | Evidence |
|---|---|
| AI tools call contract ports rather than directly mutating repositories. | `TaskPilotAiTools` fields `TaskCommandPort`, `ProjectInsightsPort`, `MemberAnalyticsPort`, `SprintQueryPort`, `TaskCommentQueryPort`, `ProjectMemberPort`. |
| Assignment/scoring reads project and user data through ports. | `AutoAssignmentService` fields `ProjectMemberPort`, `UserSkillPort`, `UserPort`, `ProjectPort`. |
| Report should verify concrete downstream authorization in project/user modules before making full permission claims. | This scoped file set confirms port delegation, not every downstream service check. |

5. Prompt injection / tool misuse risk.

| Risk | Existing guard | Evidence |
|---|---|---|
| Model attempts to directly perform writes. | Write tools return pending confirmation objects instead of direct execution. | `TaskPilotAiTools` write methods + `PendingAiActionService.create`. |
| Model invents a confirmation. | `confirmPendingAction` requires action id and confirmation keyword in the actual user input, not only in model state. | `TaskPilotAiTools.isCurrentUserConfirming`. |
| Repeated tool loops. | Tool rounds and repeated same-tool executions are bounded. | `AiStreamingService.MAX_TOOL_ROUNDS`, `MAX_CONSECUTIVE_SAME_TOOL_EXECUTIONS`, `streamRound`. |

Report-safe phrasing:
- "AI write tools use a human-in-the-loop guard with server-side user/session ownership checks. Read/write authorization ultimately depends on the downstream port implementations and domain services."

Do not claim:
- Do not claim prompt injection is fully solved. The code has mitigation layers, not a formal prompt-injection proof.

---

## 18. Suggested AI diagrams

Recommended diagrams for the report:

1. AI streaming chat sequence
- Actor/user -> `AiChatController` -> `AiStreamingService.streamChat` -> `SessionChatMemoryService` -> `SmartRoutingService.route` -> selected model -> SSE events -> `AiLogService.saveLog`.
- Evidence: `AiStreamingService.streamChat`, `streamRound`, `safeSend`, `AiLogService.saveLog`.

2. Smart routing decision flow
- Normalize input -> detect direct assignment/pending confirmation -> gatekeeper/keyword assignment recommendation intent -> token threshold -> likely tool keywords -> selected model.
- Evidence: `SmartRoutingService.route`, `isDirectAssignmentExecution`, `isPendingActionConfirmation`, `resolveRequiresAHP`, `getReasoningModel`.

3. Tool calling sequence
- Model returns `ToolExecutionRequest` -> `AiStreamingService.executeTools` -> `ToolCallingRegistryService.execute` -> `TaskPilotAiTools` -> contract port -> tool result injected into next model round.
- Evidence: `AiStreamingService.executeTools`, `ToolCallingRegistryService.execute`, `TaskPilotAiTools`.

4. Pending action confirmation sequence
- Write tool called -> `PendingAiActionService.create` -> confirmation payload returned -> user confirms with action id -> `TaskPilotAiTools.confirmPendingAction` -> `PendingAiActionService.confirm` -> stored executor runs.
- Evidence: `TaskPilotAiTools` write tools, `confirmPendingAction`, `PendingAiActionService.create`, `PendingAiActionService.confirm`.

5. Auto-assignment scoring pipeline
- Required skills/project -> `ProjectPort` heuristic mode -> `ProjectMemberPort` members/performance -> `UserPort` profile/status -> `UserSkillPort` skills -> raw scores -> strategy score -> sorted candidates -> optional explanation/log.
- Evidence: `AutoAssignmentService.recommendCandidates`, `computeCandidates`, `buildRawCandidate`, `calculateFitScore`, `calculateTimeDecayPerformanceScore`, `buildCandidateScore`, `generateExplanation`, `saveAutoAssignLog`.

6. Model fallback waterfall diagram
- Gemini primary -> Gemini fallback 1 -> Gemini fallback 2 -> optional fallback 3/4 depending `waterfall-max-attempts` -> GitHub/OpenAI fallback.
- Evidence: `SmartRoutingService.getNextGeminiFallback`, `maxGeminiAttempts`, `externalFallbackAfter`; trigger evidence in `AiStreamingService.handleFirstResponseTimeout` and `streamRound`.

7. Context management diagram
- `chat_messages` + `ai_chat_memories` -> `SessionChatMemoryService` -> system prompt injection -> context compaction -> history sanitization -> model request.
- Evidence: `SessionChatMemoryService`, `JpaChatMemoryStore`, `AiChatMemoryEntity`, `AiStreamingService.compactHistoryForRequest`, `sanitizeHistoryForTools`.

---

## 19. AI module limitations for the report

| Limitation | Evidence | Report wording |
|---|---|---|
| Smart routing is rule-based, not adaptive/learned routing. | `SmartRoutingService.route` uses explicit branching over assignment recommendation intent, token threshold, and keyword checks. | "The router is rule-based." |
| Pending actions are in-memory and not durable across backend restarts. | `PendingAiActionService.actions` is a `ConcurrentHashMap`; no repository is used. | "Pending confirmations are runtime-memory state." |
| Runtime timeout/error fallback improves resilience but does not guarantee success. | `AiStreamingService.streamRound`, `handleFirstResponseTimeout`, and `forceTextOnlyResponse` include `Phase.FAILED` and `error` paths. | "Runtime fallback is best-effort." |
| Auto-assignment is heuristic scoring, not proven full formal runtime AHP from this scoped evidence. | `AutoAssignmentService.calculateFitScore`, `calculateTimeDecayPerformanceScore`, `buildCandidateScore`; strategy scoring through `HeuristicStrategyFactory`. | "Use 'heuristic/AHP-inspired scoring' unless full AHP artifacts are documented elsewhere." |
| RAG is not implemented in the inspected AI files. | No vector store/retriever/document ingestion appears in inspected AI context files; context handling is chat memory and compaction. | "RAG can be listed as future work, not current implementation." |
| Tool permission safety relies partly on downstream port implementations/domain services. | AI module calls ports such as `TaskCommandPort`, `SprintQueryPort`, `ProjectInsightsPort`; scoped read did not inspect all implementations. | "The AI module delegates domain authorization through ports." |
| Gatekeeper has keyword fallback and may not always use model classification. | `GatekeeperService.init` leaves `gatekeeperAgent` null when Groq gatekeeper bean is unavailable; `requiresAHP` then calls `fallbackRequiresAHP`. | "Gatekeeper is model-backed when available, with keyword fallback." |
| Auto-assignment explanation has local textual fallback, not the same stream fallback waterfall. | `AutoAssignmentService.generateExplanation` catches model errors and returns fallback text. | "Explanation generation is separate from the streaming fallback pipeline." |
| AI test coverage was not verified in this focused pass. | This task intentionally did not scan tests or whole repo. | "Do not state test coverage completeness from this note alone." |

Report-safe conclusion:
- "The AI module is a rule-routed, tool-augmented Copilot architecture with provider-configured models, bounded tool execution, human confirmation for writes, context compaction, and Port & Adapter-inspired inter-module communication. Its routing and assignment recommendation logic should be described as heuristic and pattern-like where the source does not prove a strict formal pattern."
