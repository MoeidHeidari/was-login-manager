import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../core/theme_context.dart';
import '../aws_login_manager_bloc.dart';
import '../aws_login_manager_events.dart';

class LoginItem extends StatefulWidget {
  final String profile;
  final Map<String, String> settings;
  final String type;
  final VoidCallback onConnect;
  final VoidCallback onEdit;

  const LoginItem({
    required this.profile,
    required this.settings,
    required this.type,
    required this.onConnect,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  _LoginItemState createState() => _LoginItemState();
}

class _LoginItemState extends State<LoginItem> {
  bool _isExpanded = false;
  bool _isSecretVisible = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleSecretVisibility() {
    setState(() {
      _isSecretVisible = !_isSecretVisible;
    });
  }

  void _copyToClipboard() {
    final awsAccessKeyId = widget.settings['aws_access_key_id'] ?? '';
    final awsSecretAccessKey = widget.settings['aws_secret_access_key'] ?? '';
    
    Clipboard.setData(ClipboardData(
      text: 'AWS_ACCESS_KEY_ID=$awsAccessKeyId\nAWS_SECRET_ACCESS_KEY=$awsSecretAccessKey',
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access Keys copied to clipboard!')),
    );
  }

  void _deleteProfile() {
    BlocProvider.of<AwsLoginManagerBloc>(context)
        .add(DeleteProfileEvent(widget.profile, widget.type == 'sso'));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.profile),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 16.0,
          top: 12.0,
          bottom: 12.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 234, 234, 234)
                          : const Color.fromARGB(255, 20, 20, 20),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.profile,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 255, 255, 255),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.type == 'credentials'
                                ? 'Access Key: ${widget.settings['aws_access_key_id']}'
                                : 'Region: ${widget.settings['sso_region']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 70, 70, 70)
                          : const Color.fromARGB(255, 151, 151, 151),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    if (widget.type == 'credentials')
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: _copyToClipboard,
                      ),
                    if (widget.type == 'credentials')
                    IconButton(
                      color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 54, 54, 54)
                          : const Color.fromARGB(255, 197, 197, 197),
                      icon: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      onPressed: _toggleExpansion,
                    ),
                    if (widget.type == 'credentials' || widget.type == 'sso')
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        onPressed: widget.onEdit, 
                      ),
                    if (widget.type == 'sso')
                      TextButton(
                        onPressed: widget.onConnect,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                if (_isExpanded && widget.type == 'credentials')
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _isSecretVisible
                                    ? 'Secret Key: ${widget.settings['aws_secret_access_key']}'
                                    : 'Secret Key: ${'•' * widget.settings['aws_secret_access_key']!.length}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 54, 54, 54)
                          : const Color.fromARGB(255, 153, 153, 153),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            IconButton(
                              color: Provider.of<Apothems>(context).currentTheme == AppTheme.light 
                          ? const Color.fromARGB(255, 54, 54, 54)
                          : const Color.fromARGB(255, 197, 197, 197),
                              iconSize: 20,
                              icon: Icon(
                                _isSecretVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _toggleSecretVisibility,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
