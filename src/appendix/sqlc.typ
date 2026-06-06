== SQLC <appendix-sqlc>

=== SQLC Dynamic Filter — Ví dụ query <appendix-sqlc-dynamic-filter>

Dưới đây là so sánh giữa query SQLC tiêu chuẩn và query sử dụng custom plugin
`vtuanjs/sqlc-gen-go` _(@general-for-sqlc)_ để xử lý optional filters.

#figure(
  [
    ```sql
    SELECT
      *
    FROM
      notes
    WHERE
      CASE
        WHEN CARDINALITY(sqlc.arg('ids')::uuid[]) > 0
          THEN id = ANY(sqlc.arg('ids')::uuid[])
          ELSE TRUE
        END
      CASE
        WHEN sqlc.narg('workspace_id')::uuid IS NOT NULL
          THEN folder_id IN (
            SELECT
              id
            FROM
              folders
            WHERE
              workspace_id = sqlc.narg('workspace_id')::uuid
          )
          ELSE TRUE
        END
      CASE
        WHEN sqlc.narg('trashed_by')::text IS NOT NULL
          THEN (
            trashed_by = sqlc.narg('trashed_by')::text
            OR trashed_by IS NULL
          )
          ELSE TRUE
        END
      CASE
        WHEN sqlc.arg('trashed_only')::boolean = true
          THEN trashed_by IS NOT NULL
          ELSE TRUE
        END;
    ```
  ],
  caption: [Ví dụ SQL query với nhiều optional filters trong SQLC tiêu chuẩn],
)

#figure(
  [
    #import "@preview/codly:1.3.0": codly
    #codly(highlights: (
      (line: 6, start: 41, fill: red.lighten(50%)),
      (line: 7, start: 25, fill: blue.lighten(50%)),
      (line: 15, start: 12, fill: green.lighten(50%)),
      (line: 19, start: 33, fill: orange.lighten(50%)),
      (line: 20, start: 15, fill: purple.lighten(50%)),
    ))
    ```sql
    SELECT
      *
    FROM
      notes
    WHERE
      id = ANY(sqlc.narg('ids')::uuid[]) -- :if @ids
      AND folder_id IN ( -- :if @workspace_id
        SELECT
          id
        FROM
          folders
        WHERE
          workspace_id = sqlc.narg('workspace_id')::uuid
      )
      AND ( -- :if @trashed_by
        trashed_by = sqlc.narg('trashed_by')::text
        OR trashed_by IS NULL
      )
      AND trashed_by IS NOT NULL -- :if @trashed_only
    FOR UPDATE -- :if @for_update
    ;
    ```
  ],
  caption: [Ví dụ SQL query với dynamic filters sử dụng custom plugin
    `vtuanjs/sqlc-gen-go`],
)
