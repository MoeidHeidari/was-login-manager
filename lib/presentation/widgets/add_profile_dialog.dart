import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme_context.dart';
import '../aws_login_manager_bloc.dart';
import '../aws_login_manager_events.dart';
import 'package:provider/provider.dart';

class AddProfileDialog extends StatefulWidget {
  final String? initialProfileName;
  final String? initialAccessKey;
  final String? initialSecretKey;

  const AddProfileDialog({
    Key? key,
    this.initialProfileName,
    this.initialAccessKey,
    this.initialSecretKey,
  }) : super(key: key);

  @override
  _AddProfileDialogState createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<AddProfileDialog> {
  final _profileNameController = TextEditingController();
  final _accessKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  // Handle updates when the widget is rebuilt with new data
  @override
  void didUpdateWidget(covariant AddProfileDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialProfileName != oldWidget.initialProfileName ||
        widget.initialAccessKey != oldWidget.initialAccessKey ||
        widget.initialSecretKey != oldWidget.initialSecretKey) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    _profileNameController.text = widget.initialProfileName ?? '';
    _accessKeyController.text = widget.initialAccessKey ?? '';
    _secretKeyController.text = widget.initialSecretKey ?? '';
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final profileName = _profileNameController.text.trim();
      final accessKey = _accessKeyController.text.trim();
      final secretKey = _secretKeyController.text.trim();

      context.read<AwsLoginManagerBloc>().add(
        AddOrUpdateProfileEvent(
          profileName,
          {
            'aws_access_key_id': accessKey,
            'aws_secret_access_key': secretKey,
          },
          widget.initialProfileName != null, // true if updating
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Provider.of<Apothems>(context).currentTheme == AppTheme.light;
    final inputBackgroundColor = isLightTheme
        ? const Color(0xFFF3F3F3)
        : const Color(0xFF191919);
    final inputTextColor = isLightTheme
        ? const Color(0xFF252525)
        : const Color(0xFFCCCCCC);
    final buttonTextColor = isLightTheme
        ? Colors.black
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _profileNameController,
                      label: 'Profile Name',
                      validatorMessage: 'Please enter a profile name.',
                      inputBackgroundColor: inputBackgroundColor,
                      inputTextColor: inputTextColor,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _accessKeyController,
                      label: 'AWS Access Key',
                      validatorMessage: 'Please enter an AWS Access Key.',
                      inputBackgroundColor: inputBackgroundColor,
                      inputTextColor: inputTextColor,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _secretKeyController,
                      label: 'AWS Secret Key',
                      validatorMessage: 'Please enter an AWS Secret Key.',
                      inputBackgroundColor: inputBackgroundColor,
                      inputTextColor: inputTextColor,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(context, buttonTextColor, isLightTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
    required Color inputBackgroundColor,
    required Color inputTextColor,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: inputBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: inputTextColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: inputTextColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color buttonTextColor, bool isLightTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: buttonTextColor,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () => _saveProfile(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            backgroundColor: isLightTheme ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            widget.initialProfileName == null ? 'Add Profile' : 'Update Profile',
            style: TextStyle(
              color: isLightTheme ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
