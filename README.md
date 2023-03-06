![GPTSwiftBanner](https://user-images.githubusercontent.com/7083109/222953457-ffaa5920-64c2-4b04-b6ad-e1341b89732c.png)


# GPTSwift
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftedMind%2FGPTSwift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftedMind/GPTSwift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftedMind%2FGPTSwift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftedMind/GPTSwift)


GPTSwift is a lightweight and convenient wrapper around the OpenAI API. It is completely written in Swift. Currently, only ChatGPT's API is supported.

Using GPTSwift is easy:

```swift
let gptSwift = GPTSwift(apiKey: "YOUR_API_KEY")
try await gptSwift.askChatGPT("What is the answer to life, the universe and everything in it?")
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

- iOS 13+
- macOS 10.15+

You will also need Swift 5.7 to compile the package.

### Installation

The package is installed through the Swift Package Manager. Simply add the following line to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/SwiftedMind/GPTSwift", from: "1.0.0")
```

Alternatively, if you want to add the package to an Xcode project, go to `File` > `Add Packages...` and enter the URL "https://github.com/SwiftedMind/GPTSwift" into the search field at the top. GPTSwift should appear in the list. Select it and click "Add Package" in the bottom right.

## Usage

> **Note**
> If you want to stream GPT's answers via an `AsyncThrowingStream`, checkout the `develop` branch, which has a working implementation for this. A new release will happen, once I've tested it a bit.

GPTSwift is just a lightweight wrapper around the API. Here are a few examples:

```swift
import GPTSwift

func askChatGPT() async throws {
    let gptSwift = GPTSwift(apiKey: "YOUR_API_KEY")

    // Basic query
    let firstResponse = try await gptSwift.askChatGPT("What is the answer to life, the universe and everything in it?")
    print(firstResponse.choices.map(\.message))

    // Send multiple messages
    let secondResponse = try await gptSwift.askChatGPT(
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

    let thirdResponse = try await gptSwift.askChatGPT(request: fullRequest)
    print(thirdResponse.choices.map(\.message))
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
