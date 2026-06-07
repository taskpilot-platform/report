# MISSING_ASSETS.md

## Chapter 1

- No missing assets identified.
- `_incoming/CHAPTER_1_FINAL.md` does not contain image placeholders.

## Chapter 5

- No missing assets identified.
- `_incoming/CHAPTER_5_1_5_2_FINAL.md` does not contain image placeholders.
- `_incoming/CHAPTER_5_3_5_4_FINAL.md` does not contain image placeholders.

## Chapter 2

- No missing assets identified.
- Copied and used Chapter 2 diagrams from `_incoming/asset/chapter2`:
  - `ch2_01_agile_scrum.svg`
  - `ch2_02_scrum_sprint.svg`
  - `ch2_03_kanban.svg`
  - `ch2_04_function_calling.svg`
  - `ch2_05_human_in_the_loop.svg`
  - `ch2_06_weighted_scoring_ahp.svg`
  - `ch2_07_modular_monolith.svg`
  - `ch2_19_sse.svg`
  - `ch2_22_cicd_deployment.svg`
- Copied and used required logos from `_incoming/asset/assets/images/logos`.
- Added/used additional available logos for Chapter 2:
  - `spring-data-logo.svg`
  - `gemini-star-logo.svg`
  - `supabase-logo.svg`
  - `github-logo.svg`
  - `openai-logo.svg`
  - `groq-logo.svg`
- Hình 2.14 uses individual copied logos (`tailwindcss-logo.svg`, `radixui-logo.svg`, `lucide-logo.svg`, `zustand-logo.svg`) instead of the combined SVG because Typst cannot load linked SVG images inside that file.

## Chapter 4

- No missing assets identified.
- Copied and used `_incoming/asset/assets/diagrams/taskpilot_ui_navigation_flow.png`.
- The SVG version is no longer referenced in Chapter 4 because Typst warned that it contains a `foreignObject`.
- Copied and used cropped screenshots from `_incoming/asset/chapter4/cropped`:
  - `ch4_02_login.png`
  - `ch4_05_dashboard.png`
  - `ch4_06_create_project.png`
  - `ch4_08_project_overview.png`
  - `ch4_23_project_setting_general.png`
  - `ch4_24_project_settings_members.png`
  - `ch4_09_sprint_backlog.png`
  - `ch4_10_kanban_board.png`
  - `ch4_17_timeline.png`
  - `ch4_11_task_detail.png`
  - `ch4_15_comment_mention.png`
  - `ch4_13_notification.png`
  - `ch4_14_ai_chat.png`
  - `ch4_16_assignment_recommendation.png`
  - `ch4_18_ai_pending_confirmation.png`
  - `ch4_22_admin_sys_config.png`

## Chapter 3

- Chapter 3 asset audit completed in `docs/CHAPTER3_ASSET_AUDIT.md`.
- No missing real asset files identified from the current Chapter 3 tracker.
- Current tracker coverage:
  - 70 Chapter 3 placeholders found in drafts.
  - 70 Chapter 3 tracker rows found in `_incoming/PLACEHOLDER_ASSET_STATUS.md`.
  - 79 real asset references checked.
- The user-flagged diagrams are not orphan files; they are mapped to explicit placeholders and should not be deleted before Chapter 3 conversion:
  - `sequence-realtime-notification-sse.svg`
  - `sequence-auth-refresh-token.svg`
  - `sequence-auth-logout-token-blocklist.svg`
  - `sequence-ai-module-query-project-user-contract.svg`
  - `sequence-ai-pending-action-confirmation.svg`
  - `sequence-ai-streaming-response-sse.svg`
- Added Mermaid source and re-rendered these user-flagged diagrams:
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-realtime-notification-sse.mmd`
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-auth-refresh-token.mmd`
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-auth-logout-token-blocklist.mmd`
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-module-query-project-user-contract.mmd`
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-pending-action-confirmation.mmd`
  - `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-streaming-response-sse.mmd`
  - `_incoming/asset/assets/sync-diagrams/activity/activity-project-access-permission-check.mmd`
- The seven re-rendered SVG files use English labels and were checked for `foreignObject`; all returned `False`.
- During Chapter 3 assembly, use these diagrams only for exact sequence/flow placeholders. Prefer higher-level diagrams for overview placeholders.
- `sequence-ai-pending-action-confirmation.svg` is mapped to two placeholders, so it has a duplicate-figure risk.

## Later chapters

- See `_incoming/PLACEHOLDER_ASSET_STATUS.md` and `docs/CHAPTER3_ASSET_AUDIT.md` before converting Chapter 3.
