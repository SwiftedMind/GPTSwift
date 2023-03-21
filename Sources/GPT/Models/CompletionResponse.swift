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

/// The response for a GPT `ChatRequest`.
public struct CompletionResponse: Codable {

    /// An identifier for the response.
    public var id: String

    /// The description of the response. Usually, this should be "chat.completion".
    public var object: String

    /// The creation date of the response.
    public var created: Int

    /// The model used for generating the response.
    public var model: String

    /// Usage statistics, for example the used tokens.
    public var usage: Usage

    /// The answers that GPT generated.
    public var choices: [Choice]
}

// MARK: - Subtypes

extension CompletionResponse {

    /// Usage statistics, for example the used tokens.
    public struct Usage: Codable {

        /// The number of tokens used to encode the request messages.
        public var promptTokens: Int

        /// The number of tokens used to encode the answers.
        public var completionTokens: Int

        /// The total number of tokens used.
        public var totalTokens: Int

        public enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

extension CompletionResponse {

    /// An answer that GPT generated.
    public struct Choice: Codable {

        /// The actual message of the answer.
        public var text: String

        /// An optional reason for the termination of the message.
        ///
        /// For example, this can be "stop" to indicate GPT considers the answer as done.
        public var finishReason: String?

        /// The index of the message in the messages array of `CompletionResponse`.
        public var index: Int

        public enum CodingKeys: String, CodingKey {
            case text
            case finishReason = "finish_reason"
            case index
        }
    }
}
