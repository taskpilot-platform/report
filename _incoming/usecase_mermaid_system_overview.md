# Use Case Overview - TaskPilot (Mermaid)

```mermaid
flowchart LR
  AD[Admin]
  PM[Project Manager]
  MB[Project Member]
  SYS[System External Services]

  subgraph TP[TaskPilot System]
    direction TB

    subgraph AUTH[Authentication]
      A1[Login / Sign In]
      A2[Register / Sign Up]
      A3[Forgot Password]
      A4[Reset Password]
    end

    subgraph PROF[Profile & Skills]
      P1[Manage Profile]
      P2[Manage Personal Skills]
    end

    subgraph SA[System Administration]
      S1[Configure System Parameters]
      S2[Manage Skill Directory]
      S3[Manage System Users]
    end

    subgraph PJ[Project & Sprint]
      J1[Manage Projects]
      J2[Manage Project Members]
      J3[Manage Sprints]
    end

    subgraph TASK[Task & Communication]
      T1[Manage Tasks / Kanban / Backlog]
      T2[Manage Comments]
      T3[Manage Notifications]
    end

    subgraph AI[AI Assistant]
      I1[Create AI Chat Session]
      I2[Chat with AI Copilot]
      I3[View Chat History]
      I4[View AI Activity Logs]
      I5[AI Assignment Recommendation]
      I6[Pending Action Confirmation]
    end
  end

  AD --> S1
  AD --> S2
  AD --> S3
  AD --> I4
  AD --> T3
  AD --> P1

  PM --> J1
  PM --> J2
  PM --> J3
  PM --> T1
  PM --> T2
  PM --> T3
  PM --> P1
  PM --> P2
  PM --> I1
  PM --> I2
  PM --> I3
  PM --> I4
  PM --> I5
  PM --> I6

  MB --> J1
  MB --> T1
  MB --> T2
  MB --> T3
  MB --> P1
  MB --> P2
  MB --> I1
  MB --> I2
  MB --> I3
  MB --> I4
  MB --> I6

  SYS --> T3
  SYS --> I2

  A4 -. extends .-> A3
  I5 -. includes .-> I2
  I6 -. extends .-> I2
  I6 -. extends .-> I5
```

