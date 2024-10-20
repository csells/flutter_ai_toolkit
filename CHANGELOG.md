## 0.2.0

* feature: chat microphone only prompt input (issue #33)

## 0.1.5

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