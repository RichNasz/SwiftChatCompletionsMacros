# Contributing Specification

## Conventional Commits

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>
```

### Types

| Type | Usage |
|---|---|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `test` | Adding or updating tests |
| `docs` | Documentation changes (README, CLAUDE.md, examples) |
| `spec` | Spec file changes |
| `refactor` | Code restructuring without behavior change |
| `chore` | Build, dependencies, CI, tooling |

### Scopes

| Scope | Applies to |
|---|---|
| `generable` | `@Generable` macro declaration or implementation |
| `tool` | `@Tool` macro declaration or implementation |
| `guide` | `@Guide` macro declaration or implementation |
| `types` | `JSONSchemaValue`, `ToolDefinition`, `ToolOutput`, `GuideConstraint` |
| `plugin` | `Plugin.swift`, CompilerPlugin entry point |
| `tests` | Test files |
| `docs` | Documentation files |

### Examples

```
feat(generable): add support for enum types
fix(tool): correct snake_case conversion for acronyms
test(generable): add expansion test for nested optional arrays
docs(docs): update README Quick Start example
spec(docs): expand DocumentationSpec with badge format rules
refactor(plugin): extract shared type-mapping logic
chore: update swift-syntax dependency to 603.0.0
```

## AI Attribution

Commits with AI-assisted code must include the following trailer:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Pull Request Standards

### Title Format

Follow the same conventional commit format as commit messages:

```
feat(generable): add support for enum types
```

### Description Template

```markdown
## Summary
- [1-3 bullet points describing the change]

## Test Plan
- [ ] All existing tests pass (`swift test`)
- [ ] New tests added for changed behavior
- [ ] Macro expansion tests cover new syntax (if applicable)
```

### Review Checklist

Before submitting a PR, verify:

- [ ] `swift build` succeeds with no warnings
- [ ] `swift test` passes all tests
- [ ] New features have Tier 1 macro expansion tests (see TestingSpec.md)
- [ ] Conventional commit format used for all commits
- [ ] Spec files updated if behavior changes
- [ ] Documentation updated if public API changes

## Code of Conduct

This project follows the [Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). See [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) in the repository root.

All contributors, maintainers, and participants are expected to:

- Use welcoming and inclusive language
- Respect differing viewpoints and experiences
- Accept constructive criticism gracefully
- Focus on what is best for the community and project

Unacceptable behavior includes harassment, trolling, personal attacks, and publishing others' private information.

## Security Policy

See [SECURITY.md](../SECURITY.md) in the repository root.

**Scope**: Macro-generated code safety, dependency vulnerabilities, JSON Schema injection vectors.

**Reporting**: Open a GitHub Issue with the `security` label. Do not include exploit details in public issues — request private communication in the issue.

**Response**: Acknowledgment within 48 hours. Fix timeline communicated within 7 days.
