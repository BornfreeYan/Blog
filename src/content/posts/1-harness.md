---
title: Harness Engineering
date: 2026-11-18
tags:
  - Harness
categories:
  - AI
draft: false
---
> 个人的agent harness入门学习笔记。
> 参考：[learn claudecode](https://github.com/shareAI-lab/learn-claude-code/)
> 练手仓库：[Minicode](https://github.com/BornfreeYan/Minicode)
## Intro
几个认知：
- Agency 来自模型（感知 推理 决策 行动能力，能力是神经网络训练而来的），Harness（马鞍，即工作环境/工具）。Agent 产品 = LLM（模型）+ Harness。
- 所以啥是Harness？类比一下，农业 Agent 的 Harness 式传感器、气象数据、浇灌控制。有一匹好马，也要配好马鞍和马蹄铁。这个设计模式可以泛化到任意一个领域。
```
harness =
    Tools          ← 能碰到什么（bash/read/write/edit/glob/grep/browser + MCP 路由）
  + Knowledge      ← 知道什么（文档/API 规范/skill 按需加载/memory）
  + Observation    ← 看到什么（git diff/日志/浏览器状态/上下文压缩后的视图）
  + Action         ← 能做什么（CLI/API/UI + hooks 扩展点）
  + Permissions    ← 允许做什么（沙箱/审批/信任边界/worktree 隔离）
  + Orchestration  ← 怎么组织（agent loop + 任务图 + 子 agent + 团队协调 + 并行执行）
```

目录与进度备注：
| 章节（点击跳转） | 主题 | 进度 | 个人总结 |
| --- | --- | :---: | --- |
| [s01](#s01-agent-loop) | Agent Loop |  |  |
| [s02](#s02-tool-use) | Tool Use |  |  |
| [s03](#s03-permission) | Permission |  |  |
| [s04](#s04-hooks) | Hooks |  |  |
| [s05](#s05-todowrite) | TodoWrite |  |  |
| [s06](#s06-subagent) | Subagent |  |  |
| [s07](#s07-skill-loading) | Skill Loading |  |  |
| [s08](#s08-context-compact) | Context Compact |  |  |
| [s09](#s09-memory) | Memory |  |  |
| [s10](#s10-task-system) | Task System |  |  |
| [s11](#s11-background-tasks) | Background Tasks |  |  |
| [s12](#s12-cron-scheduler) | Cron Scheduler |  |  |
| [s13](#s13-agent-teams) | Agent Teams |  |  |
| [s14](#s14-mcp-plugin) | MCP Plugin |  |  |
| [s15](#s15-agent-harness-集成) | Agent Harness 集成 |  |  |
| [s16](#s16-workflow-runtime) | Workflow Runtime |  |  |
| [s17](#s17-goal-loop) | Goal Loop |  |  |
## s01-Agent Loop
 一个工具 + 一个循环 = 一个 Agent

---
## s02-Tool Use
---
## s03-Permission
---
## s04-Hooks
---
## s05-TodoWrite
---
## s06-Subagent
---
## s07-Skill Loading
---
## s08-Context Compact
---
## s09-Memory
---
## s10-Task System
---
## s11-Background Tasks
---
## s12-Cron Scheduler
---
## s13-Agent Teams
---
## s14-MCP Plugin
---
## s15-Agent Harness 集成
---
## s16-Workflow Runtime
---
## s17-Goal Loop
---