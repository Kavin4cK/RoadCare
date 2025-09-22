import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/supabase_service.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/before_after_comparison_widget.dart';
import './widgets/comments_section_widget.dart';
import './widgets/community_voting_widget.dart';
import './widgets/issue_image_gallery_widget.dart';
import './widgets/issue_metadata_widget.dart';
import './widgets/status_timeline_widget.dart';

class IssueDetailsScreen extends StatefulWidget {
  const IssueDetailsScreen({super.key});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  Map<String, dynamic>? _issue;
  List<dynamic> _comments = [];
  Map<String, dynamic> _votes = {'upvotes': 0, 'downvotes': 0, 'total': 0};
  bool _isLoading = true;
  String? _issueId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIssueData();
    });
  }

  void _loadIssueData() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map<String, dynamic>) {
      _issueId = arguments['issueId'] as String?;
      if (_issueId != null) {
        _fetchIssueDetails();
      }
    }
  }

  Future<void> _fetchIssueDetails() async {
    if (_issueId == null) return;

    setState(() => _isLoading = true);

    try {
      // Fetch issue details
      final issueResponse =
          await SupabaseService.instance.client.from('issues').select('''
            *,
            reporter:user_profiles!reporter_id(*),
            assigned_worker:user_profiles!assigned_worker_id(*)
          ''').eq('id', _issueId!).single();

      // Fetch comments
      final comments =
          await SupabaseService.instance.getIssueComments(_issueId!);

      // Fetch votes
      final votes = await SupabaseService.instance.getIssueVotes(_issueId!);

      if (mounted) {
        setState(() {
          _issue = issueResponse;
          _comments = comments;
          _votes = votes;
          _isLoading = false;
        });
      }

      // Subscribe to real-time updates
      SupabaseService.instance.subscribeToIssueUpdates(_issueId!, (payload) {
        if (mounted) {
          _fetchIssueDetails(); // Refresh data on updates
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar(
            'Failed to load issue details: ${error.toString()}', Colors.red);
      }
    }
  }

  Future<void> _onCommentAdded(String comment) async {
    if (_issueId == null) return;

    try {
      await SupabaseService.instance.addComment(
        issueId: _issueId!,
        comment: comment,
      );

      // Refresh comments
      final comments =
          await SupabaseService.instance.getIssueComments(_issueId!);
      if (mounted) {
        setState(() => _comments = comments);
      }
    } catch (error) {
      _showSnackBar('Failed to add comment: ${error.toString()}', Colors.red);
    }
  }

  Future<void> _onVote(String voteType) async {
    if (_issueId == null) return;

    try {
      await SupabaseService.instance.voteOnIssue(
        issueId: _issueId!,
        voteType: voteType,
      );

      // Refresh votes
      final votes = await SupabaseService.instance.getIssueVotes(_issueId!);
      if (mounted) {
        setState(() => _votes = votes);
      }
    } catch (error) {
      _showSnackBar('Failed to vote: ${error.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Issue Details',
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_issue == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Issue Details',
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: const Center(
          child: Text('Issue not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Issue Details',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Issue Header
              Container(
                padding: EdgeInsets.all(4.w),
                color: theme.colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _issue!['title'] ?? 'Untitled Issue',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _issue!['description'] ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Issue Metadata
              IssueMetadataWidget(issueData: _issue!),

              // Image Gallery
              if (_issue!['before_image_url'] != null ||
                  _issue!['after_image_url'] != null)
                IssueImageGalleryWidget(
                  images: [
                    if (_issue!['before_image_url'] != null) _issue!['before_image_url'],
                    if (_issue!['after_image_url'] != null) _issue!['after_image_url']
                  ],
                  heroTag: 'issue_images',
                ),

              // Before/After Comparison
              if (_issue!['before_image_url'] != null &&
                  _issue!['after_image_url'] != null)
                BeforeAfterComparisonWidget(
                  beforeImage: _issue!['before_image_url'],
                  afterImage: _issue!['after_image_url'],
                ),

              // Community Voting
              CommunityVotingWidget(
                initialVoteCount: _votes['upvotes'] ?? 0,
                initialUserVoted: false,
                onVoteChanged: (voted) => _onVote(voted ? 'upvote' : 'downvote'),
              ),

              // Status Timeline
              StatusTimelineWidget(
                currentStatus: _issue!['status'] ?? 'reported',
                statusHistory: [],
              ),

              // Action Buttons
              ActionButtonsWidget(
                issueStatus: _issue!['status'] ?? 'reported',
                isUserFixer: false,
                isIssueClaimed: false,
                onClaimIssue: () {},
                onUpdateStatus: () {},
                onEscalateToAuthorities: () {},
              ),

              // Comments Section
              CommentsSectionWidget(
                comments: _comments.map((comment) => comment as Map<String, dynamic>).toList(),
                onAddComment: _onCommentAdded,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}