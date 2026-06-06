== Health Check <appendix-healthcheck>

=== Ví dụ payload health check của `note` service <appendix-healthcheck-note>

==== Startup

#figure(
  [
    ```json
    {
      "status": "up",
      "details": {
        "persistenceMigration": {
          "status": "up",
          "timestamp": "2026-05-19T08:06:45.31010631Z"
        }
      }
    }
    ```
  ],
  caption: [Ví dụ response của startup check ở `note` service],
)


==== Liveness

#figure(
  [
    ```json
    {
      "status": "up",
      "details": {
        "persistenceMigration": {
          "status": "up",
          "timestamp": "2026-05-19T08:06:45.31010631Z"
        }
      }
    }
    ```
  ],
  caption: [Ví dụ response của live check ở `note` service],
)

==== Readiness

#{
  show figure: set block(breakable: true)
  figure(
    [
      ```json
      {
        "status": "down",
        "details": {
          "authentik": {
            "status": "down",
            "timestamp": "2026-05-19T08:05:14.841142259Z",
            "error": "making the request for the health check failed: Get \"http://authentik.notopia.localhost/-/health/live\": dial tcp [::1]:80: connect: connection refused"
          },
          "authorizationService": {
            "status": "down",
            "timestamp": "2026-05-19T08:05:14.840856216Z",
            "error": "making the request for the health check failed: Get \"http://localhost:28089/authorization/health/live\": dial tcp [::1]:28089: connect: connection refused"
          },
          "grpc": {
            "status": "up",
            "timestamp": "2026-05-19T08:05:14.840692045Z"
          },
          "http": {
            "status": "up",
            "timestamp": "2026-05-19T08:05:14.840871465Z"
          },
          "kafka": {
            "status": "up",
            "timestamp": "2026-05-19T08:05:14.84080603Z"
          },
          "persistenceConnection": {
            "status": "up",
            "timestamp": "2026-05-19T08:05:14.840665763Z"
          },
          "workspaceEventHubRedisConnection": {
            "status": "up",
            "timestamp": "2026-05-19T08:05:14.841261038Z"
          }
        }
      }
      ```
    ],
    caption: [Ví dụ response của ready check ở `note` service],
  )
}
