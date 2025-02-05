abstract class AwsLoginManagerRepository {
  Future<Map<String, Map<String, String>>> getProfiles();
  Future<Map<String, Map<String, String>>> getSSOProfiles();
  Future<void> addOrUpdateProfile(String profile, Map<String, String> config);
  Future<bool> initiateSSOLogin(String profile);
  Future<void> addOrUpdateSSOProfile(String profile, Map<String, String> config);
  Future<bool> deleteProfile(String profileName, bool isSSO);
}
