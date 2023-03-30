import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/batches.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'batch_edit_state.dart';

class BatchEditCubit extends Cubit<BatchEditState> {
  final MainRepository mainRepo;
  Map batchData = {};

  BatchEditCubit({required this.mainRepo}) : super(BatchEditInitial());

  editBatch(Batch batch) {
    emit(BatchEditing(batch: batch));
    batchData['batch'] = batch.batch;
    batchData['syllabus'] = batch.syllabus;
    batchData['remarks'] = batch.remarks;
  }

  selectBatch() {
    if (state is BatchEditSelect) {
      emit(BatchEditUnselect());
    } else {
      emit(BatchEditSelect());
    }
  }

  submitEdits(token) {
    Batch batch = Batch.fromJson(batchData);
    emit(BatchEditSubmitting());
    // emit(BatchEdited());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool) {
        emit(BatchEditError(error: "No Internet"));
      } else {
        mainRepo.editExistingBatch(token, batch).then((response) {
          if (response == 'Submitted') {
            emit(BatchEdited());
          } else {
            emit(BatchEditError(error: response));
            Timer(Duration(seconds: 2), () => emit(BatchEditUnselect()));
          }
        });
      }
    });
  }
}
