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

public extension ChatGPTModel where Self == GPT3ChatGPTModel {
    static var gpt3: GPT3ChatGPTModel {
        GPT3ChatGPTModel()
    }
}

public extension ChatGPTModel where Self == GPT4ChatGPTModel {
    static var gpt4: GPT4ChatGPTModel {
        GPT4ChatGPTModel()
    }
}

public extension ChatGPTModel where Self == GPT4LargeContextChatGPTModel {
    static var gpt4LargeContext: GPT4LargeContextChatGPTModel {
        GPT4LargeContextChatGPTModel()
    }
}
