## 0.2.0 (pending)

* implemented [#33](https://github.com/csells/flutter_ai_toolkit/issues/33): feature: chat microphone only prompt input

* added a `generateStream` method to `LlmProvider` to support talking to the underlying generative model w/o adding to the chat history; moved `chatModel` properties in the Gemini and Vertex providers to use a more generic `generativeModel` to make it clear which model is being used for both `sendMessageStream` and `generateStream`.

* moved from [flutter_markdown_selectionarea](https://pub.dev/packages/flutter_markdown_selectionarea) to plain ol' [flutter_markdown](https://pub.dev/packages/flutter_markdown) which does now support selection if you ask it nicely. I still have some work to do on selection, however, as described in [issue #12](https://github.com/csells/flutter_ai_toolkit/issues/12).

* implemented [#27](https://github.com/csells/flutter_ai_toolkit/issues/27): styling support, including a sample

* fixed [#3](https://github.com/csells/flutter_ai_toolkit/issues/3): ensure Google Font Roboto is being resolved

* implemented [#2](https://github.com/csells/flutter_ai_toolkit/issues/2): feature: enable full functionality inside a Cupertino app

* fixed [#45]: bug: X icon button is also pushing up against the top and left edges without any padding

## 0.1.6

* added optional `welcomeMessage` to `LlmChatView` and a welcome sample. thanks, @berkaykurkcu!

* updated VertexProvider to take a separate chat and embedding model like GeminiProvider

* fixed #51 : Click on an image to get a preview. thanks,  @Shashwat-111!

* fixed #6: get a spark icon to designate the LLM
 
* updated README for clarity

## 0.1.5

* Reference docs update

## 0.1.4

* CHANGELOG fix

## 0.1.3

* new real-world-ish sample: recipes

* new custom LLM provider sample: gemma

* handling structured LLM responses via `responseBuilder` (see recipes sample)

* app-provided prompt suggestions (see recipes sample)

* pre-processing prompts to add prompt engineering via `messageSender`

* pre-processing requests to enrich the output, e.g. host Flutter widgets (see recipes sample)

* swappable support for LLM providers; oob support for Gemini and Vertex (see gemma example)

* fixed trim and over-eager message editing issues -- thanks, @Shashwat-111!

## 0.1.2

* More README fixups

## 0.1.1

* Fixing README screenshot (sigh)

## 0.1.0

* Initial alpha release