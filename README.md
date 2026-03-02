# SwiftChatCompletionsMacros

[![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![Xcode CLI](https://img.shields.io/badge/Xcode%20CLI-16+-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%2013%20%7C%20iOS%2016-lightgrey.svg)](Package.swift)
[![Built with Claude Code](https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet?logo=claude)](https://claude.ai/code)

Swift macros that generate OpenAI-compatible JSON Schema at compile time -- zero runtime overhead, zero naming conflicts with Apple FoundationModels, fully type-safe.

## Overview

SwiftChatCompletionsMacros provides three macros for defining OpenAI-compatible tool definitions at compile time:

- **`@ChatCompletionsToolArguments`** -- Generates a JSON Schema for a struct's properties
- **`@ChatCompletionsTool`** -- Generates an OpenAI-compatible tool definition
- **`@ChatCompletionsToolGuide`** -- Adds descriptions and constraints to property schemas

## Quick Start

### Installation

Add SwiftChatCompletionsMacros to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RichNasz/SwiftChatCompletionsMacros.git", from: "0.1.0")
]
```

Then add it as a dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SwiftChatCompletionsMacros"]
)
```

### Basic Usage

```swift
import SwiftChatCompletionsMacros

// Define a structured type for tool arguments
@ChatCompletionsToolArguments
struct WeatherQuery {
    @ChatCompletionsToolGuide(description: "The city to get weather for")
    var location: String

    @ChatCompletionsToolGuide(description: "Temperature unit", .anyOf(["celsius", "fahrenheit"]))
    var unit: String?
}

// Define a tool
/// Get the current weather for a location.
@ChatCompletionsTool
struct GetWeather {
    typealias Arguments = WeatherQuery

    func call(arguments: WeatherQuery) async throws -> ToolOutput {
        // Your implementation here
        ToolOutput(content: "Sunny, 72F in \(arguments.location)")
    }
}

// Use the generated tool definition
let definition = GetWeather.toolDefinition
let jsonData = try JSONEncoder().encode(definition)
// Produces: {"type":"function","function":{"name":"get_weather","description":"Get the current weather for a location.","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city to get weather for"},"unit":{"type":"string","description":"Temperature unit","enum":["celsius","fahrenheit"]}},"required":["location"],"additionalProperties":false}}}
```

## How It Works

`@ChatCompletionsToolArguments` expands your struct at compile time, generating a `jsonSchema` property and protocol conformances. No runtime reflection or mirrors.

**You write:**

```swift
@ChatCompletionsToolArguments
struct WeatherQuery {
    @ChatCompletionsToolGuide(description: "The city name")
    var location: String
    var unit: String?
}
```

**The macro generates:**

```swift
struct WeatherQuery {
    var location: String
    var unit: String?

    public static var jsonSchema: JSONSchemaValue {
        .object(
            properties: [
                ("location", .string(description: "The city name")),
                ("unit", .string())
            ],
            required: ["location"]
        )
    }
}

extension WeatherQuery: ChatCompletionsToolArguments, Codable, Sendable {}
```

## Supported Types

| Swift Type | JSON Schema | Required? |
|---|---|---|
| `String` | `{"type": "string"}` | Yes |
| `Int` | `{"type": "integer"}` | Yes |
| `Double` | `{"type": "number"}` | Yes |
| `Bool` | `{"type": "boolean"}` | Yes |
| `T?` | Same as `T` | No |
| `[T]` | `{"type": "array", "items": ...}` | Yes |
| Nested `@ChatCompletionsToolArguments` | `{"type": "object", ...}` | Yes |

## `@ChatCompletionsToolGuide` Constraints

```swift
@ChatCompletionsToolArguments
struct SearchQuery {
    @ChatCompletionsToolGuide(description: "Search text")
    var query: String

    @ChatCompletionsToolGuide(description: "Max results", .range(1...100))
    var limit: Int

    @ChatCompletionsToolGuide(description: "Sort order", .anyOf(["relevance", "date", "popularity"]))
    var sortBy: String?
}
```

Available constraints:
- `.anyOf([String])` -- Restricts to specific string values
- `.range(ClosedRange<Int>)` -- Integer range constraint
- `.doubleRange(ClosedRange<Double>)` -- Double range constraint
- `.count(Int)` -- Exact array item count
- `.minimumCount(Int)` -- Minimum array item count
- `.maximumCount(Int)` -- Maximum array item count

## Designed for SwiftChatCompletionsDSL

SwiftChatCompletionsMacros is the compile-time companion to [SwiftChatCompletionsDSL](https://github.com/RichNasz/SwiftChatCompletionsDSL). Use the DSL to make requests and this package to define your tools -- they work together seamlessly.

The `@ChatCompletionsTool` / `@ChatCompletionsToolArguments` / `@ChatCompletionsToolGuide` names are deliberately chosen to avoid conflicts with Apple's FoundationModels framework (`@Tool`, `@Generable`, `@Guide`). You can import both packages in the same project with zero naming collisions.

## Requirements

- Swift 6.2+
- macOS 13.0+ / iOS 16.0+

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

SwiftChatCompletionsMacros is available under the Apache License 2.0. See [LICENSE](LICENSE) for details.
