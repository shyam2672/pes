import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admin/datatransfer_v1.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/application.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final MainRepository mainRepository;
  Map applicationData = {};

  RegistrationCubit({required this.mainRepository})
      : super(RegistrationInitial());

  submitApplication(String token) {
    emit(RegistrationLoading());
    mainRepository.hasNetwork().then((Bool) {
      if (!Bool)
        emit(RegistrationError("No Internet"));
      else {
        mainRepository.register(applicationData, token).then((response) {
          if (response == 'Submitted') {
            emit(ApplicationSubmitted());
          } else {
            emit(RegistrationError(response));
            Timer(Duration(seconds: 2), () => emit(ApplicationData()));
          }
        });
      }
    });
  }
}
