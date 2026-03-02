// BasicUsage.swift
// Examples of using SwiftChatCompletionsMacros
//
// NOTE: This file is for documentation purposes and is not compiled as part of
// the package. To use these examples, add SwiftChatCompletionsMacros as a
// dependency to your project.

import SwiftChatCompletionsMacros

// MARK: - Define Structured Arguments with @ChatCompletionsToolArguments

/// Use @ChatCompletionsToolArguments to define a struct whose properties map to a JSON Schema.
/// Each stored property becomes a schema property. Optional properties are
/// excluded from the "required" array.
@ChatCompletionsToolArguments
struct WeatherQuery {
	@ChatCompletionsToolGuide(description: "The city to get weather for")
	var location: String

	@ChatCompletionsToolGuide(description: "Temperature unit", .anyOf(["celsius", "fahrenheit"]))
	var unit: String?
}

// MARK: - Define a Tool with @ChatCompletionsTool

/// Use @ChatCompletionsTool on a struct to generate an OpenAI-compatible tool definition.
/// The struct needs:
/// 1. A nested `Arguments` type (or typealias) conforming to `ChatCompletionsToolArguments`
/// 2. A `call(arguments:)` method returning `ToolOutput`

/// Get the current weather for a location.
@ChatCompletionsTool
struct GetWeather {
	typealias Arguments = WeatherQuery

	func call(arguments: WeatherQuery) async throws -> ToolOutput {
		// Your API call or business logic here
		ToolOutput(content: "Sunny, 72F in \(arguments.location)")
	}
}

// MARK: - Using the Generated Tool Definition

/// The macro generates a `toolDefinition` property that encodes to
/// OpenAI's expected JSON format:
///
/// ```json
/// {
///   "type": "function",
///   "function": {
///     "name": "get_weather",
///     "description": "Get the current weather for a location.",
///     "parameters": {
///       "type": "object",
///       "properties": {
///         "location": {
///           "type": "string",
///           "description": "The city to get weather for"
///         },
///         "unit": {
///           "type": "string",
///           "description": "Temperature unit",
///           "enum": ["celsius", "fahrenheit"]
///         }
///       },
///       "required": ["location"],
///       "additionalProperties": false
///     }
///   }
/// }
/// ```
func example() throws {
	let definition = GetWeather.toolDefinition

	let encoder = JSONEncoder()
	encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
	let data = try encoder.encode(definition)
	let json = String(data: data, encoding: .utf8)!
	print(json)
}

// MARK: - Nested @ChatCompletionsToolArguments Types

@ChatCompletionsToolArguments
struct Address {
	@ChatCompletionsToolGuide(description: "Street address")
	var street: String

	@ChatCompletionsToolGuide(description: "City name")
	var city: String

	@ChatCompletionsToolGuide(description: "ZIP code")
	var zip: String
}

@ChatCompletionsToolArguments
struct ShippingRequest {
	@ChatCompletionsToolGuide(description: "Customer full name")
	var name: String

	var address: Address

	var items: [String]
}

// MARK: - Multiple Tools

/// Search the web for information.
@ChatCompletionsTool
struct SearchWeb {
	@ChatCompletionsToolArguments
	struct Arguments {
		@ChatCompletionsToolGuide(description: "The search query")
		var query: String

		@ChatCompletionsToolGuide(description: "Maximum number of results", .range(1...10))
		var maxResults: Int
	}

	func call(arguments: Arguments) async throws -> ToolOutput {
		ToolOutput(content: "Found results for: \(arguments.query)")
	}
}

/// Send an email to a recipient.
@ChatCompletionsTool
struct SendEmail {
	@ChatCompletionsToolArguments
	struct Arguments {
		@ChatCompletionsToolGuide(description: "Recipient email address")
		var to: String

		@ChatCompletionsToolGuide(description: "Email subject line")
		var subject: String

		@ChatCompletionsToolGuide(description: "Email body text")
		var body: String
	}

	func call(arguments: Arguments) async throws -> ToolOutput {
		ToolOutput(content: "Email sent to \(arguments.to)")
	}
}
