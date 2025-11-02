// lib/feature/owner_dashboard/profile/view/widgets/owner_payment_details_widget.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../../../core/models/owner_payment_details_model.dart';
import '../../viewmodel/owner_payment_details_viewmodel.dart';

/// Widget for managing owner's payment details
/// Includes bank account, UPI, and QR code management
class OwnerPaymentDetailsWidget extends StatefulWidget {
  const OwnerPaymentDetailsWidget({super.key});

  @override
  State<OwnerPaymentDetailsWidget> createState() => _OwnerPaymentDetailsWidgetState();
}

class _OwnerPaymentDetailsWidgetState extends State<OwnerPaymentDetailsWidget> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Bank Details Controllers
  final _bankNameController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  
  // UPI Controllers
  final _upiIdController = TextEditingController();
  final _paymentNoteController = TextEditingController();
  
  // QR Code
  String? _qrCodeUrl;
  dynamic _newQrCodeFile;
  
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Defer initialization to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadPaymentDetails();
        }
      });
    }
  }

  Future<void> _loadPaymentDetails() async {
    final authProvider = context.read<AuthProvider>();
    final viewModel = context.read<OwnerPaymentDetailsViewModel>();
    final ownerId = authProvider.user?.userId ?? '';
    
    if (ownerId.isNotEmpty) {
      await viewModel.loadPaymentDetails(ownerId);
      if (mounted) {
        _populateFields();
      }
    }
  }

  void _populateFields() {
    final details = context.read<OwnerPaymentDetailsViewModel>().paymentDetails;
    if (details != null) {
      _bankNameController.text = details.bankName ?? '';
      _accountHolderController.text = details.accountHolderName ?? '';
      _accountNumberController.text = details.accountNumber ?? '';
      _ifscController.text = details.ifscCode ?? '';
      _upiIdController.text = details.upiId ?? '';
      _paymentNoteController.text = details.paymentNote ?? '';
      _qrCodeUrl = details.upiQrCodeUrl;
    }
  }

  Future<void> _savePaymentDetails() async {
    final authProvider = context.read<AuthProvider>();
    final viewModel = context.read<OwnerPaymentDetailsViewModel>();
    final ownerId = authProvider.user?.userId ?? '';
    
    if (ownerId.isEmpty) return;

    // Upload new QR code if selected
    String? qrCodeUrl = _qrCodeUrl;
    if (_newQrCodeFile != null) {
      final filename = 'qr_${DateTime.now().millisecondsSinceEpoch}.jpg';
      qrCodeUrl = await viewModel.uploadQrCode(ownerId, filename, _newQrCodeFile);
    }

    final details = OwnerPaymentDetailsModel(
      ownerId: ownerId,
      bankName: _bankNameController.text.trim().isEmpty ? null : _bankNameController.text.trim(),
      accountHolderName: _accountHolderController.text.trim().isEmpty ? null : _accountHolderController.text.trim(),
      accountNumber: _accountNumberController.text.trim().isEmpty ? null : _accountNumberController.text.trim(),
      ifscCode: _ifscController.text.trim().isEmpty ? null : _ifscController.text.trim(),
      upiId: _upiIdController.text.trim().isEmpty ? null : _upiIdController.text.trim(),
      upiQrCodeUrl: qrCodeUrl,
      paymentNote: _paymentNoteController.text.trim().isEmpty ? null : _paymentNoteController.text.trim(),
      isActive: true,
    );

    final success = await viewModel.savePaymentDetails(details);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment details saved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: ${viewModel.error ?? "Unknown error"}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _pickQrCode() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _newQrCodeFile = file;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _upiIdController.dispose();
    _paymentNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerPaymentDetailsViewModel>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (viewModel.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        children: [
          // Premium Header
          Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeadingMedium(
                      text: 'Payment Details',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    BodyText(
                      text: 'Configure how guests can pay you',
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.paddingL),
        
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.textOnPrimary,
            unselectedLabelColor: isDarkMode 
                ? AppColors.textTertiary
                : AppColors.textSecondary,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            ),
            tabs: const [
              Tab(icon: Icon(Icons.account_balance), text: 'Bank'),
              Tab(icon: Icon(Icons.payment), text: 'UPI'),
              Tab(icon: Icon(Icons.qr_code), text: 'QR Code'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.paddingL),
        
        // Tab Views
        SizedBox(
          height: 500, // Fixed height for tab content
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBankDetailsTab(isDarkMode),
              _buildUpiDetailsTab(isDarkMode),
              _buildQrCodeTab(isDarkMode),
            ],
          ),
        ),
        
        // Save Button
        const SizedBox(height: AppSpacing.paddingL),
        PrimaryButton(
          label: 'Save Payment Details',
          onPressed: viewModel.saving ? null : _savePaymentDetails,
          isLoading: viewModel.saving,
        ),
        const SizedBox(height: AppSpacing.paddingL),
      ],
    ),
  );
  }

  Widget _buildBankDetailsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingSmall(text: 'Bank Account Details'),
          const SizedBox(height: AppSpacing.paddingS),
          const BodyText(
            text: 'Add your bank account details for direct transfers',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          
          _buildTextField(
            controller: _bankNameController,
            label: 'Bank Name',
            hint: 'e.g., State Bank of India',
            icon: Icons.account_balance,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          _buildTextField(
            controller: _accountHolderController,
            label: 'Account Holder Name',
            hint: 'Name as per bank records',
            icon: Icons.person,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          _buildTextField(
            controller: _accountNumberController,
            label: 'Account Number',
            hint: 'Enter account number',
            icon: Icons.numbers,
            keyboardType: TextInputType.number,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          _buildTextField(
            controller: _ifscController,
            label: 'IFSC Code',
            hint: 'e.g., SBIN0001234',
            icon: Icons.code,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildUpiDetailsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingSmall(text: 'UPI Details'),
          const SizedBox(height: AppSpacing.paddingS),
          const BodyText(
            text: 'Add your UPI ID for instant payments',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          
          _buildTextField(
            controller: _upiIdController,
            label: 'UPI ID',
            hint: 'yourname@paytm',
            icon: Icons.account_circle,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          _buildTextField(
            controller: _paymentNoteController,
            label: 'Payment Instructions (Optional)',
            hint: 'Any special instructions for guests',
            icon: Icons.note,
            maxLines: 3,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingSmall(text: 'UPI QR Code'),
          const SizedBox(height: AppSpacing.paddingS),
          const BodyText(
            text: 'Upload your UPI QR code from any payment app',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          
          if (_newQrCodeFile != null || _qrCodeUrl != null) ...[
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                  child: _buildQrCodePreview(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.paddingL),
          ],
          
          Center(
            child: SecondaryButton(
              label: (_newQrCodeFile != null || _qrCodeUrl != null) 
                  ? 'Change QR Code' 
                  : 'Upload QR Code',
              icon: Icons.upload,
              onPressed: _pickQrCode,
            ),
          ),
          
          const SizedBox(height: AppSpacing.paddingL),
          
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: AppColors.infoContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: BodyText(
                    text: 'You can generate a QR code from any UPI app like PhonePe, Paytm, Google Pay, etc.',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodePreview() {
    if (_newQrCodeFile != null) {
      // Handle newly selected file (cross-platform)
      if (kIsWeb) {
        // Web: Use FutureBuilder to read bytes from XFile
        return FutureBuilder<List<int>>(
          future: (_newQrCodeFile as XFile).readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                Uint8List.fromList(snapshot.data!),
                fit: BoxFit.contain,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      } else {
        // Mobile: Use File
        return Image.file(
          File((_newQrCodeFile as XFile).path),
          fit: BoxFit.contain,
        );
      }
    } else if (_qrCodeUrl != null) {
      // Display existing URL from Firebase
      return Image.network(
        _qrCodeUrl!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.error, size: 48, color: AppColors.error),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: isDarkMode ? AppColors.textOnPrimary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode 
            ? AppColors.darkInputFill 
            : AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
    );
  }
}

