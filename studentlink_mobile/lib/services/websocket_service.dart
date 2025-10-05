
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  bool _isConnected = false;
  PusherChannelsFlutter? _pusher;
  final Map<String, Function(Map<String, dynamic>)> _listeners = {};

  bool get isConnected => _isConnected;

  void connect() async {
    if (_isConnected) return;

    try {
      // Initialize Pusher with real configuration
      _pusher = PusherChannelsFlutter.getInstance();
      
      await _pusher!.init(
        apiKey: AppConfig.pusherAppKey,
        cluster: AppConfig.pusherCluster,
        onConnectionStateChange: (String currentState, String previousState) {
          debugPrint('Pusher connection state changed: $previousState -> $currentState');
          _isConnected = currentState == 'connected';
        },
        onError: (String message, int? code, dynamic e) {
          debugPrint('Pusher error: $message (Code: $code)');
          _isConnected = false;
        },
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          debugPrint('Successfully subscribed to channel: $channelName');
        },
        onSubscriptionError: (String message, dynamic e) {
          debugPrint('Subscription error: $message');
        },
        onEvent: (event) {
          debugPrint('Received event: ${event.eventName} on channel: ${event.channelName}');
          _handleEvent(event);
        },
      );

      await _pusher!.connect();
      _isConnected = true;
      debugPrint('✅ Pusher WebSocket service connected successfully');
    } catch (e) {
      debugPrint('❌ Failed to connect to Pusher WebSocket: $e');
      _isConnected = false;
    }
  }

  void disconnect() async {
    if (_pusher != null) {
      await _pusher!.disconnect();
    }
    _isConnected = false;
    _listeners.clear();
    debugPrint('WebSocket service disconnected');
  }

  void _handleEvent(PusherEvent event) {
    final channelName = event.channelName;
    final eventName = event.eventName;
    final data = event.data;

    debugPrint('🔍 Handling event: $eventName on channel: $channelName');
    debugPrint('🔍 Event data: $data');

    // Find the appropriate listener
    final listener = _listeners[channelName];
    if (listener != null) {
      try {
        // Parse the data and call the listener
        // For chat messages, the backend sends the message data directly
        final eventData = <String, dynamic>{
          'type': eventName,
          'channel': channelName,
          ...Map<String, dynamic>.from(data), // Spread the data directly instead of nesting under 'data'
        };
        listener(eventData);
      } catch (e) {
        debugPrint('❌ Error handling event: $e');
      }
    } else {
      debugPrint('⚠️ No listener found for channel: $channelName');
    }
  }

  void subscribeToConcerns(Function(Map<String, dynamic>) callback) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot subscribe to concerns');
      return;
    }

    _listeners['concerns'] = callback;
    _pusher!.subscribe(channelName: 'concerns');
    debugPrint('✅ Subscribed to concerns channel');
  }

  void subscribeToResolutionUpdates(Function(Map<String, dynamic>) callback) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot subscribe to resolution updates');
      return;
    }

    _listeners['resolution_updates'] = callback;
    _pusher!.subscribe(channelName: 'resolution_updates');
    debugPrint('✅ Subscribed to resolution updates channel');
  }

  void subscribeToDepartmentConcerns(int departmentId, Function(Map<String, dynamic>) callback) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot subscribe to department concerns');
      return;
    }

    final channelName = 'concerns.department.$departmentId';
    _listeners[channelName] = callback;
    _pusher!.subscribe(channelName: channelName);
    debugPrint('✅ Subscribed to department concerns channel: $channelName');
  }

  // Chat-specific methods
  void subscribeToChatRoom(int chatRoomId, Function(Map<String, dynamic>) callback) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot subscribe to chat room');
      return;
    }

    final channelName = 'chat.room.$chatRoomId';
    _listeners[channelName] = callback;
    _pusher!.subscribe(channelName: channelName);
    debugPrint('✅ Subscribed to chat room: $channelName');
  }

  void subscribeToUserChat(int userId, Function(Map<String, dynamic>) callback) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot subscribe to user chat');
      return;
    }

    final channelName = 'private-chat.user.$userId';
    _listeners[channelName] = callback;
    debugPrint('Subscribed to user chat: $channelName');
  }

  void sendTypingStatus(int chatRoomId, int userId, bool isTyping) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot send typing status');
      return;
    }

    final channelName = 'chat.room.$chatRoomId';
    final eventData = {
      'user_id': userId,
      'is_typing': isTyping,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    _pusher!.trigger(
      PusherEvent(
        channelName: channelName,
        eventName: 'typing_status',
        data: eventData,
      ),
    );

    debugPrint('✅ Sent typing status: User $userId is ${isTyping ? 'typing' : 'not typing'} in room $chatRoomId');
  }

  void sendMessage(int chatRoomId, String message, {String messageType = 'text', int? replyToId}) {
    if (_pusher == null || !_isConnected) {
      debugPrint('Pusher not connected, cannot send message');
      return;
    }

    final channelName = 'chat.room.$chatRoomId';
    final eventData = {
      'message': message,
      'message_type': messageType,
      'reply_to_id': replyToId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    _pusher!.trigger(
      PusherEvent(
        channelName: channelName,
        eventName: 'new_message',
        data: eventData,
      ),
    );

    debugPrint('✅ Sent message to room $chatRoomId: $message');
  }

  void unsubscribeFromChannel(String channelName) {
    if (_pusher != null && _isConnected) {
      _pusher!.unsubscribe(channelName: channelName);
    }
    _listeners.remove(channelName);
    debugPrint('✅ Unsubscribed from channel: $channelName');
  }

  void unsubscribeFromAllChannels() {
    if (_pusher != null && _isConnected) {
      for (final channelName in _listeners.keys) {
        _pusher!.unsubscribe(channelName: channelName);
      }
    }
    _listeners.clear();
    debugPrint('✅ Unsubscribed from all channels');
  }
}
