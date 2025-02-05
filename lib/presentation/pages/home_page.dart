import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_button/flutter_toggle_button.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../../core/theme_context.dart';
import '../aws_login_manager_bloc.dart';
import '../aws_login_manager_events.dart';
import '../aws_login_manager_states.dart';
import '../widgets/add_profile_dialog.dart';
import '../widgets/add_sso_profile_dialog.dart';
import '../widgets/login_item_wigdet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSSO = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<Apothems>(context).currentTheme;

    return BlocListener<AwsLoginManagerBloc, AwsLoginManagerState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful for profile: ${state.profile}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: null,
        backgroundColor: theme == AppTheme.dark
            ? Colors.black
            : const Color.fromARGB(255, 224, 224, 224),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                    child: _buildWindowButton(Icons.close, Colors.red, () {
                      SystemNavigator.pop();
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 100.0),
                    child: Text(
                      'AWS Login Manager',
                      style: TextStyle(
                        color: theme == AppTheme.light
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: FlutterToggleButton(
                        items: const ['Credentials', 'SSO'],
                        onTap: (index) {
                          setState(() {
                            isSSO = index == 1;
                          });
                          BlocProvider.of<AwsLoginManagerBloc>(context).add(
                            LoadProfilesEvent(isSSO: isSSO),
                          );
                        },
                        buttonWidth: 90,
                        buttonHeight: 35,
                        borderRadius: 25,
                        outerContainerColor:
                            Provider.of<Apothems>(context).currentTheme ==
                                    AppTheme.light
                                ? const Color.fromARGB(255, 236, 236, 236)
                                : const Color.fromARGB(255, 26, 26, 26),
                        outerContainerBorderWidth: 1,
                        outerContainerBorderColor:
                            Provider.of<Apothems>(context).currentTheme ==
                                    AppTheme.light
                                ? const Color.fromARGB(255, 199, 199, 199)
                                : const Color.fromARGB(255, 37, 37, 37),
                        buttonTextFontSize: 20,
                        enableTextColor:
                            Provider.of<Apothems>(context).currentTheme ==
                                    AppTheme.light
                                ? Colors.white
                                : Colors.black,
                        outerContainerMargin: 2,
                        disableTextColor:
                            Provider.of<Apothems>(context).currentTheme ==
                                    AppTheme.light
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255),
                        buttonGradient: LinearGradient(
                          colors: [
                            theme == AppTheme.light
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255),
                            theme == AppTheme.light
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 25.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profiles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Provider.of<Apothems>(context).currentTheme ==
                                        AppTheme.light
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.showBottomSheet(
                              (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    color: theme == AppTheme.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isSSO
                                            ? 'Add SSO Profile'
                                            : 'Add Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: theme == AppTheme.light
                                              ? const Color.fromARGB(
                                                  255, 0, 0, 0)
                                              : const Color.fromARGB(
                                                  255, 255, 255, 255),
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      isSSO
                                          ? const AddSSOProfileDialog()
                                          : const AddProfileDialog(),
                                    ],
                                  ),
                                );
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                            );
                          },
                          child: const Text(
                            'Add+',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                        height: 600,
                        child: BlocBuilder<AwsLoginManagerBloc,
                            AwsLoginManagerState>(
                          builder: (context, state) {
                            if (state is AwsLoginManagerLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is AwsLoginManagerLoadedState) {
                              final profiles = state.profiles;

                              if (profiles.isEmpty) {
                                return const Center(
                                    child: Text('No profiles found.'));
                              }

                              final profileList = profiles.keys.toList();
                              return ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
                                itemCount: profileList.length,
                                itemBuilder: (context, index) {
                                  final profile = profileList[index];
                                  final settings = profiles[profile]!;

                                  return LoginItem(
                                      profile: profile,
                                      settings: settings,
                                      type: isSSO ? 'sso' : 'credentials',
                                      onConnect: () {
                                        BlocProvider.of<AwsLoginManagerBloc>(
                                                context)
                                            .add(LoginWithSSOEvent(
                                                profile, profiles));
                                      },
                                      onEdit: () {
                                        _scaffoldKey.currentState
                                            ?.showBottomSheet(
                                          (context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(20)),
                                                color: theme == AppTheme.dark
                                                    ? const Color.fromARGB(255, 0, 0, 0)
                                                    : Colors.white,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    isSSO
                                                        ? 'Edit SSO Profile'
                                                        : 'Edit Profile',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Provider.of<Apothems>(
                                                                context,
                                                                listen: false)
                                                            .currentTheme ==
                                                        AppTheme.dark
                                                    ? const Color.fromARGB(255, 255, 255, 255)
                                                    : const Color.fromARGB(255, 3, 3, 3),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  isSSO
                                                      ? AddSSOProfileDialog(
                                                        initialProfileName: profile,
                                                        initialSsoRegion: settings['sso_region'],
                                                        initialSsoStartUrl: settings['sso_start_url'],
                                                        initialSsoAccountId: settings['sso_account_id'],
                                                        initialSsoRoleName: settings['sso_role_name'],
                                                        )
                                                      : AddProfileDialog(
                                                        initialProfileName: profile,
                                                        initialAccessKey: settings['aws_access_key_id'],
                                                        initialSecretKey: settings['aws_secret_access_key'],
                                                        ),
                                                ],
                                              ),
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                        );
                                      });
                                },
                              );
                            } else if (state is LoginSuccess) {
                              // Optional: You can show a success message or update UI on successful login
                              return const Center(
                                  child: Text('Login Successful!'));
                            } else if (state is LoginFailure) {
                              return Center(child: Text(state.message));
                            }
                            return const Center(child: Text('Loggin in...'));
                          },
                        )),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppTheme theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 60,
            color: theme == AppTheme.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<AwsLoginManagerBloc, AwsLoginManagerState>(
                  builder: (context, state) {
                    int profileCount = 0;
                    if (state is AwsLoginManagerLoadedState) {
                      profileCount = state.profiles.length;
                    }
                    return Text(
                      'Profiles: $profileCount',
                      style: TextStyle(
                        color: theme == AppTheme.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    theme == AppTheme.dark
                        ? Icons.wb_sunny
                        : Icons.nightlight_round,
                    color: theme == AppTheme.dark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Provider.of<Apothems>(context, listen: false).toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWindowButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Icon(icon, size: 12, color: Colors.white),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {});
  }
}
