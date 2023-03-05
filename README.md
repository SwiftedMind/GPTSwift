# GPTSwift

GPTSwift is a lightweight and convenient wrapper around the OpenAI API. It is completely written in Swift. Currently, only the ChatGPT's API is supported.

Using GPTSwift is easy:

```swift
try await gptSwift.askChatGPT("What is the answer to life, the universe and everything in it?")
```

## Content

- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
- [Documentation](#documentation)
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
