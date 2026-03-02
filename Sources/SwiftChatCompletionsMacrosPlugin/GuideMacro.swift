import SwiftSyntax
import SwiftSyntaxMacros

/// `@ChatCompletionsToolGuide` is a marker macro. It generates no code itself.
/// `@ChatCompletionsToolArguments` reads `@ChatCompletionsToolGuide` attributes
/// from sibling properties during its expansion to enrich the generated JSON Schema.
public struct GuideMacro: PeerMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingPeersOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		// Marker macro — no code generation
		return []
	}
}
