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

public struct GPTSwiftError: Swift.Error {

    public static var unauthorized: Self {
        .init(kind: .unauthorized)
    }

    public static var requestFailed: Self {
        .init(kind: .requestFailed)
    }

    public static var responseParsingFailed: Self {
        .init(kind: .responseParsingFailed)
    }

    public static func other(_ error: Swift.Error) -> Self {
        .init(kind: .other(error))
    }

    enum Kind {
        case unauthorized
        case requestFailed
        case responseParsingFailed
        case other(Swift.Error)
    }

    let kind: Kind

    init(kind: Kind) {
        self.kind = kind
    }

    public var localizedDescription: String {
        switch kind {
        case .unauthorized:
            return "Unauthorized request. Have you provided the correct api key?"
        case .requestFailed:
            return "Something went wrong with the request."
        case .responseParsingFailed:
            return "Something went wrong with parsing the response."
        case .other(let error):
            return "An unknown error occurred: \(error)"
        }
    }
}
