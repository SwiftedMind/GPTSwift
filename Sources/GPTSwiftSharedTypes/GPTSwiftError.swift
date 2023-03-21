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

/// A custom error type representing errors related to GPTSwift.
public struct GPTSwiftError: Swift.Error {

    /// Creates a new `GPTSwiftError` instance with the request failed error kind.
    ///
    /// - Parameter message: A string describing the error that occurred during the request.
    /// - Returns: A new `GPTSwiftError` instance.
    public static func requestFailed(message: String) -> Self {
        .init(kind: .requestFailed(message))
    }

    /// Creates a new `GPTSwiftError` instance with the response parsing failed error kind.
    ///
    /// - Returns: A new `GPTSwiftError` instance.
    public static var responseParsingFailed: Self {
        .init(kind: .responseParsingFailed)
    }

    /// Creates a new `GPTSwiftError` instance with the URL error kind.
    ///
    /// - Parameter error: The `URLError` instance that occurred.
    /// - Returns: A new `GPTSwiftError` instance.
    public static func urlError(_ error: URLError) -> Self {
        .init(kind: .urlError(error))
    }

    /// Creates a new `GPTSwiftError` instance with the other error kind.
    ///
    /// - Parameter error: The `Error` instance representing the unknown error that occurred.
    /// - Returns: A new `GPTSwiftError` instance.
    public static func other(_ error: Swift.Error) -> Self {
        .init(kind: .other(error))
    }

    /// Creates a new `GPTSwiftError` instance with the OpenAI error kind.
    ///
    /// - Parameter error: The `OpenAIError` instance that occurred.
    /// - Returns: A new `GPTSwiftError` instance.
    public static func openAIError(_ error: OpenAIError) -> Self {
        .init(kind: .openAIError(error))
    }

    /// The specific kind of `GPTSwiftError`.
    public var kind: Kind

    /// A string prefix used for error messages.
    private var prefix: String { "GPTSwiftError: " }

    /// A string describing the error.
    public var message: String {
        switch kind {
        case .requestFailed(let message):
            return prefix + message
        case .responseParsingFailed:
            return prefix + "Something went wrong with parsing the response."
        case .urlError(let error):
            return prefix + error.localizedDescription
        case .other(let error):
            return prefix + "An unknown error occurred: »\(error)«"
        case .openAIError(let error):
            return prefix + "(OpenAI response) »\(error.message)« - type »\(error.type)« - code: \(error.code ?? "not provided")"
        }
    }

    /// Initializes a new `GPTSwiftError` instance with the given kind.
    ///
    /// - Parameter kind: The specific kind of `GPTSwiftError`.
    init(kind: Kind) {
        self.kind = kind
    }

    /// A localized description of the error.
    public var localizedDescription: String {
        message
    }
}

/// An extension to `GPTSwiftError` containing an enumeration for different error kinds.
extension GPTSwiftError {
    public enum Kind {
        /// An error kind indicating that a request failed.
        ///
        /// - Associated value: A string describing the error that occurred during the request.
        case requestFailed(String)

        /// An error kind indicating that parsing the response failed.
        case responseParsingFailed

        /// An error kind indicating that a URL error occurred.
        ///
        /// - Associated value: The `URLError` instance that occurred.
        case urlError(URLError)

        /// An error kind indicating that an OpenAI error occurred.
        ///
        /// - Associated value: The `OpenAIError` instance that occurred.
        case openAIError(OpenAIError)

        /// An error kind indicating that an unknown error occurred.
        ///
        /// - Associated value: The `Error` instance representing the unknown error that occurred.
        case other(Swift.Error)
    }
}
