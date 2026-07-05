# Agent Configs

Custom agent configuration repository designed to stay agnostic to any specific LLM service provider.  
To achieve module/package-style dependency management for agent, it uses [microsoft/apm](https://github.com/microsoft/apm).

## How to apply configs

Please install [microsoft/apm](https://github.com/microsoft/apm) before applying any configurations.

### SKILL

> [!NOTE]
> The format of all skills is based on [agentskills](https://github.com/agentskills/agentskills)

- `apm install yureutaejin/agent-configs/.apm/skills/{skill_name}` to install a skill from this repository.
  - tag/branch/commit-sha can be specified by appending `#<tag/branch/commit-sha>`
