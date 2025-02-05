import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalStorageDataSource {
  Future<Directory> _getAwsDirectory() async {
    if (Platform.isMacOS) {
      final homeDir = Platform.environment['HOME'];
      if (homeDir == null) {
        throw Exception('Home directory not found!');
      }
      return Directory(path.join(homeDir, '.aws'));
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return Directory(path.join(directory.path, '.aws'));
    }
  }

  Future<Map<String, Map<String, String>>> readSSOProfiles() async {
    final awsDir = await _getAwsDirectory();
    final configFile = File('${awsDir.path}/config');
    if (!await configFile.exists()) {
      return {};
    }

    final lines = await configFile.readAsLines();
    final profiles = <String, Map<String, String>>{};
    String? currentProfile;
    for (var line in lines) {
      if (line.startsWith('[profile') && line.endsWith(']')) {
        currentProfile = line.substring(8, line.length - 1).trim(); // Profile name after "profile"
        profiles[currentProfile] = {};
      } else if (currentProfile != null && line.contains('=')) {
        final parts = line.split('=');
        profiles[currentProfile]![parts[0].trim()] = parts[1].trim();
      }
    }
    return profiles;
  }

  Future<Map<String, Map<String, String>>> readProfiles() async {
    final awsDir = await _getAwsDirectory();
    final configFile = File('${awsDir.path}/credentials');
    if (!await configFile.exists()) {
      return {};
    }

    final lines = await configFile.readAsLines();
    final profiles = <String, Map<String, String>>{};
    String? currentProfile;
    for (var line in lines) {
      if (line.startsWith('[profile') && line.endsWith(']')) {
        currentProfile = line.substring(8, line.length - 1).trim(); // Profile name after "profile"
        profiles[currentProfile] = {};
      } else if (currentProfile != null && line.contains('=')) {
        final parts = line.split('=');
        profiles[currentProfile]![parts[0].trim()] = parts[1].trim();
      }
    }
    return profiles;
  }

  Future<void> writeProfiles(Map<String, Map<String, String>> profiles, bool isSSO) async {
    final awsDir = await _getAwsDirectory();
    final configFile = isSSO ? File('${awsDir.path}/config') : File('${awsDir.path}/credentials');
    if (!await awsDir.exists()) {
      await awsDir.create();
    }

    final buffer = StringBuffer();
    profiles.forEach((profile, settings) {
      buffer.writeln('[profile $profile]');
      settings.forEach((key, value) {
        buffer.writeln('$key=$value');
      });
      buffer.writeln();
    });
    await configFile.writeAsString(buffer.toString().trim());
  }

  Future<bool> deleteProfile(String profileName, bool isSSO) async {
  try {
    final awsDir = await _getAwsDirectory();
    final configFile = isSSO
        ? File('${awsDir.path}/config')
        : File('${awsDir.path}/credentials');

    if (!await configFile.exists()) {
      throw Exception('File does not exist!');
    }

    // Read existing profiles
    final profiles = isSSO ? await readSSOProfiles() : await readProfiles();

    // Remove the specified profile
    if (profiles.containsKey(profileName)) {
      profiles.remove(profileName);
    } else {
      throw Exception('Profile not found!');
    }

    // Write the updated profiles back to the file
    final buffer = StringBuffer();
    profiles.forEach((profile, settings) {
      buffer.writeln('[profile $profile]');
      settings.forEach((key, value) {
        buffer.writeln('$key=$value');
      });
      buffer.writeln();
    });

    await configFile.writeAsString(buffer.toString().trim());

    return true; // Profile deleted successfully
  } catch (e) {
    return false; // If there's any error, return false
  }
}

}