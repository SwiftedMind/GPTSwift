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

public class OpenAI {

    private let client: APIClient
    private let apiClientRequestHandler: APIClientRequestHandler

    public init(apiKey: String) {
        self.apiClientRequestHandler = .init(apiKey: apiKey)
        self.client = APIClient(baseURL: URL(string: API.base)) { [apiClientRequestHandler] configuration in
            configuration.delegate = apiClientRequestHandler
        }
    }

    public func availableModels() async throws -> [ModelData] {
        let request = Request<ModelListResponse>(path: API.v1Models)
        do {
            return try await client.send(request).value.data
        } catch let error as APIError {
            switch error {
            case let .unacceptableStatusCode(int) where int == 401:
                throw Error.unauthorized
            default:
                throw Error.requestFailed
            }
        }
        catch {
            throw Error.requestFailed
        }
    }

    public func model(withId id: String) async throws -> ModelData {
        let request = Request<ModelData>(path: API.v1Model(withId: id))
        do {
            return try await client.send(request).value
        } catch let error as APIError {
            switch error {
            case let .unacceptableStatusCode(int) where int == 401:
                throw Error.unauthorized
            default:
                throw Error.requestFailed
            }
        }
        catch {
            throw Error.requestFailed
        }
    }
}

public extension OpenAI {
    enum Error: Swift.Error {
        case unauthorized
        case requestFailed

        public var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Request returned 401. Have you provided the correct api key?"
            case .requestFailed:
                return "The request failed."
            }
        }
    }
}
