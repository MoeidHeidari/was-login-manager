abstract class AwsLoginManagerEvent {}

class LoadProfilesEvent extends AwsLoginManagerEvent {
  final bool isSSO; // New parameter to specify whether to load SSO profiles or credentials profiles

  LoadProfilesEvent({required this.isSSO});
}

class AddOrUpdateProfileEvent extends AwsLoginManagerEvent {
  final String profileName;
  final Map<String, String> config;
  final bool isSSO;

  AddOrUpdateProfileEvent(this.profileName, this.config, this.isSSO);
}

class LoginWithSSOEvent extends AwsLoginManagerEvent {
  final String profile;
  final Map<String, Map<String, String>> profiles;

  LoginWithSSOEvent(this.profile,this.profiles);
}

class DeleteProfileEvent extends AwsLoginManagerEvent {
  final String profile;
  final bool isSSO;

  DeleteProfileEvent(this.profile, this.isSSO);
}

