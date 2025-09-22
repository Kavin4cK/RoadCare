import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const ReviewsSectionWidget({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'rate_review',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Reviews & Feedback',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildRatingOverview(),
          SizedBox(height: 3.h),
          reviews.isEmpty ? _buildEmptyReviews() : _buildReviewsList(),
        ],
      ),
    );
  }

  Widget _buildRatingOverview() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.warningLight,
                    size: 8.w,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '$totalReviews reviews',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, 45),
                _buildRatingBar(4, 32),
                _buildRatingBar(3, 15),
                _buildRatingBar(2, 6),
                _buildRatingBar(1, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            '$stars',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(width: 1.w),
          CustomIconWidget(
            iconName: 'star',
            color: AppTheme.warningLight,
            size: 3.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.warningLight),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            '$percentage%',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'rate_review',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No reviews yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete your first fix to receive community feedback',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      children:
          reviews.take(3).map((review) => _buildReviewCard(review)).toList(),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final String reviewerName =
        review['reviewerName'] as String? ?? 'Anonymous';
    final String reviewerAvatar = review['reviewerAvatar'] as String? ?? '';
    final double rating = (review['rating'] as num?)?.toDouble() ?? 0.0;
    final String comment = review['comment'] as String? ?? '';
    final DateTime? reviewDate = review['date'] as DateTime?;
    final List<String> photos =
        (review['photos'] as List?)?.cast<String>() ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: reviewerAvatar.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: reviewerAvatar,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < rating.floor()
                                  ? 'star'
                                  : 'star_border',
                              color: AppTheme.warningLight,
                              size: 4.w,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        if (reviewDate != null)
                          Text(
                            '${reviewDate.day}/${reviewDate.month}/${reviewDate.year}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              comment,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (photos.isNotEmpty) ...[
            SizedBox(height: 2.h),
            SizedBox(
              height: 20.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length > 3 ? 3 : photos.length,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (context, index) {
                  if (index == 2 && photos.length > 3) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2.w),
                          child: CustomImageWidget(
                            imageUrl: photos[index],
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Center(
                            child: Text(
                              '+${photos.length - 2}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2.w),
                    child: CustomImageWidget(
                      imageUrl: photos[index],
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
