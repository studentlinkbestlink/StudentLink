import 'openrouter_service.dart';
import 'package:flutter/foundation.dart';

/// Enhanced AI Writing Service for concern descriptions
/// Provides contextual, personalized suggestions based on input analysis
class AiWritingService {
  static final AiWritingService _instance = AiWritingService._internal();
  factory AiWritingService() => _instance;
  AiWritingService._internal();

  final OpenRouterService _openRouterService = OpenRouterService();

  /// Generate contextual writing suggestions for concern descriptions
  Future<String> generateConcernSuggestion({
    required String userInput,
    String? concernType,
    String? department,
    String? priority,
  }) async {
    try {
      // Use OpenRouter service for AI-enhanced suggestions
      final aiSuggestion = await _openRouterService.generateWritingSuggestion(
        userInput: userInput,
        concernType: concernType,
        department: department,
        priority: priority,
      );
      
      if (aiSuggestion.isNotEmpty) {
        return aiSuggestion;
      }
      
      // Fallback to contextual template-based suggestions
      final analysis = _analyzeConcernInput(userInput);
      return _generateContextualSuggestion(
        userInput: userInput,
        analysis: analysis,
        concernType: concernType,
        department: department,
        priority: priority,
      );
      
    } catch (e) {
      debugPrint('Error generating AI suggestion: $e');
      return _generateFallbackSuggestion(userInput);
    }
  }

  /// Analyze user input to extract key information
  Map<String, dynamic> _analyzeConcernInput(String input) {
    final text = input.toLowerCase().trim();
    final words = text.split(RegExp(r'\s+'));
    
    return {
      'wordCount': words.length,
      'hasUrgency': _hasUrgencyKeywords(text),
      'hasEmotionalLanguage': _hasEmotionalLanguage(text),
      'hasSpecificDetails': _hasSpecificDetails(text),
      'hasInappropriateContent': _hasInappropriateContent(text),
      'concernCategory': _identifyConcernCategory(text),
      'tone': _identifyTone(text),
      'needsFormalization': _needsFormalization(text),
    };
  }

  /// Check for urgency keywords
  bool _hasUrgencyKeywords(String text) {
    final urgencyKeywords = [
      'urgent', 'asap', 'immediately', 'emergency', 'critical', 'important',
      'help', 'pls', 'please', 'quickly', 'fast', 'now', 'today'
    ];
    return urgencyKeywords.any((keyword) => text.contains(keyword));
  }

  /// Check for emotional language
  bool _hasEmotionalLanguage(String text) {
    final emotionalKeywords = [
      'frustrated', 'angry', 'upset', 'worried', 'concerned', 'disappointed',
      'fuck', 'shit', 'damn', 'hell', 'crap', 'terrible', 'awful', 'horrible'
    ];
    return emotionalKeywords.any((keyword) => text.contains(keyword));
  }

  /// Check for specific details
  bool _hasSpecificDetails(String text) {
    final detailIndicators = [
      'date', 'time', 'location', 'room', 'building', 'class', 'teacher',
      'professor', 'student', 'name', 'number', 'id', 'grade', 'assignment'
    ];
    return detailIndicators.any((indicator) => text.contains(indicator));
  }

  /// Check for inappropriate content
  bool _hasInappropriateContent(String text) {
    final inappropriateWords = [
      'fuck', 'shit', 'damn', 'hell', 'crap', 'bitch', 'ass', 'bastard'
    ];
    return inappropriateWords.any((word) => text.contains(word));
  }

  /// Identify concern category
  String _identifyConcernCategory(String text) {
    if (text.contains('grade') || text.contains('score') || text.contains('mark')) {
      return 'academic';
    } else if (text.contains('teacher') || text.contains('professor') || text.contains('instructor')) {
      return 'faculty';
    } else if (text.contains('facility') || text.contains('room') || text.contains('building')) {
      return 'facilities';
    } else if (text.contains('uniform') || text.contains('dress') || text.contains('clothing')) {
      return 'uniform';
    } else if (text.contains('library') || text.contains('book') || text.contains('study')) {
      return 'library';
    } else if (text.contains('enrollment') || text.contains('registration') || text.contains('admission')) {
      return 'enrollment';
    } else if (text.contains('financial') || text.contains('payment') || text.contains('fee')) {
      return 'financial';
    } else if (text.contains('schedule') || text.contains('time') || text.contains('class')) {
      return 'schedule';
    }
    return 'general';
  }

  /// Identify tone of the message
  String _identifyTone(String text) {
    if (_hasEmotionalLanguage(text)) {
      return 'emotional';
    } else if (_hasUrgencyKeywords(text)) {
      return 'urgent';
    } else if (text.length < 20) {
      return 'brief';
    } else if (text.length > 100) {
      return 'detailed';
    }
    return 'neutral';
  }

  /// Check if text needs formalization
  bool _needsFormalization(String text) {
    return _hasEmotionalLanguage(text) || 
           _hasInappropriateContent(text) || 
           text.length < 30 ||
           !text.contains('.') ||
           text.contains('pls') ||
           text.contains('thx') ||
           text.contains('u ') ||
           text.contains('ur ');
  }

  /// Generate contextual suggestion based on analysis
  String _generateContextualSuggestion({
    required String userInput,
    required Map<String, dynamic> analysis,
    String? concernType,
    String? department,
    String? priority,
  }) {
    final category = analysis['concernCategory'] as String;
    final tone = analysis['tone'] as String;
    final hasUrgency = analysis['hasUrgency'] as bool;
    
    // Extract key information from user input
    final keyInfo = _extractKeyInformation(userInput);
    
    // Generate base template based on category
    String baseTemplate = _getBaseTemplate(category, concernType, department);
    
    // Customize based on tone and urgency
    if (hasUrgency && tone == 'urgent') {
      baseTemplate = _addUrgencyToTemplate(baseTemplate);
    }
    
    // Add specific details if available
    if (keyInfo.isNotEmpty) {
      baseTemplate = _addSpecificDetails(baseTemplate, keyInfo);
    }
    
    // Replace placeholder with user input if needed
    if (baseTemplate.contains('[USER_INPUT]')) {
      final cleanInput = _cleanUserInput(userInput);
      baseTemplate = baseTemplate.replaceAll('[USER_INPUT]', cleanInput);
    }
    
    return baseTemplate;
  }

  /// Extract key information from user input
  Map<String, String> _extractKeyInformation(String input) {
    final info = <String, String>{};
    final text = input.toLowerCase();
    
    // Extract potential names (capitalized words)
    final namePattern = RegExp(r'\b[A-Z][a-z]+\b');
    final names = namePattern.allMatches(input).map((m) => m.group(0)!).toList();
    if (names.isNotEmpty) {
      info['names'] = names.join(', ');
    }
    
    // Extract potential dates
    final datePattern = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b|\b\d{1,2}\s+(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\w*\s+\d{2,4}\b');
    final dates = datePattern.allMatches(input).map((m) => m.group(0)!).toList();
    if (dates.isNotEmpty) {
      info['dates'] = dates.join(', ');
    }
    
    // Extract potential times
    final timePattern = RegExp(r'\b\d{1,2}:\d{2}\s*(am|pm)?\b');
    final times = timePattern.allMatches(input).map((m) => m.group(0)!).toList();
    if (times.isNotEmpty) {
      info['times'] = times.join(', ');
    }
    
    // Extract potential locations
    final locationKeywords = ['room', 'building', 'class', 'lab', 'office', 'library'];
    for (final keyword in locationKeywords) {
      if (text.contains(keyword)) {
        final index = text.indexOf(keyword);
        final context = input.substring(max(0, index - 20), min(input.length, index + 30));
        info['location'] = context.trim();
        break;
      }
    }
    
    return info;
  }

  /// Get base template for different concern categories
  String _getBaseTemplate(String category, String? concernType, String? department) {
    switch (category) {
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

  /// Add urgency to template
  String _addUrgencyToTemplate(String template) {
    return template.replaceAll(
      'I would appreciate your assistance in resolving this matter promptly.',
      'I would appreciate your urgent assistance in resolving this matter as soon as possible.'
    );
  }

  /// Add specific details to template
  String _addSpecificDetails(String template, Map<String, String> details) {
    final buffer = StringBuffer(template);
    
    if (details.containsKey('dates')) {
      buffer.write(' The incident occurred on ${details['dates']}.');
    }
    
    if (details.containsKey('times')) {
      buffer.write(' The time was ${details['times']}.');
    }
    
    if (details.containsKey('location')) {
      buffer.write(' The location was ${details['location']}.');
    }
    
    if (details.containsKey('names')) {
      buffer.write(' The individuals involved were ${details['names']}.');
    }
    
    return buffer.toString();
  }

  /// Clean user input for template insertion
  String _cleanUserInput(String input) {
    // Remove inappropriate language
    String cleaned = input;
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

  /// Generate fallback suggestion
  String _generateFallbackSuggestion(String userInput) {
    if (userInput.trim().isEmpty) {
      return "I am writing to report a concern regarding [specific issue]. This matter has been affecting [who/what is affected] and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly.";
    }
    
    final cleanInput = _cleanUserInput(userInput);
    return "I am writing to report a concern regarding $cleanInput. This matter requires attention and I would appreciate your assistance in resolving it promptly. Please let me know if you need any additional information.";
  }

  /// Helper function for min/max
  int min(int a, int b) => a < b ? a : b;
  int max(int a, int b) => a > b ? a : b;
}
