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

public struct CompletionRequest: Codable {

    /// The model to use.
    ///
    /// The default is to use the current model, that continuously receives updates.
    public var model: Model
  
    /// The prompts for the request.
    public var prompts: String//[CompletionPrompt]?


    public var suffix: String?

    /// The maximum number of tokens allowed for the response. If this is `nil`, it will default to allow the maximum number of tokens (4096 - message tokens). This does not mean, that all answers will generate that many tokens.
    public var maximumTokens: Int?

    /// The temperature for the request. This determines the randomness of the response.
    public var temperature: Double?

    /// An alternative way of controlling the temperature. Do not use at the same time as `temperature`.
    public var topP: Double?

    /// The number of answers that GPT should generate.
    ///
    /// The default is 1.
    public var numberOfAnswers: Double?

    public var logProbabilities: Int?

    public var includePromptsInResponse: Bool

    public var stopSequences: [String]?

    /// A mechanism to penalize the occurrence of new tokens based on whether they appear in the text so far.
    ///
    /// Should be a number between `-2.0` and `2.0`.
    public var presencePenalty: Double?

    /// A mechanism to penalize the occurrence of new tokens based on their frequency in the text.
    ///
    /// Should be a number between `-2.0` and `2.0`.
    public var frequencyPenalty: Double?

    public var bestOf: Int?

    /// Modifies the likelihood of specified tokens appearing in the answer.
    ///
    /// This maps token IDs to their bias value.
    public var logitBias: [String: Double]?

    /// An optional user identifier to help detect misuse of the API.
    public var user: String?

    var stream: Bool

    /// A chat request is the main interface to ChatGPT's API.
    public init(
        model: Model = .gpt3_5,
//        prompts: [CompletionPrompt]?,
        prompts: String,
        suffix: String? = nil,
        maximumTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        numberOfAnswers: Double? = nil,
        logProbabilities: Int? = nil,
        includePromptsInResponse: Bool = false,
        stopSequences: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        bestOf: Int? = nil,
        logitBias: [String : Double]? = nil,
        user: String? = nil,
        stream: Bool = false
    ) {
        self.model = model
        self.prompts = prompts
        self.suffix = suffix
        self.maximumTokens = maximumTokens
        self.temperature = temperature
        self.topP = topP
        self.numberOfAnswers = numberOfAnswers
        self.logProbabilities = logProbabilities
        self.includePromptsInResponse = includePromptsInResponse
        self.stopSequences = stopSequences
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.bestOf = bestOf
        self.logitBias = logitBias
        self.user = user
        self.stream = stream
    }

    public enum CodingKeys: String, CodingKey {
        case model
        case prompts = "prompt"
        case suffix
        case maximumTokens = "max_tokens"
        case temperature
        case topP = "top_p"
        case logProbabilities = "logprobs"
        case includePromptsInResponse = "echo"
        case stopSequences = "stop"
        case numberOfAnswers = "n"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case bestOf = "best_of"
        case logitBias = "logit_bias"
        case stream
        case user
    }
}

