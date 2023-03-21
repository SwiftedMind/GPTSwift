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

public protocol ChatGPTModel {
    var rawValue: String { get }
}

// MARK: - Default ChatGPTModel

public struct DefaultChatGPTModel: ChatGPTModel {
    public var rawValue: String = ""
}

// MARK: - Custom ChatGPTModel

public struct CustomChatGPTModel: ChatGPTModel {
    public var rawValue: String
}

// MARK: - GPT 3 ChatGPTModel

public struct GPT3ChatGPTModel: ChatGPTModel {
    public var rawValue: String = "gpt-3.5-turbo"

    public func stableVersion(_ identifier: StableVersionIdentifier = .march_1_2023) -> GPT3ChatGPTModel {
        .init(rawValue: "gpt-3.5-turbo-0301")
    }

    public enum StableVersionIdentifier {
        case march_1_2023
    }
}

// MARK: - GPT 4 ChatGPTModel

public struct GPT4ChatGPTModel: ChatGPTModel {
    public var rawValue: String = "gpt-4"

    public func stableVersion(_ identifier: StableVersionIdentifier = .march_14_2023) -> GPT4ChatGPTModel {
        .init(rawValue: "gpt-4-0314")
    }

    public enum StableVersionIdentifier {
        case march_14_2023
    }
}

// MARK: - GPT 4 ChatGPTModel With Large Context

public struct GPT4LargeContextChatGPTModel: ChatGPTModel {
    public var rawValue: String = "gpt-4-32k"

    public func stableVersion(_ identifier: StableVersionIdentifier = .march_14_2023) -> GPT4ChatGPTModel {
        .init(rawValue: "gpt-4-32k-0314")
    }

    public enum StableVersionIdentifier {
        case march_14_2023
    }
}

// MARK: - Protocol Extensions

public extension ChatGPTModel where Self == DefaultChatGPTModel {
    static var `default`: Self {
        DefaultChatGPTModel()
    }
}

public extension ChatGPTModel where Self == CustomChatGPTModel {
    /// A fallback model descriptor with which you can set a custom model id string yourself.
    ///
    /// Use this, if you need to use a model that is not explicitly provided by GPTSwift. Keep in mind, however, that the model has to behave exactly like the provided ones. Otherwise, the request will likely fail.
    /// - Parameter modelId: The model id to use, e.g. "gpt-4-some-awesome-variation".
    /// - Returns: The model descriptor.
    static func custom(modelId: String) -> Self {
        CustomChatGPTModel(rawValue: modelId)
    }
}

public extension ChatGPTModel where Self == GPT3ChatGPTModel {
    /// The GPT3 model descriptor.
    static var gpt3: GPT3ChatGPTModel {
        GPT3ChatGPTModel()
    }
}

public extension ChatGPTModel where Self == GPT4ChatGPTModel {
    /// The GPT4 model descriptor.
    static var gpt4: GPT4ChatGPTModel {
        GPT4ChatGPTModel()
    }
}

public extension ChatGPTModel where Self == GPT4LargeContextChatGPTModel {
    /// The GPT4 "Large Context" model descriptor.
    static var gpt4LargeContext: GPT4LargeContextChatGPTModel {
        GPT4LargeContextChatGPTModel()
    }
}
