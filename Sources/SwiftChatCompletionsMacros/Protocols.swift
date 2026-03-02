/// A type whose structure can be described as a JSON Schema for use with
/// OpenAI-compatible chat completions endpoints.
///
/// Conformance is synthesized by the `@ChatCompletionsToolArguments` macro,
/// which generates the `jsonSchema` property at compile time.
public protocol ChatCompletionsToolArguments: Codable, Sendable {
	/// The JSON Schema describing this type's structure.
	static var jsonSchema: JSONSchemaValue { get }
}

/// A callable tool that can be used with OpenAI-compatible chat completions
/// endpoints for function calling.
///
/// Conformance is synthesized by the `@ChatCompletionsTool` macro, which
/// generates the `toolDefinition` property at compile time.
public protocol ChatCompletionsTool: Sendable {
	/// The arguments type, which must conform to `ChatCompletionsToolArguments`.
	associatedtype Arguments: ChatCompletionsToolArguments

	/// The snake_case name derived from the struct name.
	static var name: String { get }

	/// The description extracted from the struct's doc comment.
	static var description: String { get }

	/// The OpenAI-compatible tool definition for this tool.
	static var toolDefinition: ToolDefinition { get }

	/// Execute the tool with the given arguments.
	func call(arguments: Arguments) async throws -> ToolOutput
}
