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

let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY", defaultModel: .gpt3)
let answer = try await chatGPT.ask("What is the answer to life, the universe and everything in it?")

// Stream the answer token by token
var streamedAnswer = ""
for try await nextWord in try await chatGPT.streamedAnswer.ask("Tell me a story about birds") {
  streamedAnswer += nextWord
}
```

An example project can be found here: [GPTPlayground](https://github.com/SwiftedMind/GPTPlayground/tree/main)

## Content

- [**Getting Started**](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
- [**How to Use**](#how-to-use)
- [Generating cURL Prompts](#generating-curl-prompts)
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

## How to Use

GPTSwift is just a lightweight wrapper around the API that abstracts away all the unnecessary details of calling endpoints and handling requests and responses.

### ChatGPT

The `ChatGPT` target gives you access to the ChatGPT API (including the GPT4 models).

The easiest way of using `ChatGPT` is by simply passing in a prompt string or an array of chat messages via the `ask(_:)` and `ask(messages:)` methods. These take care of turning the arguments into a request as well as parsing the response. All you get is the answer as a simple string, which is often all that's needed.

```swift
import ChatGPT

func askChatGPT() async throws {
  let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY", defaultModel: .gpt3)

  // Basic query
  let firstResponse = try await chatGPT.ask("What is the answer to life, the universe and everything in it?")
  print(firstResponse)

  // Send multiple messages
  let secondResponse = try await chatGPT.ask(
      messages: [
          ChatMessage(role: .system, content: "You are a dog."),
          ChatMessage(role: .user, content: "Do you actually like playing fetch?")
      ],
      model: .gpt3.stableVersion() // Override default model, if needed
  )
  print(secondResponse)
}
```
                                                                                 
However, if you need full control, you can also pass a `ChatRequest` to the `ask(request:)` method. With this, you can adjust all parameters and have access to the full response object, while everything is still fully type-safe.
                                                                 
```swift
import ChatGPT

func askChatGPT() async throws {
  let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY", defaultModel: .gpt3)

  let fullRequest = ChatRequest.gpt3 { request in
    request.messages = [
        .init(role: .system, content: "You are the pilot of an alien UFO. Be creative."),
        .init(role: .user, content: "Where do you come from?")
    ]
    request.temperature = 0.8
    request.numberOfAnswers = 2
  }

  let response = try await chatGPT.ask(request: fullRequest)
  print(response.choices.map(\.message))
}
```

Finally, all of the above methods have a variant that lets you stream GPT's answer token by token, right as they are generated. The stream is provided via an `AsyncThrowingStream`. All you have to do is add a `streamedAnswer` before the call to `ask()`. For example:

```swift
import ChatGPT

// In your view model
@Published var gptAnswer = ""

func askChatGPT() async throws {
  let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY")

  gptAnswer = ""
  for try await nextWord in try await chatGPT.streamedAnswer.ask("Tell me a funny story about birds") {
      gptAnswer += nextWord
  }
}
```

For more information about the ChatGPT API, you can look at OpenAI's documentation:
- [ChatGPT API Introduction](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
- [ChatGPT API documentation](https://platform.openai.com/docs/api-reference/chat/create)


### GPT
                                                                                                      
Like `ChatGPT`, `GPT` is a wrapper around the completion API. There is a basic `complete(_:)` method for convenient use, as well as a `complete(request:)` method that gives you full control.

```swift
import GPT

func askGPT() async throws {
  let gpt = GPT(apiKey: "YOUR_API_KEY", defaultModel: .davinci)

  let response = try await gpt.complete("What is the answer to life, the universe and everything in it?")
  print(response)
}                                                                                                      
```
                                                                            
```swift
import GPT

func askGPT() async throws {
  let gpt = GPT(apiKey: "YOUR_API_KEY", defaultModel: .davinci)

  let fullRequest = CompletionRequest.davinci(prompt: "Why is the sky blue?") { request in
      request.temperature = 0.8
      request.numberOfAnswers = 2
  }

  let response = try await gpt.complete(request: fullRequest)
  print(response.choices.map(\.text))
}                                                                                                      
```
                                                                            
Additionally, just like `ChatGPT`, `GPT` also supports streaming answers:
                                                                            
```swift
import GPT

// In your view model
@Published var gptAnswer = ""

func askGPT() async throws {
  let gpt = GPT(apiKey: "YOUR_API_KEY")

  gptAnswer = ""
  for try await nextWord in try await gpt.streamedAnswer.complete("Tell me a funny story about birds") {
      gptAnswer += nextWord
  }
}
```

### OpenAI

Finally, you can access the available models throught the `OpenAI` class.

```swift
import OpenAI

func openAI() async throws {
  let openAI = OpenAI(apiKey: "YOUR_API_KEY")

  let models = try await openAI.availableModels()
  let model = try await openAI.model(withId: "gpt-3.5-turbo")
}
```

## Generating cURL Prompts

Sometimes, it might be useful to see the generated requests, so all three classes introduced above come with methods that generate a usable `cURL` prompt from a request that you can simply paste into a terminal. For example:

```swift
import ChatGPT

func askChatGPT() async throws {
  let chatGPT = ChatGPT(apiKey: "YOUR_API_KEY", defaultModel: .gpt3)

  let request = ChatRequest.gpt3 { request in
      request.messages = [
          .init(role: .system, content: "You are the pilot of an alien UFO. Be creative."),
          .init(role: .user, content: "Where do you come from?")
      ]
      request.numberOfAnswers = 2
  }

  try await print(chatGPT.curl(for: request))
}
```

This generates the following:

```
curl --request POST \
--url 'https://api.openai.com/v1/chat/completions' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--data '{"messages":[{"content":"You are the pilot of an alien UFO. Be creative.","role":"system"},{"content":"Where do you come from?","role":"user"}],"model":"gpt-3.5-turbo","n":2,"stream":false}' | json_pp

```

## License

MIT License

Copyright (c) 2023 Dennis Müller and all collaborators

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
