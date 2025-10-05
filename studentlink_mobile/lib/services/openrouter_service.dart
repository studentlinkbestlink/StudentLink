import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';
import 'package:flutter/foundation.dart';

/// OpenRouter API Service for AI writing assistance
/// Uses free models available on OpenRouter platform
class OpenRouterService {
  static final OpenRouterService _instance = OpenRouterService._internal();
  factory OpenRouterService() => _instance;
  OpenRouterService._internal();

  // OpenRouter API configuration
  static const String _baseUrl = AiConfig.openRouterBaseUrl;
  
  // Free models available on OpenRouter
  static const String _defaultModel = AiConfig.defaultModel; // DeepSeek R1 Free
  static const String _fastModel = AiConfig.fastModel;
  static const String _creativeModel = AiConfig.creativeModel;

  /// Generate AI writing suggestion for concern descriptions
  Future<String> generateWritingSuggestion({
    required String userInput,
    String? concernType,
    String? department,
    String? priority,
    String model = _defaultModel,
  }) async {
    try {
      final prompt = _createWritingPrompt(
        userInput: userInput,
        concernType: concernType,
        department: department,
        priority: priority,
      );

      final response = await _makeApiCall(prompt, model);
      
      if (response.isNotEmpty) {
        return _cleanResponse(response, userInput);
      }
      
      // Fallback to template-based suggestion
      return _generateFallbackSuggestion(userInput, concernType, department, priority);
      
    } catch (e) {
      debugPrint('OpenRouter API error: $e');
      return _generateFallbackSuggestion(userInput, concernType, department, priority);
    }
  }

  /// Create a writing improvement prompt
  String _createWritingPrompt({
    required String userInput,
    String? concernType,
    String? department,
    String? priority,
  }) {
    final buffer = StringBuffer();
    
    buffer.write('You are an AI writing assistant helping students improve their concern descriptions for a college administration system.\n\n');
    
    buffer.write('Original student input: "$userInput"\n\n');
    
    if (concernType != null) {
      buffer.write('Concern Type: $concernType\n');
    }
    if (department != null) {
      buffer.write('Department: $department\n');
    }
    if (priority != null) {
      buffer.write('Priority: $priority\n');
    }
    
    buffer.write('\nPlease rewrite this as a professional, clear, and respectful concern description that:\n');
    buffer.write('1. Maintains the original intent and key information\n');
    buffer.write('2. Uses appropriate academic language\n');
    buffer.write('3. Is specific and actionable\n');
    buffer.write('4. Shows respect for the institution\n');
    buffer.write('5. Includes relevant details if mentioned\n');
    buffer.write('6. Removes any inappropriate language\n');
    buffer.write('7. Is between 50-500 characters\n\n');
    buffer.write('Provide only the improved version without any explanations or prefixes:');
    
    return buffer.toString();
  }

  /// Make API call to OpenRouter
  Future<String> _makeApiCall(String prompt, String model) async {
    // Check if API key is configured
    if (!AiConfig.isApiKeyConfigured) {
      debugPrint('OpenRouter API key not configured. Using fallback suggestions.');
      return '';
    }

    final headers = AiConfig.getApiHeaders();

    final payload = {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful AI writing assistant that improves student concern descriptions to be professional and clear.'
        },
        {
          'role': 'user',
          'content': prompt
        }
      ],
      'temperature': AiConfig.temperature,
      'max_tokens': AiConfig.maxTokens,
      'top_p': AiConfig.topP,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['choices'] != null && 
          data['choices'].isNotEmpty && 
          data['choices'][0]['message'] != null) {
        return data['choices'][0]['message']['content'] ?? '';
      }
    } else {
      debugPrint('OpenRouter API error: ${response.statusCode} - ${response.body}');
    }
    
    return '';
  }

  /// Clean and validate the AI response
  String _cleanResponse(String response, String originalInput) {
    String cleaned = response.trim();
    
    // Remove common AI response prefixes
    final prefixes = [
      'Improved version:',
      'Here is an improved version:',
      'Here\'s an improved version:',
      'The improved version is:',
      'Improved:',
      'Here\'s the improved version:',
      'Here is the improved version:',
    ];
    
    for (final prefix in prefixes) {
      if (cleaned.toLowerCase().startsWith(prefix.toLowerCase())) {
        cleaned = cleaned.substring(prefix.length).trim();
        break;
      }
    }
    
    // Remove quotes if the entire response is wrapped in them
    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    
    // Ensure the response is not too long (max 500 characters)
    if (cleaned.length > 500) {
      cleaned = cleaned.substring(0, 497) + '...';
    }
    
    // Ensure the response is not too short (min 30 characters)
    if (cleaned.length < 30) {
      return _generateFallbackSuggestion(originalInput);
    }
    
    return cleaned;
  }

  /// Generate fallback suggestion when API fails
  String _generateFallbackSuggestion(
    String userInput, [
    String? concernType,
    String? department,
    String? priority,
  ]) {
    if (userInput.trim().isEmpty) {
      return "I am writing to report a concern regarding [specific issue]. This matter has been affecting [who/what is affected] and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
    }
    
    // Clean the user input
    String cleanInput = _cleanUserInput(userInput);
    
    // Generate contextual template based on concern type
    String template = _getContextualTemplate(concernType, department, priority);
    
    // Replace placeholder with cleaned input
    if (template.contains('[USER_INPUT]')) {
      template = template.replaceAll('[USER_INPUT]', cleanInput);
    }
    
    return template;
  }

  /// Clean user input for template insertion
  String _cleanUserInput(String input) {
    String cleaned = input;
    
    // Remove inappropriate language
    final inappropriateWords = [
      'fuck', 'shit', 'damn', 'hell', 'crap', 'bitch', 'ass', 'bastard'
    ];
    
    for (final word in inappropriateWords) {
      cleaned = cleaned.replaceAll(RegExp(word, caseSensitive: false), '[inappropriate language]');
    }
    
    // Clean up informal language
    cleaned = cleaned
        .replaceAll(RegExp(r'\bpls\b', caseSensitive: false), 'please')
        .replaceAll(RegExp(r'\bthx\b', caseSensitive: false), 'thank you')
        .replaceAll(RegExp(r'\bu\b', caseSensitive: false), 'you')
        .replaceAll(RegExp(r'\bur\b', caseSensitive: false), 'your')
        .replaceAll(RegExp(r'\bhelp meee\b', caseSensitive: false), 'help me')
        .replaceAll(RegExp(r'\bbro\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    
    return cleaned.isEmpty ? 'the issue described above' : cleaned;
  }

  /// Get contextual template based on concern type
  String _getContextualTemplate(String? concernType, String? department, String? priority) {
    switch (concernType?.toLowerCase()) {
      case 'academic':
        return "I am writing to report an academic concern regarding [USER_INPUT]. This issue has been affecting my academic performance and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'faculty':
        return "I am writing to report a concern regarding [USER_INPUT]. This matter involves faculty interaction and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'facilities':
        return "I am writing to report a facilities-related concern regarding [USER_INPUT]. This issue has been affecting my ability to study/work effectively and I believe it requires attention from the facilities department. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'uniform':
        return "I am writing to report a concern regarding [USER_INPUT]. This matter relates to uniform policy and I believe it requires clarification or attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'library':
        return "I am writing to report a library-related concern regarding [USER_INPUT]. This issue has been affecting my ability to access resources and I believe it requires attention from the library staff. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'enrollment':
        return "I am writing to report an enrollment-related concern regarding [USER_INPUT]. This matter affects my academic progress and I believe it requires attention from the registrar's office. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'financial':
        return "I am writing to report a financial concern regarding [USER_INPUT]. This matter affects my ability to continue my education and I believe it requires attention from the financial aid office. I would appreciate your assistance in resolving this matter promptly.";
      
      case 'schedule':
        return "I am writing to report a scheduling concern regarding [USER_INPUT]. This issue has been affecting my academic schedule and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
      
      default:
        return "I am writing to report a concern regarding [USER_INPUT]. This matter requires attention and I would appreciate your assistance in resolving it promptly. Please let me know if you need any additional information.";
    }
  }

  /// Get available free models
  List<String> getAvailableModels() {
    return [
      _defaultModel,
      _fastModel,
      _creativeModel,
    ];
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final response = await _makeApiCall('Hello, this is a test message.', _defaultModel);
      return response.isNotEmpty;
    } catch (e) {
      debugPrint('OpenRouter connection test failed: $e');
      return false;
    }
  }
}
