import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/batches.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';


part 'batch_state.dart';

class BatchCubit extends Cubit<BatchState> {
  BatchCubit({required this.mainRepo}) : super(BatchInitial());
  List<Batch> batches = [], allBatches = [];

  final MainRepository mainRepo;

  void loadAllBatches(String token) {
    emit(Loading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(LoadFailure("No Internet"));
      else {
        mainRepo.getAllBatches(token).then((BatchResponse batchResponse) {
          if (batchResponse.hasLoaded) {
            allBatches = batchResponse.batches;
            emit(Loaded());
          } else
            emit(LoadFailure("Can't Load Batches"));
        });
      }
    });
  }
}
      
      
