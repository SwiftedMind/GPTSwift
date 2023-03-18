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

/// A simple wrapper around the API for OpenAI's GPT.
public class GPT {

    private let client: APIClient
    private let apiClientRequestHandler: APIClientRequestHandler
    private let globalModelDefault: GPTModel

    /// A version of GPTSwift that streams all the answers.
    public let streamedAnswer: StreamedAnswer

    /// A simple wrapper around the API for OpenAI.
    ///
    /// Currently only supporting ChatGPT's model.
    /// - Parameter apiKey: The api key you can generate in your account page on OpenAI's website.
    public init(apiKey: String, globalModelDefault: GPTModel = .davinci) {
        self.apiClientRequestHandler = .init(apiKey: apiKey)
        self.globalModelDefault = globalModelDefault
        self.client = APIClient(baseURL: URL(string: API.base)) { [apiClientRequestHandler] configuration in
            configuration.delegate = apiClientRequestHandler
        }
        self.streamedAnswer = .init(client: client, apiKey: apiKey, globalModelDefault: globalModelDefault)
    }

    public func complete(
        _ userPrompt: String,
        model: GPTModel? = nil
    ) async throws -> CompletionResponse {
        let request = Request<CompletionResponse>(
            path: API.v1Completion,
            method: .post,
            body: CompletionRequest(model: model ?? globalModelDefault, prompts: userPrompt)
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

        dump(request)
        dump(try! String(data: request.httpBody!, encoding: .utf8))
    }
}
