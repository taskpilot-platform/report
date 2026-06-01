## UC40 - View Kanban Board

### Matching files

* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/task-management/view-kanban-board.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/task-management/view-kanban-board.md` (PlantUML block)

### Diagram recommendation

Sequence primary, activity supplementary

### Extracted Basic Flow from diagram

1. User accesses Kanban board for a project.
2. UI requests Kanban data (`project_id`, `sprint_id`) from `TaskController`.
3. Controller queries tasks grouped by status.
4. Controller returns Kanban dataset.
5. UI renders columns (`TODO`, `IN_PROGRESS`, `REVIEW`, `DONE`) with task cards.

### Alternate Flow hints

* Activity diagram adds active-sprint selection flow and backlog fallback (`sprint_id = NULL`) when no active sprint exists.
* Activity diagram includes per-column empty placeholder behavior.

### Exception Flow hints

* Activity diagram includes empty-board path (`No tasks in this sprint`) with early end.

### Report usage

[Hình x: Sequence diagram mô tả use case xem Kanban Board]

### Confidence

High

## UC13 - Configure System Parameters / AI weights

### Matching files

* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/configure-system-parameters.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/configure-system-parameters.md` (PlantUML block)

### Diagram recommendation

Sequence primary, activity supplementary

### Extracted Basic Flow from diagram

1. Admin opens system settings page.
2. UI requests current settings from `AdminController`.
3. Controller queries `SYSTEM_SETTINGS` and returns current values.
4. UI shows settings form (including heuristic weights/config params).
5. Admin modifies parameters and submits.
6. UI validates values and sends update request.
7. Controller upserts updated settings and returns success.
8. UI shows success message.

### Alternate Flow hints

* Activity diagram adds repeat loop for invalid JSON until valid format is provided.
* Activity diagram includes cache/memory reload step after update.

### Exception Flow hints

* Sequence: invalid parameter values on client validation.
* Activity: non-admin access denied branch.

### Report usage

[Hình x: Sequence diagram mô tả use case cấu hình tham số hệ thống và trọng số AI]

### Confidence

High

## UC14-UC17 - System Skill Management

### Matching files

* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/view-system-skill-directory.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/add-system-skill.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/edit-system-skill.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/delete-system-skill.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/view-system-skill-directory.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/add-system-skill.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/edit-system-skill.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/delete-system-skill.md` (PlantUML block)

### Diagram recommendation

Sequence primary, activity supplementary

### Extracted Basic Flow from diagram

1. Admin opens system skill directory and system loads full skill list.
2. For add flow, admin opens add form, enters skill name, submits, and system creates new skill.
3. For edit flow, admin opens detail/edit form, updates skill name, submits, and system updates record.
4. For delete flow, admin confirms deletion and system removes skill record.
5. UI updates directory view after each successful write.

### Alternate Flow hints

* View flow supports filtering/search in activity diagram.
* Add/edit flows include validation loops before save.
* Delete flow includes cancel branch in activity diagram.

### Exception Flow hints

* Duplicate skill name on add/edit.
* Skill not found branch in activity edit/delete.
* Delete failure path in sequence delete.

### Report usage

[Hình x: Sequence diagram mô tả nhóm use case quản lý danh mục kỹ năng hệ thống (UC14-UC17)]

### Confidence

High

## UC18-UC21 - Global User Management

### Matching files

* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/view-global-user-list.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/add-system-user.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/edit-system-user.md` (PlantUML block)
* Sequence diagram source: `taskpilot-platform.github.io/docs/docs/sequence/admin/delete-system-user.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/view-global-user-list.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/add-system-user.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/edit-system-user.md` (PlantUML block)
* Activity diagram source: `taskpilot-platform.github.io/docs/docs/activity/admin/delete-system-user.md` (PlantUML block)

### Diagram recommendation

Sequence primary, activity supplementary

### Extracted Basic Flow from diagram

1. Admin opens user management and system returns user list.
2. Add flow: admin opens add form, submits new user data, system checks email uniqueness, hashes password, and creates user.
3. Edit flow: admin opens user detail form, updates fields, system validates and persists updates.
4. Delete flow: admin confirms delete, system validates self-delete rule, then deletes target user.
5. UI refreshes list/detail after success.

### Alternate Flow hints

* View flow includes filter criteria (keyword/role/status) in activity diagram.
* Edit flow supports email-change notification path in activity diagram.

### Exception Flow hints

* Invalid input validation errors (add/edit).
* Email already exists (add/edit).
* Cannot delete own account (delete).
* Delete failed branch in sequence delete.

### Report usage

[Hình x: Sequence diagram mô tả nhóm use case quản lý người dùng toàn cục (UC18-UC21)]

### Confidence

High

## UC56/UC59 Extension - Pending Action Confirmation

### Matching files

* Sequence diagram source: MISSING_DIAGRAM
* Activity diagram source: MISSING_DIAGRAM

### Diagram recommendation

No diagram available

### Extracted Basic Flow from diagram

1. MISSING_DIAGRAM

### Alternate Flow hints

* Existing nearby AI diagrams only model suggestion accept/reject, not deferred pending-action lifecycle.

### Exception Flow hints

* Existing docs do not model invalid action id, mismatched user/session, expired pending action, or cancel path for pending action object.

### Report usage

[Hình x: Sequence diagram mô tả luồng mở rộng pending action confirmation cho UC56/UC59]

### Confidence

Low

No official sequence/activity file under `docs/docs/sequence` or `docs/docs/activity` documents `PendingAiActionService.create -> confirmPendingAction/cancelPendingAction` lifecycle.

Recommended new sequence diagram (to add later, not currently existing):

1. User sends AI request that leads to write-intent tool.
2. AI module returns pending action payload (`actionId`, summary, preview) instead of immediate write.
3. User explicitly confirms (or cancels) with action id and confirmation command.
4. System verifies current user/session ownership and pending-action TTL.
5. On confirm, system executes deferred supplier and writes domain data.
6. On cancel, system removes pending action without executing write.
7. System returns success/error and logs action outcome.
