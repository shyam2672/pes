import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/studentNeeds.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'studentNeeds_state.dart';

class StudentNeedsCubit extends Cubit<StudentNeedsState> {
  final MainRepository mainRepository;

  StudentNeedsCubit({required this.mainRepository})
      : super(StudentNeedsInitial());

  List<AppStudentNeeds> studentNeeds = [];

  getStudentNeeds(String token) {
    emit(StudentNeedsLoading());
    if (studentNeeds.isEmpty) {
      mainRepository.hasNetwork().then(
        (Bool) {
          if (!Bool) {
            emit(StudentNeedsError(error: "No Internet"));
            Timer(Duration(seconds: 3), () {
              emit(StudentNeedsInitial());
            });
          } else {
            mainRepository.getStudentNeeds(token).then((var response) {
              studentNeeds = response;
              emit(StudentNeedsLoaded());
            });
          }
        },
      );
    } else {
      emit(StudentNeedsLoaded());
    }
  }
}
