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

/// A simple wrapper around the API for OpenAI's ChatGPT with support for GPT3 as well as GPT4.
public class ChatGPT {

    private let client: APIClient
    private let apiClientRequestHandler: APIClientRequestHandler

    private let globalModelDefault: ChatGPTModel

    /// A version of GPTSwift that streams all the answers.
    public let streamedAnswer: StreamedAnswer

    /// A simple wrapper around the API for OpenAI.
    ///
    /// Currently only supporting ChatGPT's model.
    /// - Parameter apiKey: The api key you can generate in your account page on OpenAI's website.
    /// - Parameter globalModelDefault: Sets the default model for all requests coming from this `ChatGPT` instance.
    public init(apiKey: String, globalModelDefault: ChatGPTModel = .gpt3) {
        self.apiClientRequestHandler = .init(apiKey: apiKey)
        self.globalModelDefault = globalModelDefault
        self.client = APIClient(baseURL: URL(string: API.base)) { [apiClientRequestHandler] configuration in
            configuration.delegate = apiClientRequestHandler
        }
        self.streamedAnswer = .init(client: client, apiKey: apiKey, globalModelDefault: globalModelDefault)
    }

    /// Ask ChatGPT a single prompt without any special configuration.
    /// - Parameter userPrompt: The prompt to send
    /// - Parameter systemPrompt: an optional system prompt to give GPT instructions on how to answer.
    /// - Parameter model: The model that should be used. If this is `nil`, then `ChatGPT.globalModelDefault` will be used.
    /// - Returns: The response as string.
    public func ask(
        _ userPrompt: String,
        withSystemPrompt systemPrompt: String? = nil,
        model: ChatGPTModel? = nil
    ) async throws -> String {
        var messages: [ChatMessage] = []

        if let systemPrompt {
            messages.insert(.init(role: .system, content: systemPrompt), at: 0)
        }

        messages.append(.init(role: .user, content: userPrompt))

        let request = Request<ChatResponse>(
            path: API.v1ChatCompletion,
            method: .post,
            body: ChatRequest(model: model ?? globalModelDefault, messages: messages)
        )

        do {
            let response = try await client.send(request).value

            guard let answer = response.choices.first?.message.content else {
                throw Error.couldNotParseResponse
            }

            return answer
        } catch let error as APIError {
            switch error {
            case let .unacceptableStatusCode(int) where int == 401:
                throw Error.unauthorized
            default:
                throw Error.requestFailed
            }
        } catch {
            throw Error.requestFailed
        }
    }

    /// Ask ChatGPT something by sending multiple messages without any special configuration.
    /// - Parameter messages: The chat messages.
    /// - Returns: The response.
    public func ask(messages: [ChatMessage], model: ChatGPTModel = .gpt3) async throws -> ChatResponse {
        let request = Request<ChatResponse>(
            path: API.v1ChatCompletion,
            method: .post,
            body: ChatRequest(model: .gpt3, messages: messages)
        )

        do {
            return try await client.send(request).value
        } catch let error as APIError {
            switch error {
            case let .unacceptableStatusCode(int) where int == 401:
                throw Error.unauthorized
            default:
                throw Error.requestFailed
            }
        } catch {
            throw Error.requestFailed
        }
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
        do {
            return try await client.send(request).value
        } catch let error as APIError {
            switch error {
            case let .unacceptableStatusCode(int) where int == 401:
                throw Error.unauthorized
            default:
                throw Error.requestFailed
            }
        } catch {
            throw Error.requestFailed
        }
    }
}

public extension ChatGPT {
    enum Error: Swift.Error {
        case unauthorized
        case requestFailed
        case couldNotParseResponse

        public var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Request returned 401. Have you provided the correct api key?"
            case .requestFailed:
                return "The request failed."
            case .couldNotParseResponse:
                return "Could not decode response."
            }
        }
    }
}
