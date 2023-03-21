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

        /// Generates a completion for the given user prompt using the specified model or the default model, streaming the response token by token.
        ///
        /// This method is a convenience method for the "Create completion" OpenAI API endpoint with the `stream` option enabled.
        ///
        /// - Parameter userPrompt: The prompt to complete.
        /// - Parameter model: The GPT model to use for generating the completion. Defaults to `.default`.
        /// - Returns: An `AsyncThrowingStream` of `String` objects representing tokens in the generated completion.
        /// - Throws: A `Swift.Error` if the request fails or the server returns an unauthorized status code.
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

            return try await complete(request: completionRequest)
        }

        /// Generates a completion for the given `CompletionRequest`, streaming the response token by token.
        ///
        /// This method provides full control over the completion request and corresponds to the "Create completion" OpenAI API endpoint with the `stream` option enabled.
        ///
        /// - Parameter completionRequest: A `CompletionRequest` object containing the details of the completion request.
        ///
        /// - Returns: An `AsyncThrowingStream` of `String` objects representing tokens in the generated completion.
        /// - Throws: A `Swift.Error` if the request fails or the server returns an unauthorized status code.

        @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
        public func complete(request completionRequest: CompletionRequest) async throws -> AsyncThrowingStream<String, Swift.Error> {
            let request = Request(path: API.v1Completion, method: .post, body: completionRequest)
            var urlRequest = try await client.makeURLRequest(for: request)
            _addHeaders(to: &urlRequest, apiKey: apiKey)

            do {
                let (result, response) = try await client.session.bytes(for: urlRequest)

                guard let response = response as? HTTPURLResponse else {
                    throw GPTSwiftError.responseParsingFailed
                }

                guard response.statusCode.isStatusCodeOkay else {
                    throw GPTSwiftError.requestFailed(message: "Response status code was unacceptable: \(response.statusCode)")
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
                            throw GPTSwiftError.responseParsingFailed
                        }

                        continuation.finish()
                    }
                }
            } catch {
                throw _errorToGPTSwiftError(error)
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
