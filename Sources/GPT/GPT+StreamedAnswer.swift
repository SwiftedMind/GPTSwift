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
import GPTSwiftSharedTypes

extension GPT {
    public class StreamedAnswer {
        private let client: APIClient
        private let apiKey: String
        private let defaultModel: GPTModel

        init(client: APIClient, apiKey: String, defaultModel: GPTModel) {
            self.client = client
            self.apiKey = apiKey
            self.defaultModel = defaultModel
        }

        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func complete(
            _ userPrompt: String,
            model: GPTModel = .default
        ) async throws -> AsyncThrowingStream<String, Swift.Error> {
            let usingModel = model is DefaultGPTModel ? defaultModel : model
            let completionRequest = CompletionRequest.streamed(
                model: usingModel,
                prompt: userPrompt
            )

            return try await complete(with: completionRequest)
        }

        /// Ask GPT something by providing a request object, giving you full control over the request's configuration.
        /// - Parameter completionRequest: The request.
        /// - Returns: The response.
        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func complete(with completionRequest: CompletionRequest) async throws -> AsyncThrowingStream<String, Swift.Error> {
            let request = Request(path: API.v1Completion, method: .post, body: completionRequest)
            var urlRequest = try await client.makeURLRequest(for: request)
            addHeaders(to: &urlRequest, apiKey: apiKey)

            let (result, response) = try await client.session.bytes(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw GPTSwiftError.requestFailed
            }

            guard response.statusCode.isStatusCodeOkay else {
                throw GPTSwiftError.requestFailed
            }

            return AsyncThrowingStream { continuation in
                Task {
                    do {
                        for try await line in result.lines {
                            guard let chatResponse = line.asStreamedResponse else {
                                break
                            }

                            guard let message = chatResponse.choices.first?.text else {
                                continue
                            }

                            // Yield next token
                            continuation.yield(message)
                        }
                    } catch {
                        throw GPTSwiftError.requestFailed
                    }

                    continuation.finish()
                }
            }
        }
    }
}

private let decoder = JSONDecoder()
private extension String {
    var asStreamedResponse: CompletionStreamedResponse? {
        guard hasPrefix("data: "),
              let data = dropFirst(6).data(using: .utf8) else {
            return nil
        }
        return try? decoder.decode(CompletionStreamedResponse.self, from: data)
    }
}

private extension Int {
    var isStatusCodeOkay: Bool {
        (200...299).contains(self)
    }
}
