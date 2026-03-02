/// Generates a JSON Schema for the annotated struct at compile time.
///
/// Attach `@ChatCompletionsToolArguments` to a struct to automatically synthesize
/// `ChatCompletionsToolArguments`, `Codable`, and `Sendable` conformances with a
/// `static var jsonSchema: JSONSchemaValue` that describes the
/// struct's stored properties as an OpenAI-compatible JSON Schema.
///
/// Use `@ChatCompletionsToolGuide` on individual properties to add descriptions and
/// constraints to the generated schema.
///
/// ## Example
///
/// ```swift
/// @ChatCompletionsToolArguments
/// struct WeatherQuery {
///     @ChatCompletionsToolGuide(description: "The city name")
///     var location: String
///
///     @ChatCompletionsToolGuide(description: "Temperature unit", .anyOf(["celsius", "fahrenheit"]))
///     var unit: String?
/// }
/// ```
@attached(member, names: named(jsonSchema))
@attached(extension, conformances: ChatCompletionsToolArguments, Codable, Sendable)
public macro ChatCompletionsToolArguments() = #externalMacro(
	module: "SwiftChatCompletionsMacrosPlugin",
	type: "GenerableMacro"
)

/// Generates an OpenAI-compatible tool definition for the annotated struct.
///
/// The struct must contain a nested `Arguments` type conforming to
/// `ChatCompletionsToolArguments` and a `call(arguments:)` method. The macro
/// synthesizes `ChatCompletionsTool` conformance and a
/// `static var toolDefinition: ToolDefinition`.
///
/// ## Example
///
/// ```swift
/// @ChatCompletionsTool
/// struct GetWeather {
///     /// Get the current weather for a location.
///     ///
///     /// - Parameter arguments: The weather query arguments.
///     func call(arguments: WeatherQuery) async throws -> ToolOutput {
///         ToolOutput(content: "Sunny, 72°F")
///     }
/// }
/// ```
@attached(member, names: named(toolDefinition), named(name), named(description))
@attached(extension, conformances: ChatCompletionsTool)
@attached(peer)
public macro ChatCompletionsTool() = #externalMacro(
	module: "SwiftChatCompletionsMacrosPlugin",
	type: "ToolMacro"
)

/// Adds a description and optional constraints to a property's JSON Schema.
///
/// `@ChatCompletionsToolGuide` is a marker macro — it generates no code itself.
/// Instead, `@ChatCompletionsToolArguments` reads `@ChatCompletionsToolGuide`
/// attributes from sibling properties during its expansion to enrich the
/// generated JSON Schema.
///
/// ## Example
///
/// ```swift
/// @ChatCompletionsToolArguments
/// struct Query {
///     @ChatCompletionsToolGuide(description: "Search query text")
///     var query: String
///
///     @ChatCompletionsToolGuide(description: "Max results", .range(1...100))
///     var limit: Int
/// }
/// ```
@attached(peer)
public macro ChatCompletionsToolGuide(description: String, _ constraint: GuideConstraint? = nil) = #externalMacro(
	module: "SwiftChatCompletionsMacrosPlugin",
	type: "GuideMacro"
)
