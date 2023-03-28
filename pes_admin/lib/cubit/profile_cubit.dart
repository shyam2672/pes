import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final MainRepository mainRepository;

  ProfileCubit({required this.mainRepository}) : super(ProfileInitial());

  loadVolunteerProfile(token, pesId) {
    emit(ProfileLoading());

    mainRepository.hasNetwork().then(
      (Bool) {
        if (!Bool) {
          emit(LoadError("No Internet"));
          Timer(Duration(seconds: 3), () {
            emit(ProfileInitial());
          });
        } else {
          mainRepository
              .getVolunteerProfile(token, pesId)
              .then((volunteerProfile) {
            if (volunteerProfile != null)
              emit(ProfileLoaded(volunteerProfile));
            else {
              emit(LoadError('Couldn\'t Load Profile'));
            }
          });
        }
      },
    );
  }
}
