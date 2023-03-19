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

/// The response for a GPT `ChatRequest` that is streamed.
struct ChatStreamedResponse: Codable {

    /// An identifier for the response.
    var id: String

    /// The description of the response. Usually, this should be "chat.completion".
    var object: String

    /// The creation date of the response.
    var created: Int

    /// The model used for generating the response.
    var model: String

    /// The answers that GPT generated.
    var choices: [Choice]
}

extension ChatStreamedResponse {

    /// An answer that GPT generated.
    struct Choice: Codable {

        /// The actual message of the answer.
        var delta: ChatStreamedMessage

        /// An optional reason for the termination of the message.
        ///
        /// For example, this can be "stop" to indicate GPT considers the answer as done.
        var finishReason: String?

        /// The index of the message in the messages array of `CompletionResponse`.
        var index: Int

        enum CodingKeys: String, CodingKey {
            case delta
            case finishReason = "finish_reason"
            case index
        }
    }
}
