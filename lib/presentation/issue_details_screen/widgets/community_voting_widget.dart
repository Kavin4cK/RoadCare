import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityVotingWidget extends StatefulWidget {
  final int initialVoteCount;
  final bool initialUserVoted;
  final Function(bool voted) onVoteChanged;

  const CommunityVotingWidget({
    super.key,
    required this.initialVoteCount,
    required this.initialUserVoted,
    required this.onVoteChanged,
  });

  @override
  State<CommunityVotingWidget> createState() => _CommunityVotingWidgetState();
}

class _CommunityVotingWidgetState extends State<CommunityVotingWidget>
    with SingleTickerProviderStateMixin {
  late int _voteCount;
  late bool _userVoted;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _voteCount = widget.initialVoteCount;
    _userVoted = widget.initialUserVoted;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                iconName: 'how_to_vote',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Community Support',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: GestureDetector(
                      onTap: _handleVote,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: _userVoted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: _userVoted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                          boxShadow: _userVoted
                              ? [
                                  BoxShadow(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: CustomIconWidget(
                          iconName:
                              _userVoted ? 'thumb_up' : 'thumb_up_outlined',
                          color: _userVoted
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_voteCount',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    _voteCount == 1 ? 'person supports' : 'people support',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Spacer(),
              _buildPriorityIndicator(),
            ],
          ),
          SizedBox(height: 2.h),
          _buildVotingProgress(),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    String priorityText;
    Color priorityColor;
    IconData priorityIcon;

    if (_voteCount >= 50) {
      priorityText = 'High Priority';
      priorityColor = AppTheme.lightTheme.colorScheme.error;
      priorityIcon = Icons.priority_high;
    } else if (_voteCount >= 20) {
      priorityText = 'Medium Priority';
      priorityColor = Colors.orange;
      priorityIcon = Icons.trending_up;
    } else {
      priorityText = 'Low Priority';
      priorityColor = AppTheme.lightTheme.colorScheme.secondary;
      priorityIcon = Icons.trending_flat;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priorityIcon,
            size: 16,
            color: priorityColor,
          ),
          SizedBox(width: 1.w),
          Text(
            priorityText,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: priorityColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingProgress() {
    final progress = (_voteCount / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress to escalation',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${(_voteCount / 100 * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
          minHeight: 6,
        ),
        SizedBox(height: 1.h),
        Text(
          _voteCount >= 100
              ? 'Issue escalated to authorities!'
              : '${100 - _voteCount} more votes needed for escalation',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: _voteCount >= 100
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: _voteCount >= 100 ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _handleVote() {
    setState(() {
      if (_userVoted) {
        _voteCount--;
        _userVoted = false;
      } else {
        _voteCount++;
        _userVoted = true;
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }
    });

    widget.onVoteChanged(_userVoted);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_userVoted ? 'Vote added!' : 'Vote removed!'),
        duration: Duration(seconds: 1),
        backgroundColor: _userVoted
            ? AppTheme.lightTheme.colorScheme.secondary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
