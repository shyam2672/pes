import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'add_batch_state.dart';

class AddBatchCubit extends Cubit<AddBatchState> {
  final MainRepository mainRepository;
  Map applicationData = {};

  AddBatchCubit({required this.mainRepository})
      : super(AddBatchInitial());

  submitApplication(String token) {
    emit(AddBatchLoading());
    mainRepository.hasNetwork().then((Bool) {
      if (!Bool)
        emit(AddBatchError("No Internet"));
      else {
        mainRepository.addBatch(applicationData, token).then((response) {
          if (response == 'Submitted') {
            emit(ApplicationSubmitted());
          } else {
            emit(AddBatchError(response));
            Timer(Duration(seconds: 2), () => emit(ApplicationData()));
          }
        });
      }
    });
  }
}
