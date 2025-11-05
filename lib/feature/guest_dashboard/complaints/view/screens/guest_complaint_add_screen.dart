// ============================================================================
// Guest Complaint Add Screen - Submit New Complaint
// ============================================================================
// Form for guests to submit complaints with photo attachments and theme toggle.
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/utils/validators/general_validators.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/guest_pg_selection_provider.dart';
import '../../data/models/guest_complaint_model.dart';
import '../../viewmodel/guest_complaint_viewmodel.dart';

/// Screen for guest users to submit new complaints with optional photo attachments
/// Uses AuthProvider for user authentication and GuestComplaintViewModel for business logic
/// Implements form validation and image upload functionality
class GuestComplaintAddScreen extends StatefulWidget {
  const GuestComplaintAddScreen({super.key});

  @override
  State<GuestComplaintAddScreen> createState() =>
      _GuestComplaintAddScreenState();
}

class _GuestComplaintAddScreenState extends State<GuestComplaintAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<File> _imageFiles = [];
  final List<String> _uploadedImageUrls = [];

  bool _isSubmitting = false;

  String? _subjectError;
  String? _descriptionError;

  /// Opens device image gallery to select complaint photos
  /// Handles image picker errors with user-friendly messages
  Future<void> _pickImage() async {
    try {
      final file = await ImagePickerHelper.pickImageFromGallery(imageQuality: 75);
      if (file != null && mounted) {
        setState(() {
          _imageFiles.add(file);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  /// Uploads all selected images to Cloud Storage sequentially
  /// Collects download URLs for attachment to complaint document
  Future<void> _uploadImages(String guestId, String complaintId) async {
    _uploadedImageUrls.clear();
    final complaintVM = context.read<GuestComplaintViewModel>();

    // Upload images one by one to avoid overwhelming the storage
    for (final file in _imageFiles) {
      final url = await complaintVM.uploadComplaintImage(
        guestId,
        complaintId,
        file,
      );
      _uploadedImageUrls.add(url);
    }
  }

  /// Validates form, uploads images, and submits complaint to Firestore
  /// Handles complete complaint submission workflow with error handling
  Future<void> _submitComplaint() async {
    // Validate form inputs
    // Local validation for shared inputs
    setState(() {
      _subjectError = GeneralValidators.validateRequired('Subject', _subjectController.text);
      _descriptionError = GeneralValidators.validateRequired('Description', _descriptionController.text);
    });
    if (_subjectError != null || _descriptionError != null) return;

    final authProvider = context.read<AuthProvider>();
    final guestId = authProvider.user?.userId ?? '';
    
    // Check user authentication
    if (guestId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Get PG ID from GuestPgSelectionProvider (guest's selected/booked PG)
    final pgSelectionProvider = context.read<GuestPgSelectionProvider>();
    final pgId = pgSelectionProvider.selectedPgId ?? 
                 pgSelectionProvider.selectedPg?.pgId ?? '';

    // Validate that guest has selected a PG
    if (pgId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a PG first to file a complaint'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Generate unique complaint ID using timestamp
      final complaintId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload images if any selected
      if (_imageFiles.isNotEmpty) {
        await _uploadImages(guestId, complaintId);
      }

      // Create complaint model with all collected data
      final complaint = GuestComplaintModel(
        complaintId: complaintId,
        guestId: guestId,
        pgId: pgId,
        ownerId: null, // Will be set when assigned to owner
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        complaintDate: DateTime.now(),
        status: 'Pending', // Initial status
        photos: _uploadedImageUrls,
      );

      // Submit complaint to Firestore
      // FIXED: BuildContext async gap warning
      // Flutter recommends: Store context-dependent values before async operations or check mounted after
      // Changed from: Using context.read() then await, then using context
      // Changed to: Store ViewModel and ScaffoldMessenger before async, check mounted after
      if (!mounted) return;
      final complaintVM = context.read<GuestComplaintViewModel>();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      await complaintVM.submitComplaint(complaint);

      // Check if widget is still mounted before using context
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );

      // Navigate back to complaints list using centralized NavigationService
      final navigationService = getIt<NavigationService>();
      navigationService.goBack();
    } catch (e) {
      // FIXED: Missing type annotation warning
      // Flutter recommends: Always annotate catch clause variables with explicit types
      // Changed from: catch (e) without type annotation
      // Changed to: catch (dynamic e) with explicit dynamic type annotation
      // Note: Using dynamic instead of Object to avoid naming conflict with type name
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =======================================================================
      // App Bar with Theme Toggle - Submit Complaint
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: 'Submit New Complaint',
        showThemeToggle: true,  // Theme toggle for comfortable form filling
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Complaint Subject Input (shared TextInput)
              TextInput(
                controller: _subjectController,
                label: 'Subject',
                hint: 'Brief description of your complaint',
                error: _subjectError,
                onChanged: (v) => setState(() {
                  _subjectError = GeneralValidators.validateRequired('Subject', v);
                }),
              ),
              const SizedBox(height: 16),

              // Complaint Description Input (shared TextInput)
              TextInput(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Detailed description of your complaint or request',
                maxLines: 5,
                error: _descriptionError,
                onChanged: (v) => setState(() {
                  _descriptionError = GeneralValidators.validateRequired('Description', v);
                }),
              ),
              const SizedBox(height: 16),

              // Image Attachment Section
              _buildImageAttachmentSection(),
              const SizedBox(height: 24),

              // Submit Button
              PrimaryButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                label: 'Submit Complaint',
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the image attachment section with preview and add button
  Widget _buildImageAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attach Photos (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // Display selected images with remove option
            ..._imageFiles.map((file) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Remove image button
                    GestureDetector(
                      onTap: () => setState(() => _imageFiles.remove(file)),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )),
            // Add image button
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_imageFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_imageFiles.length} image(s) selected',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
