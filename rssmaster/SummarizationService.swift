import Foundation

struct OpenRouterMessage: Codable {
    let role: String
    let content: String
}

struct OpenRouterRequest: Codable {
    let model: String
    let messages: [OpenRouterMessage]
    let max_tokens: Int?
    let temperature: Double?
}

struct OpenRouterChoiceMessage: Codable {
    let role: String
    let content: String
}

struct OpenRouterChoice: Codable {
    let message: OpenRouterChoiceMessage
}

struct OpenRouterResponse: Codable {
    let choices: [OpenRouterChoice]
}

actor SummarizationService {
    static let shared = SummarizationService()

    // NOTE: For production, do NOT hardcode API keys. Use secure storage or a backend proxy.
    private let apiKey: String = "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"
    private let endpoint = URL(string: "https://openrouter.ai/api/v1/chat/completions")!

    func summarize(title: String, description: String) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let systemPrompt = "You are an expert podcast summarizer. Write a concise, engaging summary in at most 6 sentences. Use simple, clear language that anyone can understand. Avoid jargon, emojis, and marketing fluff. Keep the tone friendly and appealing."

        let userPrompt = "Title: \(title)\n\nEpisode Notes/Description:\n\n\(description)\n\nInstructions: Summarize the above content. Use at most 6 sentences. Keep it simple and appealing."

        let body = OpenRouterRequest(
            model: "deepseek/deepseek-chat-v3.1:free",
            messages: [
                OpenRouterMessage(role: "system", content: systemPrompt),
                OpenRouterMessage(role: "user", content: userPrompt)
            ],
            max_tokens: 320,
            temperature: 0.7
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "<no body>"
            throw NSError(domain: "SummarizationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "OpenRouter request failed: \((response as? HTTPURLResponse)?.statusCode ?? -1) — \(raw)"])
        }

        let decoded = try JSONDecoder().decode(OpenRouterResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "SummarizationService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No summary returned by model."])
        }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
