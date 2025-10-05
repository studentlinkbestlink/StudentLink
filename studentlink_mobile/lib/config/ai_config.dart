/// AI Configuration for StudentLink
/// Contains API keys and model configurations for AI services
class AiConfig {
  // OpenRouter API Configuration
  static const String openRouterApiKey = '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';
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  
  // Available free models on OpenRouter
  static const String defaultModel = 'deepseek/deepseek-r1:free'; // DeepSeek R1 Free
  static const String fastModel = 'grok-beta:free';
  static const String creativeModel = 'meta-llama/llama-3.1-8b-instruct:free';
  
  // Model selection based on use case
  static const Map<String, String> modelSelection = {
    'default': defaultModel,
    'fast': fastModel,
    'creative': creativeModel,
  };
  
  // API request configuration
  static const int maxTokens = 300;
  static const double temperature = 0.7;
  static const double topP = 0.9;
  static const int timeoutSeconds = 30;
  
  // Fallback configuration
  static const bool enableFallback = true;
  static const bool enableCaching = true;
  
  /// Get model for specific use case
  static String getModelForUseCase(String useCase) {
    return modelSelection[useCase] ?? defaultModel;
  }
  
  /// Check if API key is configured
  static bool get isApiKeyConfigured {
    return openRouterApiKey != 'sk-or-v1-your_api_key_here' && 
           openRouterApiKey.isNotEmpty;
  }
  
  /// Get API configuration headers
  static Map<String, String> getApiHeaders() {
    return {
      'Authorization': 'Bearer $openRouterApiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://studentlink.app',
      'X-Title': 'StudentLink AI Assistant',
    };
  }
}
