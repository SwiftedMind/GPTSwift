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
import Base

/// A chat request is the main interface to ChatGPT's API.
///
/// For more information, see the [OpenAI documentation](https://platform.openai.com/docs/guides/chat/introduction).
/// And for detailed information about the parameters, see the [API documentation](https://platform.openai.com/docs/api-reference/chat).
public struct ChatRequest {

    /// The model to use.
    public var model: String

    /// The messages for the request.
    public var messages: [ChatMessage]

    /// The temperature for the request. This determines the randomness of the response.
    public var temperature: Double?

    /// An alternative way of controlling the temperature. Do not use at the same time as `temperature`.
    public var topP: Double?

    /// The number of answers that GPT should generate.
    ///
    /// The default is 1.
    public var numberOfAnswers: Double?

    /// A boolean flag indicating if the answers should be streamed.
    var stream: Bool

    /// Up to 4 sequences where the API will stop generating further tokens.
    public var stop: [String]?

    /// The maximum number of tokens allowed for the response. If this is `nil`, it will default to allow the maximum number of tokens (4096 - message tokens). This does not mean, that all answers will generate that many tokens.
    public var maximumTokens: Int?

    /// A mechanism to penalize the occurrence of new tokens based on whether they appear in the text so far.
    ///
    /// Should be a number between `-2.0` and `2.0`.
    public var presencePenalty: Double?

    /// A mechanism to penalize the occurrence of new tokens based on their frequency in the text.
    ///
    /// Should be a number between `-2.0` and `2.0`.
    public var frequencyPenalty: Double?

    /// Modifies the likelihood of specified tokens appearing in the answer.
    ///
    /// This maps token IDs to their bias value.
    public var logitBias: [String: Double]?

    /// An optional user identifier to help detect misuse of the API.
    public var user: String?

    /// A chat request is the main interface to ChatGPT's API.
    public init(
        model: ChatGPTModel = .gpt3,
        messages: [ChatMessage] = [],
        maximumTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        numberOfAnswers: Double? = nil,
        stop: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        logitBias: [String : Double]? = nil,
        user: String? = nil
    ) {
        self.model = model.rawValue
        self.messages = messages
        self.maximumTokens = maximumTokens
        self.temperature = temperature
        self.topP = topP
        self.numberOfAnswers = numberOfAnswers
        self.stop = stop
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.user = user
        self.stream = false
    }

    /// Convenience initializer that sets the model to `gpt3` and configures the request with the provided closure.
    /// - Parameters:
    ///   - configure: the configuration.
    /// - Returns: A configured instance of `ChatRequest`.
    public static func gpt3(configuration configure: ((_ request: inout ChatRequest) -> Void)? = nil) -> ChatRequest {
        var request = ChatRequest(model: .gpt3)
        configure?(&request)
        return request
    }

    /// Convenience initializer that sets the model to `gpt4` and configures the request with the provided closure.
    /// - Parameters:
    ///   - configure: the configuration.
    /// - Returns: A configured instance of `ChatRequest`.
    public static func gpt4(configuration configure: ((_ request: inout ChatRequest) -> Void)? = nil) -> ChatRequest {
        var request = ChatRequest(model: .gpt4)
        configure?(&request)
        return request
    }

    /// Convenience initializer that sets the model to `gpt4LargeContext` and configures the request with the provided closure.
    /// - Parameters:
    ///   - configure: the configuration.
    /// - Returns: A configured instance of `ChatRequest`.
    public static func gpt4LargeContext(configuration configure: ((_ request: inout ChatRequest) -> Void)? = nil) -> ChatRequest {
        var request = ChatRequest(model: .gpt4LargeContext)
        configure?(&request)
        return request
    }

    static func streamed(model: ChatGPTModel, messages: [ChatMessage]) -> Self {
        var request = ChatRequest(model: model, messages: messages)
        request.stream = true
        return request
    }
}

extension ChatRequest: Codable {

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case stop
        case maximumTokens = "max_tokens"
        case temperature
        case topP = "top_p"
        case numberOfAnswers = "n"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case stream
        case user
    }
}
