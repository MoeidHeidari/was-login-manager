import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme_context.dart';
import '../aws_login_manager_bloc.dart';
import '../aws_login_manager_events.dart';
import 'package:provider/provider.dart';

class AddSSOProfileDialog extends StatefulWidget {
  final String? initialProfileName;
  final String? initialSsoStartUrl;
  final String? initialSsoRegion;
  final String? initialSsoAccountId;
  final String? initialSsoRoleName;
  final String? initialSsoRegistrationScopes;

  const AddSSOProfileDialog({
    Key? key,
    this.initialProfileName,
    this.initialSsoStartUrl,
    this.initialSsoRegion,
    this.initialSsoAccountId,
    this.initialSsoRoleName,
    this.initialSsoRegistrationScopes,
  }) : super(key: key);

  @override
  _AddSSOProfileDialogState createState() => _AddSSOProfileDialogState();
}

class _AddSSOProfileDialogState extends State<AddSSOProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _ssoStartUrlController = TextEditingController();
  final _ssoDefaultRegionController = TextEditingController();
  final _ssoRegionController = TextEditingController();
  final _ssoAccountIdController = TextEditingController();
  final _ssoRoleNameController = TextEditingController();
  final _ssoRegistrationScopesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileNameController.text = widget.initialProfileName ?? '';
    _ssoStartUrlController.text = widget.initialSsoStartUrl ?? '';
    _ssoRegionController.text = widget.initialSsoRegion ?? '';
    _ssoDefaultRegionController.text = widget.initialSsoRegion ?? '';
    _ssoAccountIdController.text = widget.initialSsoAccountId ?? '';
    _ssoRoleNameController.text = widget.initialSsoRoleName ?? '';
    _ssoRegistrationScopesController.text = widget.initialSsoRegistrationScopes ?? 'sso:account:access';
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _ssoStartUrlController.dispose();
    _ssoDefaultRegionController.dispose();
    _ssoRegionController.dispose();
    _ssoAccountIdController.dispose();
    _ssoRoleNameController.dispose();
    _ssoRegistrationScopesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.only(
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
              child: Column(
                children: [
                  // Profile Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _profileNameController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'Profile Name',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a profile name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSO Start URL Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoStartUrlController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'SSO Start URL',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid SSO Start URL';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSO Region Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoRegionController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'SSO Region',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an SSO Region';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _ssoDefaultRegionController.text = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Default Region Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoDefaultRegionController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'Default region',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid region';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSO Account ID Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoAccountIdController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'SSO Account ID',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an SSO Account ID';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSO Role Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoRoleNameController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'SSO Role Name',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an SSO Role Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSO Registration Scopes Field
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                          ? const Color.fromARGB(255, 243, 243, 243)
                          : const Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _ssoRegistrationScopesController,
                      style: TextStyle(color: Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'SSO Registration Scopes',
                        labelStyle: TextStyle(
                          color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 37, 37, 37)
                              : const Color.fromARGB(255, 84, 84, 84),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid SSO Registration Scopes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
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
                            color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final profileName = _profileNameController.text;
                            final ssoStartUrl = _ssoStartUrlController.text;
                            final region = _ssoDefaultRegionController.text;
                            final ssoRegion = _ssoRegionController.text;
                            final ssoAccountId = _ssoAccountIdController.text;
                            final ssoRoleName = _ssoRoleNameController.text;
                            final ssoRegistrationScopes = _ssoRegistrationScopesController.text;

                            final config = {
                              'sso_start_url': ssoStartUrl,
                              'region': region,
                              'sso_region': ssoRegion,
                              'sso_account_id': ssoAccountId,
                              'sso_role_name': ssoRoleName,
                              'sso_registration_scopes': ssoRegistrationScopes,
                            };

                            BlocProvider.of<AwsLoginManagerBloc>(context).add(
                              AddOrUpdateProfileEvent(profileName, config, true),
                            );

                            Navigator.of(context).pop();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          backgroundColor: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 251, 251, 251),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          widget.initialProfileName == null ? 'Add Profile' : 'Update Profile',
                          style: TextStyle(
                            color: Provider.of<Apothems>(context).currentTheme == AppTheme.light
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}