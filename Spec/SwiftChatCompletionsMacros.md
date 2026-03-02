# SwiftChatCompletionsMacros Specification

## WHAT

### Purpose

Generate OpenAI-compatible JSON Schema definitions at compile time using Swift macros, enabling type-safe tool calling for any OpenAI-compatible chat completions endpoint.

### Macros

#### `@Generable`

- **Applies to**: Structs only
- **Role**: `@attached(member)` + `@attached(extension)`
- **Generates**: `static var jsonSchema: JSONSchemaValue` member, plus `Generable`, `Codable`, `Sendable` conformance
- **Reads**: `@Guide` attributes from stored properties to enrich schema
- **Error**: Emits compile-time diagnostic if applied to non-struct

#### `@Tool`

- **Applies to**: Structs only
- **Role**: `@attached(member)` + `@attached(extension)` + `@attached(peer)`
- **Generates**: `static let name: String`, `static let description: String`, `static var toolDefinition: ToolDefinition`, plus `Tool` conformance
- **Reads**: Doc comments from struct declaration for description, struct name for tool name (PascalCase to snake_case)
- **Error**: Emits compile-time diagnostic if applied to non-struct

#### `@Guide`

- **Applies to**: Stored properties
- **Role**: `@attached(peer)` (marker only)
- **Generates**: Nothing
- **Parameters**: `description: String`, optional `GuideConstraint`

### Public Types

#### `JSONSchemaValue` (indirect enum)

```swift
public indirect enum JSONSchemaValue: Sendable, Equatable, Encodable {
    case object(properties: [(String, JSONSchemaValue)], required: [String])
    case array(items: JSONSchemaValue)
    case string(description: String? = nil, enumValues: [String]? = nil)
    case integer(description: String? = nil, minimum: Int? = nil, maximum: Int? = nil)
    case number(description: String? = nil, minimum: Double? = nil, maximum: Double? = nil)
    case boolean(description: String? = nil)
}
```

#### `ToolDefinition` (struct)

Encodes to `{"type":"function","function":{"name":...,"description":...,"parameters":...}}`.

#### `ToolOutput` (struct)

Wraps a `String` content result from a tool call.

#### `GuideConstraint` (enum)

`.anyOf([String])`, `.range(ClosedRange<Int>)`, `.doubleRange(ClosedRange<Double>)`, `.count(Int)`, `.minimumCount(Int)`, `.maximumCount(Int)`

### Protocols

#### `Generable: Codable, Sendable`

Requires `static var jsonSchema: JSONSchemaValue`.

#### `Tool: Sendable`

Requires `associatedtype Arguments: Generable`, `name`, `description`, `toolDefinition`, `call(arguments:)`.

### Supported Swift Types

| Swift Type | JSON Schema |
|---|---|
| `String` | `{"type": "string"}` |
| `Int` | `{"type": "integer"}` |
| `Double` | `{"type": "number"}` |
| `Bool` | `{"type": "boolean"}` |
| `T?` | Same as T, excluded from required |
| `[T]` | `{"type": "array", "items": ...}` |
| Nested `@Generable` | Delegates to nested type's `jsonSchema` |

### Error Diagnostics

- `@Generable` on non-struct: "@Generable can only be applied to structs"
- `@Tool` on non-struct: "@Tool can only be applied to structs"

---

## WHY

### Why Compile-Time Schema Generation

JSON Schema generation happens entirely at compile time via Swift macros. The generated code constructs `JSONSchemaValue` enum values directly — no runtime reflection, no `Mirror`, no dynamic type inspection. This provides:

- Zero runtime overhead for schema construction
- Compile-time error diagnostics for unsupported types
- Full type safety with no possibility of runtime schema/type mismatches

### Why `@Guide` Is a Marker Macro

`@Guide` is declared as a `PeerMacro` but generates no code. Its attributes are read by `@Generable` during expansion. This avoids expansion ordering conflicts — if `@Guide` generated code that `@Generable` consumed, the compiler would need to guarantee `@Guide` expands first, which Swift macros do not guarantee for sibling declarations.

### Why Struct-Only Restriction

Both `@Generable` and `@Tool` require structs because:

- JSON Schema `"type": "object"` maps cleanly to Swift structs (named properties with fixed types)
- Structs provide value semantics matching JSON's data model
- Classes would introduce inheritance complications not representable in JSON Schema
- Enums require a different schema pattern (`oneOf`/`enum`) not yet supported

### Why OpenAI Function-Calling Format

The `ToolDefinition` type encodes to `{"type":"function","function":{...}}` — the format specified by OpenAI's Chat Completions API. This format has become a de facto standard adopted by Anthropic, Mistral, Groq, and other providers. Targeting it maximizes compatibility across the ecosystem.

### Why FoundationModels API Naming

The macro names (`@Tool`, `@Generable`, `@Guide`) and protocol shapes mirror Apple's FoundationModels framework (introduced in iOS 26 / macOS 26). This naming parity means:

- Developers familiar with FoundationModels can use this library with near-zero learning curve
- Code can be migrated between on-device (FoundationModels) and cloud (OpenAI-compatible) with minimal changes
- The API feels native to the Swift ecosystem rather than being a direct port of OpenAI's Python/JS conventions
