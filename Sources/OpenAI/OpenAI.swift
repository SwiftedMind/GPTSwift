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
@_exported import GPTSwiftSharedTypes

/// A class for interacting with the OpenAI API to fetch information about available models and retrieve specific models.
public class OpenAI {

    /// The API client used for making API requests.
    private let client: APIClient

    /// The API client request handler used for managing API request configurations.
    private let apiClientRequestHandler: _APIClientRequestHandler

    /// Initializes a new instance of the OpenAI class with the provided API key.
    ///
    /// - Parameter apiKey: The API key used for authentication when making API requests.
    /// - Parameter urlSessionConfiguration: An optional URL session configuration object.
    public init(
        apiKey: String,
        urlSessionConfiguration: URLSessionConfiguration? = nil
    ) {
        self.apiClientRequestHandler = .init(apiKey: apiKey)
        self.client = APIClient(baseURL: URL(string: API.base)) { [apiClientRequestHandler] configuration in
            configuration.delegate = apiClientRequestHandler
            if let urlSessionConfiguration {
                configuration.sessionConfiguration = urlSessionConfiguration
            }
        }
    }

    /// Asynchronously fetches a list of available models from the OpenAI API.
    ///
    /// This method corresponds to the "List models" API endpoint.
    ///
    /// - Returns: An array of `ModelData` objects representing the available models.
    /// - Throws: A `GPTSwiftError` if the request fails or the server returns an unauthorized status code.
    public func availableModels() async throws -> [ModelData] {
        let request = Request<ModelListResponse>(path: API.v1Models)
        return try await send(request: request).data
    }

    /// Asynchronously retrieves a specific model from the OpenAI API using the provided model ID.
    ///
    /// This method corresponds to the "Retrieve model" API endpoint.
    ///
    /// - Parameter id: The ID of the model to retrieve.
    /// - Returns: A `ModelData` object representing the requested model.
    /// - Throws: A `GPTSwiftError` if the request fails or the server returns an unauthorized status code.
    public func model(withId id: String) async throws -> ModelData {
        let request = Request<ModelData>(path: API.v1Model(withId: id))
        return try await send(request: request)
    }

    /// Sends the request, catches all errors and replaces them with a `GPTSwiftError`. If successful, it returns the response value.
    /// - Parameter request: The request to send.
    /// - Returns: The response object, already decoded.
    private func send<Response: Codable>(request: Request<Response>) async throws -> Response {
        do {
            return try await client.send(request).value
        } catch {
            throw _errorToGPTSwiftError(error)
        }
    }
}
