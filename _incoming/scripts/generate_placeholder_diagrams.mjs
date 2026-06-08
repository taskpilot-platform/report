import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const chapter2Dir = path.join(root, "asset", "chapter2");
const diagramsDir = path.join(root, "asset", "assets", "diagrams");

const commonInit = `---
config:
  theme: base
  themeVariables:
    fontFamily: Inter, Arial, sans-serif
    primaryColor: '#f8fafc'
    primaryTextColor: '#172033'
    primaryBorderColor: '#65758b'
    lineColor: '#475569'
    secondaryColor: '#e8eef8'
    tertiaryColor: '#ffffff'
---
`;

const style = `
classDef person fill:#fff7ed,stroke:#f97316,color:#7c2d12,stroke-width:1px;
classDef app fill:#eef6ff,stroke:#2563eb,color:#172554,stroke-width:1px;
classDef backend fill:#eef2ff,stroke:#4f46e5,color:#1e1b4b,stroke-width:1px;
classDef data fill:#ecfdf5,stroke:#059669,color:#064e3b,stroke-width:1px;
classDef external fill:#fdf2f8,stroke:#db2777,color:#831843,stroke-width:1px;
classDef process fill:#f8fafc,stroke:#64748b,color:#0f172a,stroke-width:1px;
classDef warn fill:#fff7ed,stroke:#ea580c,color:#7c2d12,stroke-width:1px;
classDef ok fill:#f0fdf4,stroke:#16a34a,color:#14532d,stroke-width:1px;
`;

const diagrams = {
  [path.join(chapter2Dir, "ch2_01_agile_scrum.mmd")]: `${commonInit}flowchart LR
    Idea[Ý tưởng / yêu cầu] --> Backlog[Product backlog]
    Backlog --> Plan[Sprint planning]
    Plan --> Sprint[Sprint 1-4 tuần]
    Sprint --> Daily[Daily scrum]
    Daily --> Build[Thiết kế, lập trình, kiểm thử]
    Build --> Review[Sprint review]
    Review --> Retro[Retrospective]
    Retro --> Backlog
    Review --> Release[Increment có thể phát hành]
${style}`,

  [path.join(chapter2Dir, "ch2_02_scrum_sprint.mmd")]: `${commonInit}flowchart TD
    PB[(Product backlog)] --> SP[Sprint planning]
    SP --> SB[(Sprint backlog)]
    SB --> SPRINT{{Sprint}}
    SPRINT --> DS[Daily scrum]
    DS --> DEV[Phát triển và kiểm thử]
    DEV --> INC[Increment]
    INC --> SR[Sprint review]
    SR --> RETRO[Sprint retrospective]
    RETRO --> PB
${style}`,

  [path.join(chapter2Dir, "ch2_03_kanban.mmd")]: `${commonInit}flowchart LR
    subgraph Board[Bảng Kanban]
      direction LR
      subgraph Todo[To Do]
        T1[Task A]
        T2[Task B]
        T3[Task C]
      end
      subgraph Doing[In Progress - WIP 2]
        D1[Task D]
        D2[Task E]
      end
      subgraph Review[Review]
        R1[Task F]
      end
      subgraph Done[Done]
        X1[Task G]
        X2[Task H]
      end
    end
    Todo --> Doing --> Review --> Done
${style}`,

  [path.join(chapter2Dir, "ch2_04_function_calling.mmd")]: `${commonInit}flowchart LR
    U[Người dùng] --> P[Prompt / yêu cầu]
    P --> M[LLM phân tích ý định]
    M -->|Cần dữ liệu| TC[Đề xuất tool call + tham số]
    TC --> V[Backend validate schema và quyền]
    V --> FN[Thực thi hàm nghiệp vụ]
    FN --> R[Kết quả có cấu trúc]
    R --> M
    M --> A[Phản hồi cuối cho người dùng]
${style}`,

  [path.join(chapter2Dir, "ch2_05_human_in_the_loop.mmd")]: `${commonInit}flowchart LR
    User[Người dùng yêu cầu AI] --> AI[AI đề xuất thao tác ghi]
    AI --> Backend[Backend tạo pending action]
    Backend --> Preview[Frontend hiển thị preview]
    Preview --> Decision{Người dùng xác nhận?}
    Decision -->|Có| Execute[Backend kiểm tra quyền và thực thi]
    Decision -->|Không| Cancel[Hủy thao tác]
    Execute --> Audit[Ghi log / cập nhật dữ liệu]
${style}`,

  [path.join(chapter2Dir, "ch2_06_weighted_scoring_ahp.mmd")]: `${commonInit}flowchart LR
    Criteria[Tiêu chí: Fit, Load, Performance] --> AHP[AHP xác định trọng số ban đầu]
    AHP --> Weights[w_fit, w_load, w_perf]
    Candidate[Ứng viên + dữ liệu task] --> Normalize[Chuẩn hóa điểm F, L, P]
    Weights --> Score[Score = w_fit*F - w_load*L + w_perf*P]
    Normalize --> Score
    Score --> Rank[Xếp hạng ứng viên]
    Rank --> Explain[Giải thích đề xuất]
${style}`,

  [path.join(chapter2Dir, "ch2_07_modular_monolith.mmd")]: `${commonInit}flowchart TB
    subgraph Runtime[Ứng dụng triển khai như một runtime duy nhất]
      direction TB
      App[taskpilot-app / Spring Boot entrypoint]
      subgraph Modules[Ranh giới module nghiệp vụ]
        Users[taskpilot-users]
        Projects[taskpilot-projects]
        AI[taskpilot-ai]
        Infra[taskpilot-infrastructure]
      end
      Contracts[taskpilot-contracts / internal ports]
    end
    App --> Users
    App --> Projects
    App --> AI
    App --> Infra
    AI --> Contracts
    Projects --> Contracts
    Users --> Contracts
    Contracts -. adapter triển khai .-> Users
    Contracts -. adapter triển khai .-> Projects
${style}`,

  [path.join(chapter2Dir, "ch2_19_sse.mmd")]: `${commonInit}sequenceDiagram
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database
    FE->>BE: Mở kết nối SSE
    BE-->>FE: event: connected
    loop Khi có sự kiện mới
      BE->>DB: Lưu notification/comment/AI state
      BE-->>FE: event: update chunk
      FE->>FE: Cập nhật giao diện
    end
    BE-->>FE: heartbeat định kỳ`,

  [path.join(chapter2Dir, "ch2_22_cicd_deployment.mmd")]: `${commonInit}flowchart LR
    Dev[Developer push code] --> GH[GitHub repository]
    GH --> GA[GitHub Actions]
    GA --> Test[Build và test]
    Test --> FE[Build frontend]
    Test --> BE[Build backend Docker]
    FE --> Netlify[Netlify / Vercel]
    BE --> HF[Hugging Face Space]
    HF --> Services[(Supabase, Brevo, OneSignal, AI providers)]
${style}`,

  [path.join(diagramsDir, "ch3_01_jira_workflow.mmd")]: `${commonInit}flowchart LR
    Backlog[Jira backlog] --> Sprint[Sprint]
    Sprint --> Todo[To Do]
    Todo --> Progress[In Progress]
    Progress --> Review[Code Review / QA]
    Review --> Done[Done]
    Sprint --> Reports[Burndown / Reports]
    Sprint --> Workflow[Custom workflow]
${style}`,

  [path.join(diagramsDir, "ch3_01_trello_kanban.mmd")]: `${commonInit}flowchart LR
    subgraph Trello[Trello board]
      direction LR
      subgraph L1[Backlog]
        A[Card: login]
        B[Card: profile]
      end
      subgraph L2[Doing]
        C[Card: kanban UI]
      end
      subgraph L3[Review]
        D[Card: notification]
      end
      subgraph L4[Done]
        E[Card: deploy]
      end
    end
    L1 --> L2 --> L3 --> L4
${style}`,

  [path.join(diagramsDir, "ch3_01_asana_views.mmd")]: `${commonInit}flowchart TB
    Project[Asana project] --> List[List view]
    Project --> Board[Board view]
    Project --> Timeline[Timeline]
    Project --> Calendar[Calendar]
    Project --> Workload[Workload]
    List --> Tasks[Task, assignee, due date]
    Board --> Status[Theo dõi trạng thái]
    Timeline --> Plan[Lập kế hoạch phụ thuộc]
${style}`,

  [path.join(diagramsDir, "ch3_02_analysis_design_process.mmd")]: `${commonInit}flowchart LR
    Survey[Khảo sát Jira, Trello, Asana] --> Requirements[Xác định yêu cầu]
    Requirements --> UseCase[Use case và actor]
    UseCase --> Architecture[Kiến trúc tổng quan]
    Architecture --> DB[Thiết kế CSDL]
    Architecture --> Flows[Sequence / activity diagrams]
    Flows --> AI[Thiết kế AI Copilot và assignment]
${style}`,

  [path.join(diagramsDir, "ch3_02_testing_deployment_process.mmd")]: `${commonInit}flowchart LR
    Code[Hoàn thiện chức năng] --> API[Test API bằng Postman]
    Code --> UI[Test UI trên trình duyệt]
    Code --> DBCheck[Kiểm tra dữ liệu bằng DBeaver/Supabase]
    API --> CI[GitHub Actions]
    UI --> CI
    DBCheck --> CI
    CI --> Frontend[Deploy frontend Netlify/Vercel]
    CI --> Backend[Deploy backend Hugging Face Space]
${style}`,

  [path.join(diagramsDir, "ch3_03_system_context.mmd")]: `${commonInit}flowchart LR
    Users[Guest / Admin / PM / Member]:::person --> Browser[Trình duyệt web]:::app
    subgraph TP[TaskPilot system boundary]
      direction LR
      FE[React SPA]:::app
      BE[Spring Boot Modular Monolith]:::backend
      FE -->|REST API / SSE| BE
    end
    Browser --> FE
    BE --> PG[(Supabase PostgreSQL)]:::data
    BE --> Storage[(Supabase Storage)]:::data
    BE --> Redis[(Redis)]:::data
    BE --> Brevo[Brevo Email]:::external
    BE --> OneSignal[OneSignal Push]:::external
    BE --> Providers[Gemini / GitHub Models / Groq]:::external
    GitHub[GitHub Actions]:::external --> TP
${style}`,

  [path.join(diagramsDir, "ch3_03_interaction_overview.mmd")]: `${commonInit}flowchart LR
    FE[Frontend React SPA] -->|REST CRUD| BE[Backend]
    BE --> Auth[JWT + authorization]
    Auth --> Domain[Users / Projects / AI modules]
    Domain --> DB[(PostgreSQL)]
    Domain --> Storage[(Object Storage)]
    Domain --> Email[Brevo]
    Domain --> Push[OneSignal]
    Domain --> AI[AI Providers]
    BE -->|SSE notification/comment/AI stream| FE
${style}`,

  [path.join(diagramsDir, "ch3_03_frontend_spa_architecture.mmd")]: `${commonInit}flowchart TB
    subgraph SPA[React + TypeScript + Vite SPA]
      Pages[Pages / Screens]
      Router[Routing + ProtectedRoute]
      State[Zustand state]
      API[API services / HTTP client]
      SSE[SSE client]
      UI[UI components + Tailwind/Radix/Lucide]
      Push[OneSignal Web SDK]
    end
    Router --> Pages
    Pages --> UI
    Pages --> State
    Pages --> API
    Pages --> SSE
    Push --> State
    API --> Backend[Backend REST API]
    SSE --> Stream[Backend SSE streams]
${style}`,

  [path.join(diagramsDir, "ch3_03_frontend_rest_sse_flow.mmd")]: `${commonInit}sequenceDiagram
    participant FE as Frontend
    participant API as HTTP Client
    participant BE as Backend
    participant SSE as SSE Stream
    FE->>API: Gửi thao tác CRUD
    API->>BE: REST + Bearer JWT
    BE-->>API: JSON response
    API-->>FE: Cập nhật state
    FE->>SSE: Mở stream realtime
    SSE-->>FE: notification/comment/AI chunk
    FE->>FE: Render cập nhật tức thời`,

  [path.join(diagramsDir, "ch3_06_backend_modular_monolith.mmd")]: `${commonInit}flowchart LR
    User[Frontend / Client]:::person --> Gateway[REST Controllers + SSE endpoints]:::app
    subgraph Runtime[Backend Spring Boot runtime]
      direction TB
      App[taskpilot-app]:::backend
      subgraph Modules[Maven modules]
        Users[taskpilot-users]:::backend
        Projects[taskpilot-projects]:::backend
        AI[taskpilot-ai]:::backend
        Contracts[taskpilot-contracts]:::process
        Infra[taskpilot-infrastructure]:::backend
      end
    end
    Gateway --> App
    App --> Users
    App --> Projects
    App --> AI
    App --> Infra
    AI --> Contracts
    Projects --> Contracts
    Users --> Contracts
    Infra --> DB[(PostgreSQL / Redis / Storage)]:::data
    AI --> Providers[AI providers]:::external
${style}`,

  [path.join(diagramsDir, "ch3_07_contracts_communication.mmd")]: `${commonInit}flowchart LR
    AI[taskpilot-ai] --> Ports[taskpilot-contracts: port interfaces + DTO]
    Projects[taskpilot-projects] --> Ports
    Users[taskpilot-users] --> Ports
    Ports -. UserModuleAdapter .-> Users
    Ports -. ProjectModuleAdapter .-> Projects
    Ports -. AiQueryModuleAdapter .-> Projects
    Projects --> Rules[Domain rules + permission checks]
    Users --> Identity[Identity / skill / notification rules]
${style}`,

  [path.join(diagramsDir, "ch3_07_port_adapter_model.mmd")]: `${commonInit}flowchart LR
    subgraph Consumer[AI module]
      Chat[Chat / tool workflow]
      Need[Needs project, task, user context]
    end
    subgraph Contracts[taskpilot-contracts]
      ProjectPort[ProjectInsightsPort]
      MemberPort[MemberAnalyticsPort]
      UserPort[UserSkillPort / UserProfilePort]
      TaskPort[TaskCommandPort]
    end
    subgraph Providers[Owning modules]
      ProjectAdapter[Project adapters in projects module]
      UserAdapter[User adapters in users module]
    end
    Chat --> Need --> ProjectPort
    Need --> UserPort
    Need --> TaskPort
    ProjectPort -. implemented by .-> ProjectAdapter
    MemberPort -. implemented by .-> ProjectAdapter
    TaskPort -. implemented by .-> ProjectAdapter
    UserPort -. implemented by .-> UserAdapter
${style}`,

  [path.join(diagramsDir, "ch3_08_flyway_change_management.mmd")]: `${commonInit}flowchart LR
    Dev[Developer tạo migration V__*.sql] --> Repo[Git repository]
    Repo --> Build[Build / deploy backend]
    Build --> Flyway[Flyway startup validation]
    Flyway --> History[(flyway_schema_history)]
    Flyway --> Apply[Apply pending migrations]
    Apply --> Schema[(PostgreSQL schema)]
    History --> Validate[Checksum + success state]
    Validate --> App[Spring Boot chạy với schema hợp lệ]
${style}`,

  [path.join(diagramsDir, "ch3_09_auth_authorization_overview.mmd")]: `${commonInit}flowchart LR
    Login[Đăng nhập] --> Auth[Authenticate email/password]
    Auth --> JWT[Cấp access JWT + refresh token]
    JWT --> Request[Request kèm Bearer token]
    Request --> Filter[JWT filter + blocklist check]
    Filter --> SystemRole[System role: ADMIN / USER]
    SystemRole --> ProjectRole[Project role: MANAGER / MEMBER]
    ProjectRole --> BusinessRule[Service kiểm tra membership và rule]
    BusinessRule --> Resource[Tài nguyên project/task/comment/AI]
${style}`,

  [path.join(diagramsDir, "ch3_10_realtime_notification_overview.mmd")]: `${commonInit}flowchart LR
    Event[Sự kiện nghiệp vụ] --> Save[(notifications table)]
    Save --> SSE[SSE emitter theo user]
    Save --> Push[OneSignal nếu cấu hình]
    SSE --> Online[User đang mở app]
    Push --> Offline[Browser/device đã đăng ký]
    Online --> UI[Cập nhật badge / notification panel]
    Offline --> Browser[Push notification]
${style}`,

  [path.join(diagramsDir, "ch3_10_comment_realtime_flow.mmd")]: `${commonInit}sequenceDiagram
    participant U as User A
    participant FE as Frontend
    participant BE as Backend
    participant DB as PostgreSQL
    participant O as Other clients
    U->>FE: Tạo/cập nhật/xóa comment
    FE->>BE: REST request + JWT
    BE->>BE: Kiểm tra membership/author/manager
    BE->>DB: Lưu comment và mention
    BE-->>FE: Kết quả thao tác
    BE-->>O: SSE comment event
    O->>O: Cập nhật danh sách comment`,

  [path.join(diagramsDir, "ch3_10_onesignal_push_flow.mmd")]: `${commonInit}flowchart LR
    FE[Frontend init OneSignal SDK] --> Sub[Browser subscription]
    Sub --> Link[Liên kết subscription với user id]
    Event[Sự kiện task/project] --> BE[Backend tạo notification]
    BE --> DB[(notifications)]
    BE --> OS[OneSignal REST API]
    OS --> Browser[Browser push notification]
${style}`,

  [path.join(diagramsDir, "ch3_11_ai_copilot_architecture.mmd")]: `${commonInit}flowchart LR
    User[Người dùng]:::person --> FE[AI Chat UI]:::app
    FE -->|REST / SSE| AI[taskpilot-ai module]:::backend
    subgraph Backend[Backend kiểm soát]
      AI --> Memory[Session, messages, memories]
      AI --> Router[Smart routing]
      AI --> Tools[Tool registry]
      AI --> Logs[AI logs / requests]
      Tools --> Contracts[taskpilot-contracts]
      Contracts --> Projects[Projects module]
      Contracts --> Users[Users module]
      Tools --> Pending[Pending action confirmation]
    end
    Router --> Providers[Gemini / GitHub Models / Groq]:::external
    Projects --> DB[(PostgreSQL)]:::data
    Users --> DB
${style}`,

  [path.join(diagramsDir, "ch3_11_context_building.mmd")]: `${commonInit}flowchart LR
    Request[User message] --> Session[Load chat session]
    Session --> History[Recent messages]
    History --> Memory[Session memory snapshot]
    Request --> Scope[Resolve project/user scope]
    Scope --> Contracts[Fetch allowed domain context]
    Contracts --> Prompt[Compose system prompt + context + tools]
    Prompt --> Trim[Summarize / trim if too long]
    Trim --> Model[Call selected AI model]
${style}`,

  [path.join(diagramsDir, "ch3_11_smart_routing.mmd")]: `${commonInit}flowchart LR
    Request[AI request] --> Gate[Gatekeeper classify intent]
    Gate --> NeedTool{Need tool?}
    NeedTool -->|Yes| ToolRoute[Tool-aware route]
    NeedTool -->|No| Complexity{Large context / reasoning?}
    Complexity -->|No| Light[Light/default route]
    Complexity -->|Yes| Reasoning[Reasoning route]
    ToolRoute --> Provider[Selected provider/model]
    Light --> Provider
    Reasoning --> Provider
${style}`,

  [path.join(diagramsDir, "ch3_11_auto_fallback.mmd")]: `${commonInit}flowchart LR
    Primary[Primary provider/model] --> Call[Streaming call]
    Call --> Status{Timeout or error?}
    Status -->|No| Done[Stream response to frontend]
    Status -->|Yes| Fallback1[Fallback model/provider]
    Fallback1 --> Status2{Still failed?}
    Status2 -->|No| Done
    Status2 -->|Yes| Fail[Mark ai_chat_request failed]
    Fail --> Log[Write AI log metadata]
${style}`,

  [path.join(diagramsDir, "ch3_11_tool_registry.mmd")]: `${commonInit}flowchart TB
    Registry[Tool Calling Registry] --> Read[Read tools]
    Registry --> Write[Write-action tools]
    Registry --> Control[Confirm / cancel tools]
    Read --> ProjectQuery[Project / task / workload query]
    Read --> CommentQuery[Comment / sprint query]
    Write --> Pending[Create pending action]
    Pending --> Confirm[User confirmation]
    Confirm --> Domain[Domain service through ports]
    Domain --> DB[(PostgreSQL)]
${style}`,

  [path.join(diagramsDir, "ch3_11_safety_layers.mmd")]: `${commonInit}flowchart LR
    User[Authenticated user] --> Scope[User/session scope]
    Scope --> Permission[Project membership and role check]
    Permission --> ToolAllow[Tool whitelist]
    ToolAllow --> Validate[Parameter validation]
    Validate --> HITL[Pending confirmation for writes]
    HITL --> Domain[Domain rule execution]
    Domain --> Logging[AI/action logging]
${style}`,

  [path.join(diagramsDir, "ch3_11_ai_log_feedback.mmd")]: `${commonInit}flowchart LR
    Request[AI chat request] --> Lifecycle[(ai_chat_requests)]
    Request --> Process[Routing / tools / provider call]
    Process --> Log[(ai_logs)]
    Process --> Response[AI response / SSE stream]
    Response --> User[User reads result]
    User --> Feedback[Accept / reject / pending feedback]
    Feedback --> Log
${style}`,

  [path.join(diagramsDir, "ch3_11_design_patterns.mmd")]: `${commonInit}flowchart TB
    Copilot[AI Copilot design] --> Strategy[Strategy: routing and heuristic modes]
    Copilot --> Registry[Registry: tool catalog]
    Copilot --> Adapter[Adapter: providers and module contracts]
    Copilot --> Command[Command-like: pending action]
    Copilot --> Facade[Facade/Service layer: orchestration]
    Copilot --> Ports[Port and Adapter: domain context access]
${style}`,

  [path.join(diagramsDir, "ch3_12_assignment_recommendation_process.mmd")]: `${commonInit}flowchart LR
    Task[Task cần phân công] --> Members[Lấy thành viên project]
    Members --> Filter[Loại DEACTIVATED / OOO]
    Filter --> Data[Thu thập skill, workload, performance]
    Data --> Normalize[Tính và chuẩn hóa F, L, P]
    Normalize --> Mode[Chọn mode BALANCED / URGENT / TRAINING]
    Mode --> Score[Score = w_fit*F - w_load*L + w_perf*P]
    Score --> Rank[Xếp hạng ứng viên]
    Rank --> Explain[Trả điểm thành phần và giải thích]
    Explain --> Confirm{Qua AI có ghi dữ liệu?}
    Confirm -->|Có| Pending[Pending confirmation]
    Confirm -->|Không| Result[Danh sách gợi ý]
${style}`,

  [path.join(diagramsDir, "ch3_12_ahp_role_weights.mmd")]: `${commonInit}flowchart LR
    Criteria[Load, Fit, Performance] --> Pairwise[Ma trận so sánh cặp AHP]
    Pairwise --> Consistency[Kiểm tra CR]
    Consistency --> Initial[Vector trọng số ban đầu]
    Initial --> Settings[(system_settings heuristic.weights)]
    Settings --> Runtime[Runtime weighted scoring]
    Runtime --> Modes[BALANCED / URGENT / TRAINING]
${style}`,

  [path.join(diagramsDir, "ch3_13_deployment_architecture.mmd")]: `${commonInit}flowchart LR
    User[User browser]:::person --> FEHost[Netlify / Vercel frontend hosting]:::app
    FEHost --> SPA[React/Vite static SPA]:::app
    SPA -->|REST API / SSE| HF[Hugging Face Space Docker backend]:::backend
    subgraph Managed[Managed services]
      PG[(Supabase PostgreSQL)]:::data
      Storage[(Supabase S3 Storage)]:::data
      Brevo[Brevo SMTP]:::external
      OS[OneSignal]:::external
      AI[Gemini / GitHub Models / Groq]:::external
    end
    HF --> PG
    HF --> Storage
    HF --> Brevo
    HF --> OS
    HF --> AI
    GH[GitHub Actions]:::external --> HF
${style}`,

  [path.join(diagramsDir, "ch3_13_external_connection_flow.mmd")]: `${commonInit}flowchart LR
    FE[Frontend SPA] -->|REST| BE[Backend]
    BE --> DB[(PostgreSQL)]
    BE --> S3[(Supabase Storage)]
    BE --> Mail[Brevo SMTP]
    BE --> Push[OneSignal API]
    BE --> AI[AI providers]
    BE -->|SSE| FE
    Push --> Browser[Browser/device push]
${style}`,

  [path.join(diagramsDir, "ch3_13_hf_backend_container_flow.mmd")]: `${commonInit}flowchart LR
    Source[Backend source] --> Build[Maven build stage - Java 21]
    Build --> Jar[taskpilot-app JAR]
    Jar --> Runtime[JRE Alpine runtime stage]
    Runtime --> User[Non-root appuser]
    User --> Port[SERVER_PORT / EXPOSE 7860]
    Port --> HF[Hugging Face Space serves container]
${style}`,

  [path.join(diagramsDir, "ch3_13_brevo_reset_email_flow.mmd")]: `${commonInit}sequenceDiagram
    participant FE as Frontend
    participant BE as Backend
    participant DB as PostgreSQL
    participant Mail as Brevo SMTP
    participant U as User email
    FE->>BE: Yêu cầu quên mật khẩu
    BE->>DB: Tạo password reset token
    BE->>Mail: Gửi email reset password
    Mail-->>U: Email chứa reset link
    U->>FE: Mở link và nhập mật khẩu mới
    FE->>BE: Submit token + password mới
    BE->>DB: Kiểm tra token và cập nhật password_hash`,

  [path.join(diagramsDir, "ch3_13_onesignal_push_flow.mmd")]: `${commonInit}flowchart LR
    SPA[Frontend OneSignal SDK] --> Subscribe[Browser subscribe]
    Subscribe --> ExternalId[Set external user id]
    Event[Backend detects notification event] --> Notification[(notifications)]
    Event --> REST[OneSignal REST API]
    REST --> Delivery[Push delivery]
    Delivery --> Browser[User browser/device]
${style}`,

  [path.join(diagramsDir, "ch3_13_github_actions_cicd.mmd")]: `${commonInit}flowchart LR
    Push[Push / PR / manual trigger] --> Checkout[Checkout code]
    Checkout --> Java[Setup Java 21]
    Java --> Test[mvn clean test]
    Test --> Gate{Main branch deploy?}
    Gate -->|Yes| Sync[Sync to Hugging Face Space]
    Gate -->|No| Report[Report CI result]
    Sync --> Backend[Backend Space rebuilds Docker]
${style}`,
};

for (const [file, content] of Object.entries(diagrams)) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${content.trim()}\n`, "utf8");
}

const configPath = path.join(root, "asset", "assets", "diagrams", "mermaid-render-config.json");
fs.writeFileSync(
  configPath,
  `${JSON.stringify(
    {
      theme: "base",
      themeVariables: {
        fontFamily: "Inter, Arial, sans-serif",
        primaryColor: "#f8fafc",
        primaryTextColor: "#172033",
        primaryBorderColor: "#65758b",
        lineColor: "#475569",
        secondaryColor: "#e8eef8",
        tertiaryColor: "#ffffff",
      },
      flowchart: { htmlLabels: true, curve: "stepAfter", padding: 18 },
      sequence: { mirrorActors: false, showSequenceNumbers: false },
    },
    null,
    2,
  )}\n`,
  "utf8",
);

console.log(`Generated ${Object.keys(diagrams).length} Mermaid source files.`);
