import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'add_slot_state.dart';

class AddSlotCubit extends Cubit<AddSlotState> {
  final MainRepository mainRepository;
  Map applicationData = {};

  AddSlotCubit({required this.mainRepository})
      : super(AddSlotInitial());

  submitApplication(String token) {
    emit(AddSlotLoading());
    mainRepository.hasNetwork().then((Bool) {
      if (!Bool)
        emit(AddSlotError("No Internet"));
      else {
        mainRepository.addSlot(applicationData, token).then((response) {
          if (response == 'Submitted') {
            emit(ApplicationSubmitted());
          } else {
            emit(AddSlotError(response));
            Timer(Duration(seconds: 2), () => emit(ApplicationData()));
          }
        });
      }
    });
  }
}
