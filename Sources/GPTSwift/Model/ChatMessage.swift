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

/// A message is a part of the chat conversation.
///
/// GPT does not remember any previous messages, so if you want to keep a conversation coherent,
/// you should always send previous messages with every new chat request. It might also be useful to send GPT's answers with the request as well (using the message `role` `assistant`).
///
/// For more about this, see the [OpenAI documentation](https://platform.openai.com/docs/guides/chat/introduction).
public struct ChatMessage: Codable {

    /// The role of the message.
    public var role: Role

    /// The content of the message.
    public var content: String

    /// A message is a part of the chat conversation.
    public init(role: Role, content: String) {
        self.role = role
        self.content = content
    }
}

extension ChatMessage {
    
    /// A role can be seen as the "owner", or "author" of a given message. You use this to allow GPT to differentiate between actual user prompts, behavior instructions (by you, the developer) and previous answers by GPT.
    ///
    /// For more information, see the [OpenAI documentation](https://platform.openai.com/docs/guides/chat/introduction).
    public enum Role: String, Codable {

        /// The user role is the used for the prompts made by the end-user.
        case user

        /// The system role is used to instruct GPT on how to behave and what to generate.
        case system

        /// The assistant role is usually meant to indicate that a message originates from a previous GPT answer.
        ///
        /// This is useful because it allows GPT to recall previous answers and know about the general context of the conversation.
        case assistant
    }
}
