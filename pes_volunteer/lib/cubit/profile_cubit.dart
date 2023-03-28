import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

import '../data/models/user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final MainRepository mainRepository;

  ProfileCubit({required this.mainRepository}) : super(ProfileInitial());

  loadVolunteerProfile(token) {
    emit(ProfileLoading());

    mainRepository.hasNetwork().then(
      (Bool) {
        if (!Bool) {
          emit(LoadError("No Internet"));
          Timer(Duration(seconds: 3), () {
            emit(ProfileInitial());
          });
        } else {
          mainRepository.getProfile(token).then((UserProfile userProfile) {
            emit(ProfileLoaded(userProfile));
          });
        }
      },
    );
  }
}
