import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(String comment) onAddComment;

  const CommentsSectionWidget({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'comment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Community Discussion',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.comments.length}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildCommentInput(),
          SizedBox(height: 2.h),
          _buildCommentsList(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: _submitComment,
            icon: CustomIconWidget(
              iconName: 'send',
              color: _commentController.text.trim().isNotEmpty
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (widget.comments.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No comments yet',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Be the first to share your thoughts!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final displayComments =
        _isExpanded ? widget.comments : widget.comments.take(3).toList();

    return Column(
      children: [
        ...displayComments
            .map((comment) => _buildCommentItem(comment))
            .toList(),
        if (widget.comments.length > 3) ...[
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded
                  ? 'Show less comments'
                  : 'Show ${widget.comments.length - 3} more comments',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 5.w,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            child: CustomImageWidget(
              imageUrl: comment["userAvatar"] as String,
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment["userName"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatCommentTime(comment["timestamp"] as DateTime),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  comment["content"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    _buildCommentAction(
                      icon: 'thumb_up_outlined',
                      label: '${comment["likes"] as int}',
                      onTap: () => _likeComment(comment["id"] as int),
                    ),
                    SizedBox(width: 4.w),
                    _buildCommentAction(
                      icon: 'reply',
                      label: 'Reply',
                      onTap: () => _replyToComment(comment["id"] as int),
                    ),
                    SizedBox(width: 4.w),
                    _buildCommentAction(
                      icon: 'flag_outlined',
                      label: 'Report',
                      onTap: () => _reportComment(comment["id"] as int),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCommentTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      widget.onAddComment(comment);
      _commentController.clear();
      _commentFocusNode.unfocus();
    }
  }

  void _likeComment(int commentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment liked!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _replyToComment(int commentId) {
    _commentFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reply to comment'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _reportComment(int commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Comment'),
        content: Text(
            'Are you sure you want to report this comment as inappropriate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Comment reported successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }
}
