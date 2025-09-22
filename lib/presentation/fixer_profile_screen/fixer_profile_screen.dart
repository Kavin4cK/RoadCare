import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/availability_widget.dart';
import './widgets/claimed_issues_widget.dart';
import './widgets/contact_info_widget.dart';
import './widgets/payment_info_widget.dart';
import './widgets/portfolio_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/reviews_section_widget.dart';
import './widgets/skills_section_widget.dart';
import './widgets/statistics_cards_widget.dart';

class FixerProfileScreen extends StatefulWidget {
  const FixerProfileScreen({super.key});

  @override
  State<FixerProfileScreen> createState() => _FixerProfileScreenState();
}

class _FixerProfileScreenState extends State<FixerProfileScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _capturedImage;

  // Mock data for fixer profile
  final Map<String, dynamic> _fixerData = {
    "id": 1,
    "name": "Michael Rodriguez",
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "location": "Downtown District, Metro City",
    "isVerified": true,
    "rating": 4.8,
    "totalReviews": 127,
    "joinedDate": DateTime(2023, 3, 15),
  };

  final List<Map<String, dynamic>> _skills = [
    {
      "name": "Plumbing",
      "category": "Infrastructure",
      "proficiency": 0.9,
      "rating": 4.9,
      "icon": "plumbing",
    },
    {
      "name": "Electrical",
      "category": "Infrastructure",
      "proficiency": 0.85,
      "rating": 4.7,
      "icon": "electrical_services",
    },
    {
      "name": "Road Repair",
      "category": "Transportation",
      "proficiency": 0.8,
      "rating": 4.6,
      "icon": "construction",
    },
    {
      "name": "Cleaning",
      "category": "Environment",
      "proficiency": 0.95,
      "rating": 4.8,
      "icon": "cleaning_services",
    },
  ];

  final List<Map<String, dynamic>> _portfolioItems = [
    {
      "id": 1,
      "title": "Pothole Repair on Main Street",
      "category": "Road Repair",
      "beforeImage":
          "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "afterImage":
          "https://images.pexels.com/photos/1267338/pexels-photo-1267338.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "completedDate": DateTime(2024, 1, 15),
      "description":
          "Successfully repaired a large pothole that was causing traffic issues",
    },
    {
      "id": 2,
      "title": "Streetlight Installation",
      "category": "Electrical",
      "beforeImage":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "afterImage":
          "https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "completedDate": DateTime(2024, 1, 10),
      "description": "Installed new LED streetlight in residential area",
    },
    {
      "id": 3,
      "title": "Drain Cleaning Project",
      "category": "Cleaning",
      "beforeImage":
          "https://images.pexels.com/photos/2343465/pexels-photo-2343465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "afterImage":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "completedDate": DateTime(2024, 1, 5),
      "description": "Cleared blocked drainage system in community park",
    },
  ];

  final Map<String, dynamic> _statistics = {
    "totalFixes": 45,
    "rating": 4.8,
    "totalReviews": 127,
    "avgResponseTime": 2,
    "totalEarnings": 2850,
  };

  bool _isAvailable = true;
  Map<String, dynamic> _schedule = {
    "workingDays": ["monday", "tuesday", "wednesday", "thursday", "friday"],
    "startTime": "09:00",
    "endTime": "17:00",
  };

  final Map<String, dynamic> _contactInfo = {
    "phone": "+1 (555) 123-4567",
    "phoneVerified": true,
    "email": "michael.rodriguez@email.com",
    "emailVerified": true,
    "socialMedia": {
      "facebook": "@michael.rodriguez",
      "twitter": "@mike_fixes",
      "linkedin": "michael-rodriguez-fixer",
    },
  };

  final List<Map<String, dynamic>> _reviews = [
    {
      "id": 1,
      "reviewerName": "Sarah Johnson",
      "reviewerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 5.0,
      "comment":
          "Michael did an excellent job fixing the pothole near our house. Very professional and completed the work quickly.",
      "date": DateTime(2024, 1, 20),
      "photos": [
        "https://images.pexels.com/photos/1267338/pexels-photo-1267338.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      ],
    },
    {
      "id": 2,
      "reviewerName": "David Chen",
      "reviewerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4.5,
      "comment":
          "Great work on the streetlight installation. The area is much safer now at night.",
      "date": DateTime(2024, 1, 12),
      "photos": [],
    },
    {
      "id": 3,
      "reviewerName": "Maria Garcia",
      "reviewerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 5.0,
      "comment":
          "Very reliable and skilled fixer. Highly recommend for any infrastructure issues.",
      "date": DateTime(2024, 1, 8),
      "photos": [
        "https://images.pexels.com/photos/2343465/pexels-photo-2343465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      ],
    },
  ];

  final List<Map<String, dynamic>> _claimedIssues = [
    {
      "id": 1,
      "title": "Broken Water Pipe on Oak Street",
      "category": "Plumbing",
      "status": "in_progress",
      "priority": "high",
      "location": "Oak Street, Block 5",
      "deadline": DateTime.now().add(const Duration(days: 2)),
      "progress": 0.6,
      "image":
          "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Streetlight Maintenance",
      "category": "Electrical",
      "status": "claimed",
      "priority": "medium",
      "location": "Pine Avenue, Near Park",
      "deadline": DateTime.now().add(const Duration(days: 5)),
      "progress": 0.2,
      "image":
          "https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  final Map<String, dynamic> _paymentInfo = {
    "upiId": "michael.rodriguez@paytm",
    "upiVerified": true,
    "bankAccount": {
      "bankName": "Metro City Bank",
      "accountNumber": "1234567890",
      "routingNumber": "987654321",
    },
    "bankVerified": true,
    "totalEarnings": 2850.0,
    "pendingPayouts": 450.0,
    "thisMonthEarnings": 680.0,
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() => _capturedImage = photo);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _capturedImage = image);
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Profile Picture',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handlePortfolioItemTap(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String? ?? 'Project Details',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              if (item['beforeImage'] != null && item['afterImage'] != null)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Before'),
                          SizedBox(height: 1.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.w),
                            child: CustomImageWidget(
                              imageUrl: item['beforeImage'] as String,
                              width: double.infinity,
                              height: 30.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('After'),
                          SizedBox(height: 1.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.w),
                            child: CustomImageWidget(
                              imageUrl: item['afterImage'] as String,
                              width: double.infinity,
                              height: 30.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 2.h),
              Text(
                item['description'] as String? ?? 'No description available',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAvailabilityChanged(bool isAvailable) {
    setState(() {
      _isAvailable = isAvailable;
    });
  }

  void _handleScheduleChanged(Map<String, dynamic> schedule) {
    setState(() {
      _schedule = schedule;
    });
  }

  void _handleEditContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit contact functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleIssueItemTap(Map<String, dynamic> issue) {
    Navigator.pushNamed(context, '/issue-details-screen');
  }

  void _handleEditPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit payment functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(
              fixerData: _fixerData,
              onEditProfile: _handleEditProfile,
              onAvatarTap: _showImagePickerOptions,
            ),
            SkillsSectionWidget(skills: _skills),
            PortfolioSectionWidget(
              portfolioItems: _portfolioItems,
              onItemTap: _handlePortfolioItemTap,
            ),
            StatisticsCardsWidget(statistics: _statistics),
            AvailabilityWidget(
              isAvailable: _isAvailable,
              schedule: _schedule,
              onAvailabilityChanged: _handleAvailabilityChanged,
              onScheduleChanged: _handleScheduleChanged,
            ),
            ContactInfoWidget(
              contactInfo: _contactInfo,
              onEditContact: _handleEditContact,
            ),
            ReviewsSectionWidget(
              reviews: _reviews,
              averageRating: _fixerData['rating'] as double? ?? 0.0,
              totalReviews: _fixerData['totalReviews'] as int? ?? 0,
            ),
            ClaimedIssuesWidget(
              claimedIssues: _claimedIssues,
              onIssueTap: _handleIssueItemTap,
            ),
            PaymentInfoWidget(
              paymentInfo: _paymentInfo,
              onEditPayment: _handleEditPayment,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
