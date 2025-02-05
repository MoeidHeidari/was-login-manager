abstract class AwsLoginManagerState {}

class AwsLoginManagerInitialState extends AwsLoginManagerState {}

class AwsLoginManagerLoadingState extends AwsLoginManagerState {}

class AwsLoginManagerLoadedState extends AwsLoginManagerState {
  final Map<String, Map<String, String>> profiles;

  AwsLoginManagerLoadedState(this.profiles);
}

class AwsLoginManagerErrorState extends AwsLoginManagerState {
  final String error;

  AwsLoginManagerErrorState(this.error);
}

class LoginInProgress extends AwsLoginManagerState {
  final Map<String, Map<String, String>> profiles;

  LoginInProgress(this.profiles);
}

class LoginSuccess extends AwsLoginManagerState {
  final String profile;

  LoginSuccess(this.profile);
}

class LoginFailure extends AwsLoginManagerState {
  final String message;

  LoginFailure(this.message);
}

class DeleteProfileSuccess extends AwsLoginManagerState {}