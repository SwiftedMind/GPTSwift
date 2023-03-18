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
import Get
import Base

struct ModelListResponse: Codable {
    var data: [ModelData]
}

public struct ModelData: Codable {
    var id: String
    var object: String
    var owner: String
    var root: String
    var permission: [Permissions]

    public enum CodingKeys: String, CodingKey {
        case id
        case object
        case owner = "owned_by"
        case root
        case permission
    }

    public struct Permissions: Codable {
        public var id: String
        public var object: String
        public var created: Int
        public var allowCreateEngine: Bool
        public var allowSampling: Bool
        public var allowLogprobs: Bool
        public var allowSearchIndices: Bool
        public var allowView: Bool
        public var allowFineTuning: Bool
        public var organization: String
        public var group: String?
        public var isBlocking: Bool

        public enum CodingKeys: String, CodingKey {
            case id
            case object
            case created
            case allowCreateEngine = "allow_create_engine"
            case allowSampling = "allow_sampling"
            case allowLogprobs = "allow_logprobs"
            case allowSearchIndices = "allow_search_indices"
            case allowView = "allow_view"
            case allowFineTuning = "allow_fine_tuning"
            case organization
            case group
            case isBlocking = "is_blocking"
        }
    }
}
/*
 {
 "id": "babbage-code-search-text",
 "object": "model",
 "created": 1651172509,
 "owned_by": "openai-dev",
 "permission": [
 {
 "id": "modelperm-Lftf8H4ZPDxNxVs0hHPJBUoe",
 "object": "model_permission",
 "created": 1669085863,
 "allow_create_engine": false,
 "allow_sampling": true,
 "allow_logprobs": true,
 "allow_search_indices": true,
 "allow_view": true,
 "allow_fine_tuning": false,
 "organization": "*",
 "group": null,
 "is_blocking": false
 }
 ],
 "root": "babbage-code-search-text",
 "parent": null
 },

 */
