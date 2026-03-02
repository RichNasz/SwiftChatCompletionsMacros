# Spec Directory

This directory contains the specification files for SwiftChatCompletionsMacros. Specs define **WHAT** the project is and **WHY** design decisions were made. They do not prescribe **HOW** to implement — that lives in the source code.

This is a traditional Swift library project: humans write both specs and code. Specs serve as reference documentation and contribution standards, not as generation inputs.

## Spec Files

| File | Purpose |
|---|---|
| [SwiftChatCompletionsMacros.md](SwiftChatCompletionsMacros.md) | Core product specification — macros, types, protocols, design rationale |
| [DocumentationSpec.md](DocumentationSpec.md) | Rules for README, CLAUDE.md, examples, and community files |
| [ContributingSpec.md](ContributingSpec.md) | Contribution standards, commit conventions, PR process, Code of Conduct |
| [ProjectStructureSpec.md](ProjectStructureSpec.md) | Directory layout, target architecture, file placement rules |
| [TestingSpec.md](TestingSpec.md) | Testing philosophy, coverage tiers, framework choices, naming conventions |

## Principles

- **WHAT not HOW**: Specs describe the product surface and design rationale. Implementation details belong in code and code comments.
- **Single source of truth**: Each topic has one canonical spec file. Avoid duplicating information across specs.
- **Keep current**: Update specs when the product changes. A spec that contradicts the code is a bug.
