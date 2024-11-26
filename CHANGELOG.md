## 0.x.y

* fixed [#62](https://github.com/csells/flutter_ai_toolkit/issues/62): bug: getting an image back from the LLM that doesn't exist throws an exception

* expanded the `messageSender` docs on `LlmChatView` to make it clear what it's for and when it's used

* renamed FatXxx to ToolkitXxx e.g. FatColors => ToolkitColors

## 0.6.3

* fixed [#55](https://github.com/csells/flutter_ai_toolkit/issues/55): TextField overflow error for large inputs

* fixed [#39](https://github.com/csells/flutter_ai_toolkit/issues/39): bug: notify developer of invalid API key on the web

* fixed [#18](https://github.com/csells/flutter_ai_toolkit/issues/18): Gemini or Vertex + the web + a file attachment == hang

## 0.6.2

* minor API and README updates based on review feedback

## 0.6.1

* implemented [#16](https://github.com/csells/flutter_ai_toolkit/issues/16): feature: ensure pressing the camera button on desktop web brings up the camera

## 0.6.0

* simplifying the `LlmProvider` interface for implementors

## 0.5.0

* fixed [#67](https://github.com/csells/flutter_ai_toolkit/issues/67): bug: audio recording translation repopulated after history cleared

* fixed [#68](https://github.com/csells/flutter_ai_toolkit/issues/68): bug: need suggestion styling

* implemented [#72](https://github.com/csells/flutter_ai_toolkit/issues/72): feature: move welcome message to the LlmChatView

* updated recipes sample to use required properties in the JSON schema, which improved LLM responses a great deal

* implemented [#74](https://github.com/csells/flutter_ai_toolkit/issues/74): remove controllers as an unnecessary abstraction

* fixed an issue where canceling an operation w/ no response yet will continue showing the progress indicator.


## 0.4.2

* upgraded to waveform_recorder 1.3.0

* fix [#69](https://github.com/csells/flutter_ai_toolkit/issues/69): SDK dependency conflict by lowering sdk requirement to 3.4.0

## 0.4.1

* updated samples, demo and README

## 0.4.0

* implemented [#13](https://github.com/csells/flutter_ai_toolkit/issues/13): UI needs dark mode support

* implemented [#30](https://github.com/csells/flutter_ai_toolkit/issues/30): chat serialization/deserialization

* fixed [#64](https://github.com/csells/flutter_ai_toolkit/issues/64): bug: selection sticks around after clearing the history

* fixed [#63](https://github.com/csells/flutter_ai_toolkit/issues/63): bug: broke multi-line text input

* fixed [#60](https://github.com/csells/flutter_ai_toolkit/issues/60): bug: if an LLM request fails with no text in the response, the progress indicator never stops

* implemented [#31](https://github.com/csells/flutter_ai_toolkit/issues/31): feature: provide a list of initial suggested prompts to display in an empty chat session

* implemented [#25](https://github.com/csells/flutter_ai_toolkit/issues/25): better mobile long-press action menu for chat messages

* fixed [#47](https://github.com/csells/flutter_ai_toolkit/issues/25): bug: Long pressing a message and then clicking outside of the toolbar should make the toolbar disappear

## 0.3.0

* implemented [#32](https://github.com/csells/flutter_ai_toolkit/issues/32): feature: dev-configured LLM message icon

* fixed [#19](https://github.com/csells/flutter_ai_toolkit/issues/19): prompt attachments are incorrectly merging when editing after adding attachments to a new prompt

* implemented [#27](https://github.com/csells/flutter_ai_toolkit/issues/27): feature: styling of colors and fonts

## 0.2.1

* fixing the user message edit menu

* show errors and cancelations as separate from message output; this is necessary so that you can tell the difference between an LLM message response with a successful result that, for example, can be parsed as JSON, or an error

## 0.2.0

* implemented [#33](https://github.com/csells/flutter_ai_toolkit/issues/33): feature: chat microphone only prompt input

* added a `generateStream` method to `LlmProvider` to support talking to the underlying generative model w/o adding to the chat history; moved `chatModel` properties in the Gemini and Vertex providers to use a more generic `generativeModel` to make it clear which model is being used for both `sendMessageStream` and `generateStream`.

* moved from [flutter_markdown_selectionarea](https://pub.dev/packages/flutter_markdown_selectionarea) to plain ol' [flutter_markdown](https://pub.dev/packages/flutter_markdown) which does now support selection if you ask it nicely. I still have some work to do on selection, however, as described in [issue #12](https://github.com/csells/flutter_ai_toolkit/issues/12).

* implemented [#27](https://github.com/csells/flutter_ai_toolkit/issues/27): styling support, including a sample

* fixed [#3](https://github.com/csells/flutter_ai_toolkit/issues/3): ensure Google Font Roboto is being resolved

* implemented [#2](https://github.com/csells/flutter_ai_toolkit/issues/2): feature: enable full functionality inside a Cupertino app

* fixed [#45](https://github.com/csells/flutter_ai_toolkit/issues/45): bug: X icon button is also pushing up against the top and left edges without any padding

* fixed [#59](https://github.com/csells/flutter_ai_toolkit/issues/59): bug: Android Studio LadyBug Upgrade Issues

* upgraded to the GA version of firebase_vertexai

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