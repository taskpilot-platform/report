# Acceptance Criteria: Spring Data JPA 4.x Modernization

## 1. Feature 11: Entity Reference (`getReferenceById`)
- **AC-11.1**: In `UserSkillModuleAdapter.addMySkill`, setting the user relationship on `UserSkillEntity` must use `userRepository.getReferenceById(userId)` after verifying user existence.
- **AC-11.2**: In `SkillService.addSkill`, setting the user relationship must use `userRepository.getReferenceById(userId)`.
- **AC-11.3**: Automated test must verify that `getReferenceById(id)` creates a lightweight Hibernate proxy without emitting a pre-fetch `SELECT` statement.

## 2. Feature 4: Keyset Pagination (`Window<T>` & `ScrollPosition`)
- **AC-4.1**: `ChatMessageRepository` must declare keyset pagination method returning `Window<ChatMessageEntity>` accepting `ScrollPosition` and `Limit`.
- **AC-4.2**: `NotificationRepository` must declare keyset pagination method returning `Window<NotificationEntity>` accepting `ScrollPosition` and `Limit`.
- **AC-4.3**: Keyset queries must order by `createdAt DESC, id DESC` to guarantee stable O(1) B-tree traversal.
- **AC-4.4**: Calling keyset query on an empty or populated session/user returns a valid `Window<T>` without executing any `SELECT COUNT(*)` statements.

## 3. Feature 6: Observability with Query Comment (`@Meta(comment = "...")`)
- **AC-6.1**: Every method annotated with `@Query` across all modules must be annotated with `@Meta(comment = "<RepositoryName>.<methodName>")`.
- **AC-6.2**: The `@Meta` comment string must not be empty or blank.
- **AC-6.3**: Reflection test must verify 100% of custom query methods across the 10 target repositories carry `@Meta` comments.

## 4. Feature 5: Dedicated `@NativeQuery`
- **AC-5.1**: `TaskRepository` must provide a specialized status aggregation method annotated with modern `@NativeQuery`.
- **AC-5.2**: The method must execute valid native PostgreSQL SQL.

## 5. Feature 7: DB Function Sorting (`JpaSort.unsafe`)
- **AC-7.1**: Infrastructure must provide a utility or demonstrate query execution using `JpaSort.unsafe(...)` for expressions like `deadline ASC NULLS LAST`.
- **AC-7.2**: The call must not throw `PropertyReferenceException`.

## 6. Feature 10: Fragment Composition
- **AC-10.1**: A specialized repository fragment `TaskSearchFragment` must be defined with its implementation `TaskSearchFragmentImpl`.
- **AC-10.2**: `TaskRepository` must extend `TaskSearchFragment`.
- **AC-10.3**: Calling a fragment method on `TaskRepository` must execute properly via Spring Data's fragment composition engine.

## 7. Build & Regression Gate
- **AC-ALL**: Complete Maven build (`./mvnw clean test`) passes with 0 errors and 0 test failures across all 7 reactor modules.
