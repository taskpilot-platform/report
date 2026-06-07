# CHAPTER3_ASSET_AUDIT.md

## Summary

- Audited all `_incoming/CHAPTER_3_*_FINAL.md` drafts before Chapter 3 conversion.
- Total Chapter 3 image placeholders found in drafts: 70.
- Total Chapter 3 placeholder rows in `_incoming/PLACEHOLDER_ASSET_STATUS.md`: 70.
- Real asset references checked from the tracker: 79.
- Missing real asset files: 0.

## Placeholder Count By Draft

- `CHAPTER_3_1_FINAL.md`: 3 placeholders.
- `CHAPTER_3_2_FINAL.md`: 2 placeholders.
- `CHAPTER_3_3_FINAL.md`: 4 placeholders.
- `CHAPTER_3_4_3_5_FINAL.md`: 24 placeholders.
- `CHAPTER_3_6_3_7_FINAL.md`: 4 placeholders.
- `CHAPTER_3_8_FINAL.md`: 2 placeholders.
- `CHAPTER_3_9_3_10_FINAL.md`: 10 placeholders.
- `CHAPTER_3_11_FINAL.md`: 10 placeholders.
- `CHAPTER_3_12_FINAL.md`: 5 placeholders.
- `CHAPTER_3_13_FINAL.md`: 6 placeholders.

## User-Flagged Diagrams

These files are not orphan assets according to the current drafts. They are mapped to explicit Chapter 3 placeholders.

They have now been redrawn as Mermaid source files with English labels and rendered back to SVG in place. The rendered SVG files were checked for `foreignObject`; all seven redrawn SVGs returned `False`.

- `sequence-realtime-notification-sse.svg`
  - Used by `CHAPTER_3_9_3_10_FINAL.md`, line 102.
  - Placeholder: `Sequence diagram realtime notification bằng SSE`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-realtime-notification-sse.mmd`.
- `sequence-auth-refresh-token.svg`
  - Used by `CHAPTER_3_9_3_10_FINAL.md`, line 33.
  - Placeholder: `Luồng làm mới access token bằng refresh token`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-auth-refresh-token.mmd`.
- `sequence-auth-logout-token-blocklist.svg`
  - Used by `CHAPTER_3_9_3_10_FINAL.md`, line 45.
  - Placeholder: `Luồng logout và kiểm tra token blocklist`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-auth-logout-token-blocklist.mmd`.
- `sequence-ai-module-query-project-user-contract.svg`
  - Used by `CHAPTER_3_6_3_7_FINAL.md`, line 153.
  - Placeholder: `Sequence diagram AI module truy vấn Project/User thông qua contract`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-module-query-project-user-contract.mmd`.
- `sequence-ai-pending-action-confirmation.svg`
  - Used by `CHAPTER_3_4_3_5_FINAL.md`, line 533.
  - Used by `CHAPTER_3_11_FINAL.md`, line 111.
  - This is a duplicate-content risk because the same diagram may appear twice.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-pending-action-confirmation.mmd`.
- `sequence-ai-streaming-response-sse.svg`
  - Used by `CHAPTER_3_9_3_10_FINAL.md`, line 126.
  - Placeholder: `Luồng AI streaming response từ Backend đến Frontend`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-streaming-response-sse.mmd`.
- `activity-project-access-permission-check.svg`
  - Used by `CHAPTER_3_9_3_10_FINAL.md`, line 80.
  - Placeholder: `Activity diagram kiểm tra quyền truy cập tài nguyên project`.
  - Mermaid source: `_incoming/asset/assets/sync-diagrams/activity/activity-project-access-permission-check.mmd`.
  - Note: rendered as a Mermaid sequence diagram in the activity asset path to avoid Mermaid flowchart/state `foreignObject` output.

## Recommendation For Chapter 3 Assembly

- Do not delete the user-flagged diagrams before conversion because current Chapter 3 drafts explicitly reference them.
- Prefer higher-level diagrams for overview placeholders, for example:
  - `ch3_10_realtime_notification_overview.svg`
  - `ch3_10_comment_realtime_flow.svg`
  - `ch3_11_ai_copilot_architecture.svg`
  - `ch3_11_safety_layers.svg`
  - `ch3_07_contracts_communication.svg`
  - `ch3_07_port_adapter_model.svg`
- Use the user-flagged diagrams only when the placeholder specifically asks for a sequence diagram, permission-check flow, or an exact runtime flow.
- For `sequence-ai-pending-action-confirmation.svg`, avoid unnecessary duplicate visual clutter if Chapter 3 assembly allows using it once and keeping a TODO/cross-reference for the second occurrence.
- If the final PDF shows these diagrams as visually poor, adjust the Mermaid source and re-render; do not silently delete captions.

## Current Asset Note

- `src/assets/taskpilot/chapter3/ch3_12_assignment_recommendation_process.svg` and `.png` currently exist in the working tree.
- `src/assets/diagrams/ch3_12_assignment_recommendation_process.svg` and `.png` do not exist in the working tree.
- Current `git status --short --untracked-files=all` only shows the docs updated by this audit.
