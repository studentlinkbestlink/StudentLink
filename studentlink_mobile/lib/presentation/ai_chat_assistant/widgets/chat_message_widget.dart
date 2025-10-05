import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../ai_chat_assistant.dart';
import '../../../utils/responsive_design.dart';

/// Widget to display individual chat messages
class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(ChatMessage)? onMessageLongPress;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.onMessageLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(vertical: 0.3.h, horizontal: 3.w),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(),
            SizedBox(width: 1.5.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => onMessageLongPress?.call(message),
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: ResponsiveDesign.getPadding(horizontal: 3.5.w,
                  vertical: 1.8.h,
                ),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                          : Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: message.isUser
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.4,
                        fontSize: ResponsiveDesign.getFontSize(15),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: message.isUser
                                ? Colors.white.withValues(alpha: 0.7)
                                : Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: ResponsiveDesign.getFontSize(11).sp,
                          ),
                        ),
                        if (message.isUser) ...[
                          SizedBox(width: 1.w),
                          Icon(
                            Icons.done_all,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 3.5.w,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 2.w),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 7.w,
      height: 7.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2480EA),
            const Color(0xFF1E2A78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2480EA).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        color: Colors.white,
        size: 3.5.w,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 7.w,
      height: 7.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E2A78),
            const Color(0xFF1E2A78).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 3.5.w,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
