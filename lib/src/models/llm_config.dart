class LlmConfig {
  /// Top K number of tokens to be sampled from for each decoding step.
  int topK = 40;

  /// Context size window for the LLM.
  int maxTokens = 1024;

  /// Randomness when decoding the next token.
  double temp = 0.8;
}
