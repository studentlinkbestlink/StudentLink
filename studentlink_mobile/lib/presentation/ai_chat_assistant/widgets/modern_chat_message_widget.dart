import 'package:flutter/material.dart';

import '../ai_chat_assistant.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../widgets/typewriter_text_widget.dart';
import '../../../theme/app_theme.dart';

/// Modern chat message widget with sleek, minimalistic design
class ModernChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(ChatMessage)? onMessageLongPress;

  const ModernChatMessageWidget({
    Key? key,
    required this.message,
    this.onMessageLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(vertical: 4, horizontal: 0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildModernAvatar(context),
            ResponsiveSpacing(height: 0, width: 12),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => onMessageLongPress?.call(message),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 280),
                padding: ResponsiveDesign.getPadding(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: message.isUser
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.15)
                          : Theme.of(context)
                              .shadowColor
                              .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.isTypewriter && !message.isUser
                        ? TypewriterTextWidget(
                            text: message.text,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: message.isUser
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                              height: 1.5,
                              fontSize: ResponsiveDesign.getFontSize(15),
                              fontWeight: FontWeight.w400,
                            ),
                            duration: const Duration(milliseconds: 50),
                            showCursor: true,
                          )
                        : Text(
                            message.text,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: message.isUser
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                              height: 1.5,
                              fontSize: ResponsiveDesign.getFontSize(15),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    ResponsiveSpacing(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: message.isUser
                                ? Colors.white.withValues(alpha: 0.7)
                                : Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color ??
                                    Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                            fontSize: ResponsiveDesign.getFontSize(11),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (message.isUser) ...[
                          ResponsiveSpacing(height: 0, width: 4),
                          Icon(
                            Icons.done_all_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: ResponsiveDesign.getIconSize(14),
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
            ResponsiveSpacing(height: 0, width: 12),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildModernAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        color: Colors.white,
        size: ResponsiveDesign.getIconSize(20),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: ResponsiveDesign.getIconSize(20),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
