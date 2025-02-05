import 'package:flutter_bloc/flutter_bloc.dart';
import 'aws_login_manager_events.dart';
import 'aws_login_manager_states.dart';
import '../domain/aws_login_manager_repository.dart';

class AwsLoginManagerBloc
    extends Bloc<AwsLoginManagerEvent, AwsLoginManagerState> {
  final AwsLoginManagerRepository _repository;

  AwsLoginManagerBloc(this._repository) : super(AwsLoginManagerInitialState()) {
    on<LoadProfilesEvent>(_onLoadProfiles);
    on<AddOrUpdateProfileEvent>(_onAddOrUpdateProfile);
    on<LoginWithSSOEvent>(_onLoginWithSSO);
    on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onLoadProfiles(
      LoadProfilesEvent event, Emitter<AwsLoginManagerState> emit) async {
    emit(AwsLoginManagerLoadingState());

    try {
      Map<String, Map<String, String>> profiles;

      if (event.isSSO) {
        // Load SSO profiles if the mode is SSO
        profiles = await _repository.getSSOProfiles();
      } else {
        // Load credentials profiles if the mode is credentials
        profiles = await _repository.getProfiles();
      }

      // Emit loaded state with profiles
      emit(AwsLoginManagerLoadedState(profiles));
    } catch (e) {
      emit(AwsLoginManagerErrorState(e.toString()));
    }
  }
  

  Future<void> _onAddOrUpdateProfile(
      AddOrUpdateProfileEvent event, Emitter<AwsLoginManagerState> emit) async {
    try {
      if (event.isSSO) {
        await _repository.addOrUpdateSSOProfile(
            event.profileName, event.config);
        // Reload profiles after adding/updating
        add(LoadProfilesEvent(isSSO: true)); // Reload profiles in SSO mode
      } else {
        await _repository.addOrUpdateProfile(event.profileName, event.config);
        // Reload profiles after adding/updating
        add(LoadProfilesEvent(
            isSSO: false)); // Reload profiles in credentials mode
      }
    } catch (e) {
      emit(AwsLoginManagerErrorState(e.toString()));
    }
  }

  Future<void> _onLoginWithSSO(
      LoginWithSSOEvent event, Emitter<AwsLoginManagerState> emit) async {
    // Emit login in progress state
    emit(LoginInProgress(event.profiles));

    try {
      bool loginSuccess = await _repository.initiateSSOLogin(event.profile);

      if (loginSuccess) {
        // After login success, keep profiles and show success
        add(LoadProfilesEvent(
            isSSO: true)); // Reload profiles to ensure they are shown correctly
        emit(LoginSuccess(event.profile)); // Emit login success
      } else {
        emit(LoginFailure(
            'Login failed for profile: ${event.profile}')); // Emit login failure
      }
    } catch (e) {
      emit(LoginFailure(
          'Error during login: ${e.toString()}')); // Handle login error
    }
  }

  Future<void> _onDeleteProfile(
      DeleteProfileEvent event, Emitter<AwsLoginManagerState> emit) async {
    try {
      bool result =
          await _repository.deleteProfile(event.profile, event.isSSO);

      if (result) {
        add(LoadProfilesEvent(isSSO: event.isSSO));
        emit(DeleteProfileSuccess());
      } else {
        emit(AwsLoginManagerErrorState('Failed to delete profile'));
      }
    } catch (e) {
      emit(
          AwsLoginManagerErrorState('Error deleting profile: ${e.toString()}'));
    }
  }
}
