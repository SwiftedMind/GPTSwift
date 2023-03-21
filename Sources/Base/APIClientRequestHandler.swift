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

import Foundation
import Get
import GPTSwiftSharedTypes

public func _addHeaders(to request: inout URLRequest, apiKey: String) {
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
}

public class _APIClientRequestHandler: APIClientDelegate {
    public let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        _addHeaders(to: &request, apiKey: apiKey)
    }

    public func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        if (200...299).contains(response.statusCode) { return }

        // If we can decode an error object from OpenAI, we use that as the error, as it contains useful information.
        if let openAIErrorDTO = try? JSONDecoder().decode(OpenAIErrorDTO.self, from: data) {
            throw openAIErrorDTO.error
        }
    }
}

/// Converts a `Swift.Error` object to a `GPTSwiftError`.
/// - Parameter error: The error to convert.
/// - Returns: A `GPTSwiftError`.
public func _errorToGPTSwiftError(_ error: Swift.Error) -> GPTSwiftError {
    switch error {
    case let openAIError as OpenAIError:
        return .openAIError(openAIError)
    case let apiError as APIError:
        return .requestFailed(message: apiError.localizedDescription)
    case let urlError as URLError:
        return .urlError(urlError)
    default:
        return .other(error)
    }
}

