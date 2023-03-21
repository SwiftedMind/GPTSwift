# Changelog

## 3.0.0

> **Note**
> Fun Fact: Parts of the documentation for this update have been written by GPT4! I have proof-read them to make sure everything is fine but GPT4 just did it perfectly.

### Added

- Added GPT4 models (also including stable and large context versions) to `ChatGPT`. If you have access, enjoy!
- Added `GPT`, which is a wrapper around the completion API for GPT3. Also supports streaming the answers.
- Added `OpenAI`, which is a wrapper around two general OpenAI endpoints that list available models.
- Added more robust and convenient error handling. All errors are now exposed through [`GPTSwiftError`](https://github.com/SwiftedMind/GPTSwift/blob/main/Sources/GPTSwiftSharedTypes/GPTSwiftError.swift).
  - OpenAI error messages are now also passed through, which is useful to debug invalid requests (like out-of-bounds values).
- Added option to configure underlying URLSession in the initializers of `ChatGPT`,  `GPT` and `OpenAI`.
- Added option to set the default model to use for instances of `ChatGPT`,  `GPT` and `OpenAI`. You can set that in the initializer and then, if needed, override it in the individual methods.
- Added convenience methods to initialize requests and messages, for example `ChatRequest.gpt3(_:)` or `ChatMessage.system(_:)`.
- Added `curl(for:pretty:formatOutput:)` methods to `ChatGPT` and `GPT` that turns requests into a usable `curl` prompt that you can paste into a terminal to manually call the OpenAI endpoints.
  - `OpenAI` also has these convenience methods: `curlForAvailableModels(pretty:formatOutput:)` and `curlForModel(withId:pretty:formatOutput:)`

### Changed

- Renamed `ChatGPTSwift` to `ChatGPT`.
- `ChatGPT.ask(_:)` and `ChatGPT.ask(messages:)` have been made easier to use. They now return a String as the answer, instead of a complex object.
  - The intention behind this is to make basic usage of the framework as easy as possible while still allowing full control through `ChatGPT.ask(request:)`
- `ChatGPT`,  `GPT` and `OpenAI` now each have their own product to reduce namespace pollution. Simply import whichever you are using.
