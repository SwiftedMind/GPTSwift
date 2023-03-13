//
//  Copyright © 2023 Dennis Müller and all collaborators
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Get

/// A simple wrapper around the API for OpenAI's ChatGPT.
public class ChatGPTSwift: APIClientDelegate {

    private let client: APIClient
    private let apiClientRequestHandler: APIClientRequestHandler

    /// A version of GPTSwift that streams all the answers.
    public let streamedAnswer: StreamedAnswer

    /// A simple wrapper around the API for OpenAI.
    ///
    /// Currently only supporting ChatGPT's model.
    /// - Parameter apiKey: The api key you can generate in your account page on OpenAI's website.
    public init(apiKey: String) {
        self.apiClientRequestHandler = .init(apiKey: apiKey)
        self.client = APIClient(baseURL: URL(string: API.base)) { [apiClientRequestHandler] configuration in
            configuration.delegate = apiClientRequestHandler
        }
        self.streamedAnswer = .init(client: client, apiKey: apiKey)
    }

    /// Ask ChatGPT a single prompt without any special configuration.
    /// - Parameter userPrompt: The prompt to send
    /// - Returns: The response.
    public func ask(_ userPrompt: String) async throws -> ChatResponse {
        let request = Request<ChatResponse>(
            path: API.v1ChatCompletion,
            method: .post,
            body: ChatRequest(messages: [
                .init(role: .user, content: userPrompt)
            ])
        )


        return try await client.send(request).value
    }

    /// Ask ChatGPT something by sending multiple messages without any special configuration.
    /// - Parameter messages: The chat messages.
    /// - Returns: The response.
    public func ask(messages: [ChatMessage]) async throws -> ChatResponse {
        let request = Request<ChatResponse>(
            path: API.v1ChatCompletion,
            method: .post,
            body: ChatRequest(messages: messages)
        )
        return try await client.send(request).value
    }

    /// Ask ChatGPT something by providing a chat request object, giving you full control over the request's configuration.
    /// - Parameter request: The request.
    /// - Returns: The response.
    public func ask(with request: ChatRequest) async throws -> ChatResponse {
        let request = Request<ChatResponse>(
            path: API.v1ChatCompletion,
            method: .post,
            body: request
        )
        return try await client.send(request).value
    }
}

class APIClientRequestHandler: APIClientDelegate {
    let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
