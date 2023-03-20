<picture>
  <source width="150px" media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/7083109/226196409-dc77e5ef-4036-482f-93f1-6f83b800b088.png">
  <img width="150px" alt="GPTSwift Logo. Light: 'Light Mode' Dark: 'Dark Mode'" srchttps://user-images.githubusercontent.com/7083109/226196411-2913b92f-e993-4ad2-8da9-79ac63f237b3.png">
</picture>

# GPTSwift
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftedMind%2FGPTSwift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftedMind/GPTSwift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftedMind%2FGPTSwift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftedMind/GPTSwift)
![GitHub](https://img.shields.io/github/license/SwiftedMind/GPTSwift)

GPTSwift is a lightweight and convenient wrapper around the OpenAI API. It is completely written in Swift.

Using GPTSwift is easy:

```swift
import ChatGPT

let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY")
let answer = try await chatGPT.ask("What is the answer to life, the universe and everything in it?")

// Stream the answer token by token
var streamedAnswer = ""
for try await nextWord in try await chatGPT.streamedAnswer.ask("Tell me a story about birds") {
    streamedAnswer += nextWord
}
```

An example project can be found here: [GPTPlayground](https://github.com/SwiftedMind/GPTPlayground/tree/main)

## Content

- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Getting Started

### Requirements

GPTSwift supports iOS 15+, macOS 12+, watchOS 8+ and tvOS 15+.

### Installation

The package is installed through the Swift Package Manager. Simply add the following line to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/SwiftedMind/GPTSwift", from: "3.0.0")
```

Alternatively, if you want to add the package to an Xcode project, go to `File` > `Add Packages...` and enter the URL "https://github.com/SwiftedMind/GPTSwift" into the search field at the top. GPTSwift should appear in the list. Select it and click "Add Package" in the bottom right.

## Usage

GPTSwift is just a lightweight wrapper around the API. Here are a few examples:

### ChatGPT

```swift
import ChatGPT

func askChatGPT() async throws {
    let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY")

    // Basic query
    let firstResponse = try await chatGPT.ask("What is the answer to life, the universe and everything in it?")
    print(firstResponse)

    // Send multiple messages
    let secondResponse = try await chatGPT.ask(
        messages: [
            ChatMessage(role: .system, content: "You are a dog."),
            ChatMessage(role: .user, content: "Do you actually like playing fetch?")
        ]
    )
    print(secondResponse.choices.map(\.message))

    // Full control
    var fullRequest = ChatRequest(
        messages: [
            .init(role: .system, content: "You are the pilot of an alien UFO. Be creative."),
            .init(role: .user, content: "Where do you come from?")
        ]
    )
    fullRequest.temperature = 0.8
    fullRequest.numberOfAnswers = 2

    let thirdResponse = try await chatGPT.ask(request: fullRequest)
    print(thirdResponse.choices.map(\.message))
}
```

### Streaming answers

All of the above methods have a variant that lets you stream GPT's answer word for word, right as they are generated. The stream is provided to you via an `AsyncThrowingStream`. All you have to do is add a `streamedAnswer` before the call to `ask()`. For example:

```swift
import ChatGPT

// In your view model
@Published var gptAnswer = ""

func askChatGPT() async throws {
    let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY")

    // Basic query
    gptAnswer = ""
    for try await nextWord in try await chatGPT.streamedAnswer.ask("Tell me a funny story about birds") {
        gptAnswer += nextWord
    }
}
```

For more information about the ChatGPT API, you can look at OpenAI's documentation:
- [ChatGPT API Introduction](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
- [ChatGPT API documentation](https://platform.openai.com/docs/api-reference/chat/create)

## License

MIT License

Copyright (c) 2023 Dennis Müller and all collaborators

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
