import 'dart:io';
import 'package:aws_client/sso_2019_06_10.dart' as sso;
import 'package:aws_client/sso_admin_2020_07_20.dart';
import 'package:aws_client/sso_oidc_2019_06_10.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/aws_login_manager_repository.dart';
import 'package:aws_client/sts_2011_06_15.dart' as sts;
import 'local_storage_datasource.dart';

class AwsLoginManagerRepositoryImpl implements AwsLoginManagerRepository {
  final LocalStorageDataSource _dataSource;

  AwsLoginManagerRepositoryImpl(this._dataSource);

  @override
  Future<Map<String, Map<String, String>>> getProfiles() async {
    return await _dataSource.readProfiles();
  }

  @override
  Future<void> addOrUpdateProfile(String profile, Map<String, String> config) async {
    final existingProfiles = await _dataSource.readProfiles();
    existingProfiles[profile] = config;
    await _dataSource.writeProfiles(existingProfiles, false);
  }

  @override
  Future<void> addOrUpdateSSOProfile(String profile, Map<String, String> config) async {
    final existingProfiles = await _dataSource.readSSOProfiles();
    existingProfiles[profile] = config;
    await _dataSource.writeProfiles(existingProfiles, true);
  }

  @override
  Future<bool> initiateSSOLogin(String profile) async {
    try {
      final ssoProfiles = await _dataSource.readSSOProfiles();
      final ssoConfig = ssoProfiles[profile];

      if (ssoConfig == null) {
        print('SSO profile not found: $profile');
        return false;
      }

      final ssoRegion = ssoConfig['sso_region'];
      final ssoStartUrl = ssoConfig['sso_start_url'];
      final ssoAccountId = ssoConfig['sso_account_id'];
      final ssoRoleName = ssoConfig['sso_role_name'];

      if (ssoRegion == null || ssoStartUrl == null || ssoAccountId == null || ssoRoleName == null) {
        print('Invalid SSO configuration for profile: $profile');
        return false;
      }
      final ssoAccessToken = await _getSSOToken(ssoStartUrl, ssoRegion);

      if (ssoAccessToken == null) {
        print('Failed to retrieve SSO access token');
        return false;
      }
      final ssoClient = sso.Sso(region: ssoRegion);

      final roleCredentials = await ssoClient.getRoleCredentials(
        accountId: ssoAccountId,
        roleName: ssoRoleName,
        accessToken: ssoAccessToken,
      );

      if (roleCredentials.roleCredentials == null) {
        print('Failed to retrieve role credentials');
        return false;
      }

      final credentials = AwsClientCredentials(
        accessKey: roleCredentials.roleCredentials!.accessKeyId ?? '',
        secretKey: roleCredentials.roleCredentials!.secretAccessKey ?? '',
        sessionToken: roleCredentials.roleCredentials!.sessionToken ?? '',
      );

      final stsClient = sts.Sts(region: ssoRegion, credentials: credentials);
      final identity = await stsClient.getCallerIdentity();

      print('Successfully logged in to AWS SSO with profile: $profile');
      print('Account: ${identity.account}');
      print('User ARN: ${identity.arn}');

      return true;
    } catch (e) {
      print('Error during SSO login process: $e');
      return false;
    }
  }

Future<String?> _getSSOToken(String ssoStartUrl, String ssoRegion) async {
  try {
    final ssoOidc = SsoOidc(region: ssoRegion);
    final registerResponse = await ssoOidc.registerClient(
      clientName: 'my-flutter-app',
      clientType: 'public',
    );

    final clientId = registerResponse.clientId;
    final clientSecret = registerResponse.clientSecret;
    final authResponse = await ssoOidc.startDeviceAuthorization(
      clientId: clientId!,
      clientSecret: clientSecret!,
      startUrl: ssoStartUrl,
    );

    final verificationUrl = authResponse.verificationUriComplete;

    if (verificationUrl != null && await canLaunchUrl(Uri.parse(verificationUrl))) {
      await launchUrl(Uri.parse(verificationUrl), mode: LaunchMode.externalApplication);
      print('Opening verification URL: $verificationUrl');
    } else {
      print('Cannot launch URL: $verificationUrl');
      return null;
    }

    while (true) {
      await Future.delayed(Duration(seconds: authResponse.interval ?? 5));

      try {
        final tokenResponse = await ssoOidc.createToken(
          clientId: clientId,
          clientSecret: clientSecret,
          deviceCode: authResponse.deviceCode!,
          grantType: 'urn:ietf:params:oauth:grant-type:device_code',
        );

        return tokenResponse.accessToken;
      } catch (e) {
        if (e.toString().contains('AuthorizationPendingException')) {
          continue;
        } else {
          print('Error during token retrieval: $e');
          return null;
        }
      }
    }
  } catch (e) {
    print('SSO token retrieval error: $e');
    return null;
  }
}

  @override
  Future<Map<String, Map<String, String>>> getSSOProfiles() async {
    final profiles = await _dataSource.readSSOProfiles();
    return profiles;
  }

  @override
  Future<bool> deleteProfile(String profileName, bool isSSO) async {
    return await _dataSource.deleteProfile(profileName, isSSO);
  }
}