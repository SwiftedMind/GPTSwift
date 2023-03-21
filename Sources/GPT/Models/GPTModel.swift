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

public protocol GPTModel {
    var rawValue: String { get }
}

// MARK: - Default ChatGPTModel

public struct DefaultGPTModel: GPTModel {
    public var rawValue: String = ""
}

// MARK: - Custom GPTModel

public struct CustomGPTModel: GPTModel {
    public var rawValue: String
}

// MARK: - GPT 3 Model

public struct DavinciGPTModel: GPTModel {
    public var rawValue: String = "text-davinci-003"
}

// MARK: - Protocol Extensions

public extension GPTModel where Self == DefaultGPTModel {
    static var `default`: Self {
        DefaultGPTModel()
    }
}

public extension GPTModel where Self == CustomGPTModel {
    /// A fallback model descriptor with which you can set a custom model id string yourself.
    ///
    /// Use this, if you need to use a model that is not explicitly provided by GPTSwift. Keep in mind, however, that the model has to behave exactly like the provided ones. Otherwise, the request will likely fail.
    /// - Parameter modelId: The model id to use, e.g. "gpt-4-some-awesome-variation".
    /// - Returns: The model descriptor.
    static func custom(modelId: String) -> Self {
        CustomGPTModel(rawValue: modelId)
    }
}

public extension GPTModel where Self == DavinciGPTModel {
    /// The davinci model descriptor.
    static var davinci: DavinciGPTModel {
        DavinciGPTModel()
    }
}
