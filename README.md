![GPTSwiftBanner](https://user-images.githubusercontent.com/7083109/222953457-ffaa5920-64c2-4b04-b6ad-e1341b89732c.png)


# GPTSwift

GPTSwift is a lightweight and convenient wrapper around the OpenAI API. It is completely written in Swift. Currently, only ChatGPT's API is supported.

Using GPTSwift is easy:

```swift
let gptSwift = ChatGPTSwift(apiKey: "YOUR_API_KEY")
try await gptSwift.ask("What is the answer to life, the universe and everything in it?")

// Stream the answers as they are generated
var answer = ""
for try await nextWord in try await gptSwift.streamedAnswer.ask("Tell me a story about birds") {
    answer += nextWord
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
.package(url: "https://github.com/SwiftedMind/GPTSwift", from: "2.0.0")
```

Alternatively, if you want to add the package to an Xcode project, go to `File` > `Add Packages...` and enter the URL "https://github.com/SwiftedMind/GPTSwift" into the search field at the top. GPTSwift should appear in the list. Select it and click "Add Package" in the bottom right.

## Usage

GPTSwift is just a lightweight wrapper around the API. Here are a few examples:

```swift
import GPTSwift

func askChatGPT() async throws {
    let gptSwift = ChatGPTSwift(apiKey: "YOUR_API_KEY")

    // Basic query
    let firstResponse = try await gptSwift.ask("What is the answer to life, the universe and everything in it?")
    print(firstResponse.choices.map(\.message))

    // Send multiple messages
    let secondResponse = try await gptSwift.ask(
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

    let thirdResponse = try await gptSwift.ask(with: fullRequest)
    print(thirdResponse.choices.map(\.message))
}
```

### Streaming answers

All of the above methods have a variant that lets you stream GPT's answer word for word, right as they are generated. The stream is provided to you via an `AsyncThrowingStream`. All you have to do is add a `streamedAnswer` before the call to `ask()`. For example:

```swift
import GPTSwift

// In your view model
@Published var gptAnswer = ""

func askChatGPT() async throws {
    let gptSwift = ChatGPTSwift(apiKey: "YOUR_API_KEY")

    // Basic query
    gptAnswer = ""
    for try await nextWord in try await gptSwift.streamedAnswer.ask("Tell me a story about birds") {
        gptAnswer += nextWord
    }
}
```

For more information about the API, you can look at OpenAI's documentation:
- [ChatGPT API Introduction](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
- [ChatGPT API documentation](https://platform.openai.com/docs/api-reference/chat/create)

## License

MIT License

Copyright (c) 2023 Dennis Müller and all collaborators

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
