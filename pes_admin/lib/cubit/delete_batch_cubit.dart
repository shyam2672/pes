import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'delete_batch_state.dart';

class BatchDeleteCubit extends Cubit<BatchDeleteState> {
  final MainRepository mainRepo;
  List selectedBatches = [];
  
  BatchDeleteCubit({required this.mainRepo}) : super(BatchDeleteInitial());

  batchDeleteApplication(token) {
    emit(BatchDeleteLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(BatchDelApplicationNotSubmitted("No Internet"));
      else {
        mainRepo.batchDeleteApplication(token, selectedBatches).then((status) {
          if (status == "Batch Deleted")
            emit(BatchDelApplicationSubmitted());
          else
            emit(BatchDelApplicationNotSubmitted(status));
        });
      }
    });
  }

  void selectBatchDelete() {
    selectedBatches = [];
    emit(BatchSelectionActive());
  }
}
