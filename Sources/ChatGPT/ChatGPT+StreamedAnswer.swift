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
import Base

extension ChatGPT {
    public class StreamedAnswer {
        private let client: APIClient
        private let apiKey: String
        private let defaultModel: ChatGPTModel

        init(client: APIClient, apiKey: String, defaultModel: ChatGPTModel) {
            self.client = client
            self.apiKey = apiKey
            self.defaultModel = defaultModel
        }

        /// Ask ChatGPT a single prompt without any special configuration.
        /// - Parameter userPrompt: The prompt to send
        /// - Parameter systemPrompt: An optional system prompt to give GPT instructions on how to answer.
        /// - Parameter model: The model that should be used.
        /// - Returns: The response.
        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func ask(
            _ userPrompt: String,
            withSystemPrompt systemPrompt: String? = nil,
            model: ChatGPTModel = .default
        ) async throws -> AsyncThrowingStream<String, Swift.Error> {
            var messages: [ChatMessage] = []

            if let systemPrompt {
                messages.insert(.init(role: .system, content: systemPrompt), at: 0)
            }

            messages.append(.init(role: .user, content: userPrompt))
            let usingModel = model is DefaultChatGPTModel ? defaultModel : model
            let chatRequest = ChatRequest(
                model: usingModel,
                messages: messages,
                stream: true
            )

            return try await ask(with: chatRequest)
        }

        /// Ask ChatGPT something by sending multiple messages without any special configuration.
        /// - Parameter messages: The chat messages.
        /// - Parameter model: The model that should be used.
        /// - Returns: The response.
        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func ask(
            messages: [ChatMessage],
            model: ChatGPTModel = .default
        ) async throws -> AsyncThrowingStream<String, Swift.Error> {
            let usingModel = model is DefaultChatGPTModel ? defaultModel : model
            let chatRequest = ChatRequest(model: usingModel, messages: messages, stream: true)
            return try await ask(with: chatRequest)
        }

        /// Ask ChatGPT something by providing a chat request object, giving you full control over the request's configuration.
        /// - Parameter chatRequest: The request.
        /// - Returns: The response.
        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func ask(with chatRequest: ChatRequest) async throws -> AsyncThrowingStream<String, Swift.Error> {
            let request = Request(path: API.v1ChatCompletion, method: .post, body: chatRequest)
            var urlRequest = try await client.makeURLRequest(for: request)
            addHeaders(to: &urlRequest, apiKey: apiKey)

            let (result, response) = try await client.session.bytes(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw Error.invalidResponse
            }

            guard response.statusCode.isStatusCodeOkay else {
                throw Error.unacceptableStatusCode(code: response.statusCode, message: "")
            }

            return AsyncThrowingStream { continuation in
                Task {
                    do {
                        for try await line in result.lines {
                            guard let chatResponse = line.asStreamedResponse else {
                                break
                            }

                            // Ignore lines where only the role is specified
                            if chatResponse.choices.first?.delta.role != nil {
                                continue
                            }

                            guard let message = chatResponse.choices.first?.delta.content else {
                                continue
                            }

                            // Yield next token
                            continuation.yield(message)
                        }
                    } catch {
                        throw Error.networkError(error)
                    }

                    continuation.finish()
                }
            }
        }
    }
}

extension ChatGPT.StreamedAnswer {
    public enum Error: Swift.Error {
        case invalidResponse
        case unacceptableStatusCode(code: Int, message: String)
        case networkError(Swift.Error)
    }
}

private let decoder = JSONDecoder()
private extension String {
    var asStreamedResponse: ChatStreamedResponse? {
        guard hasPrefix("data: "),
              let data = dropFirst(6).data(using: .utf8) else {
            return nil
        }
        return try! decoder.decode(ChatStreamedResponse.self, from: data)
    }
}

private extension Int {
    var isStatusCodeOkay: Bool {
        (200...299).contains(self)
    }
}
