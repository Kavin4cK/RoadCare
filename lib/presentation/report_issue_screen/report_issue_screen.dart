import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/supabase_service.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/issue_category_selector_widget.dart';
import './widgets/location_display_widget.dart';
import './widgets/priority_selector_widget.dart';
import './widgets/upload_progress_widget.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'pothole';
  String _selectedPriority = 'medium';
  double? _latitude;
  double? _longitude;
  String? _address;
  String? _capturedImagePath;
  bool _isSubmitting = false;
  bool _isLocationLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
  }

  void _onPriorityChanged(String priority) {
    setState(() => _selectedPriority = priority);
  }

  void _onLocationUpdate(double? lat, double? lng, String? addr) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _address = addr;
    });
  }

  void _onLocationLoadingChanged(bool loading) {
    setState(() => _isLocationLoading = loading);
  }

  void _onImageCaptured(String? imagePath) {
    setState(() => _capturedImagePath = imagePath);
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if user is authenticated
    if (!SupabaseService.instance.isAuthenticated) {
      _showSnackBar('Please login to report an issue', Colors.red);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/authentication-screen',
        (route) => false,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;

      // Upload image if captured
      if (_capturedImagePath != null) {
        final imageFile = kIsWeb
            ? null // Handle web file differently
            : await _getFileBytes(_capturedImagePath!);

        if (imageFile != null) {
          final fileName = 'issue_${DateTime.now().millisecondsSinceEpoch}.jpg';
          imageUrl = await SupabaseService.instance.uploadImage(
            bucketName: 'issue-images',
            filePath: fileName,
            fileBytes: imageFile,
            contentType: 'image/jpeg',
          );
        }
      }

      // Create issue
      await SupabaseService.instance.createIssue(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        latitude: _latitude,
        longitude: _longitude,
        address: _address,
        beforeImageUrl: imageUrl,
      );

      if (!mounted) return;

      _showSnackBar('Issue reported successfully!', Colors.green);

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = 'pothole';
        _selectedPriority = 'medium';
        _capturedImagePath = null;
        _latitude = null;
        _longitude = null;
        _address = null;
      });
    } catch (error) {
      if (mounted) {
        _showSnackBar(
            'Failed to report issue: ${error.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<List<int>?> _getFileBytes(String filePath) async {
    // This is a simplified implementation
    // In a real app, you'd read the actual file bytes
    return null;
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Report Issue',
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
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Issue Title
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Issue Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Brief description of the issue',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Issue Description
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              'Provide detailed information about the issue',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Category Selection
                IssueCategorySelectorWidget(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategoryChanged,
                ),

                SizedBox(height: 4.h),

                // Priority Selection
                PrioritySelectorWidget(
                  selectedPriority: _selectedPriority,
                  onPrioritySelected: _onPriorityChanged,
                ),

                SizedBox(height: 4.h),

                // Location
                LocationDisplayWidget(
                  latitude: _latitude,
                  longitude: _longitude,
                  onEditLocation: () {
                    // Handle edit location functionality
                  },
                ),

                SizedBox(height: 4.h),

                // Camera Section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Photo Evidence',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CameraControlsWidget(
                        onCapture: () {
                          // Handle capture functionality
                        },
                        onGallery: () {
                          // Handle gallery functionality
                        },
                        onFlipCamera: () {
                          // Handle flip camera functionality
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                // Submit Button
                SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: (_isSubmitting || _isLocationLoading)
                        ? null
                        : _submitReport,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            'Submit Report',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 2.h),

                if (_isLocationLoading) const UploadProgressWidget(
                  progress: 0.5,
                  status: 'Getting location...',
                  isVisible: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}