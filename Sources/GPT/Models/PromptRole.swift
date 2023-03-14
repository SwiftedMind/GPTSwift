//
//  File.swift
//
//
//  Created by Dennis Müller on 05.03.23.
//

import Foundation

/// A role can be seen as the "owner", or "author" of a given message. You use this to allow GPT to differentiate between actual user prompts, behavior instructions (by you, the developer) and previous answers by GPT.
public enum PromptRole: String, Codable {

    /// The user role is the used for the prompts made by the end-user.
    case user

    /// The system role is used to instruct GPT on how to behave and what to generate.
    case system

    /// The assistant role is usually meant to indicate that a message originates from a previous GPT answer.
    ///
    /// This is useful because it allows GPT to recall previous answers and know about the general context of the conversation.
    case assistant
}
