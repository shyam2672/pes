import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/batches.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'all_batches_state.dart';

class AllBatchesCubit extends Cubit<AllBatchesState> {
  AllBatchesCubit({required this.mainRepo}) : super(AllBatchesInitial());
  List<Batch>  allBatches = [];

  final MainRepository mainRepo;
  
  void loadAllBatches(String token) {
    if (allBatches.isEmpty) {
      emit(AllBatchesLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(AllBatchesLoadFailure("No Internet"));
        else {
          mainRepo.getAllBatches(token).then((BatchResponse batchResponse) {
            print("ran function");
            if (batchResponse.hasLoaded) {
              allBatches = batchResponse.batches;
              print(allBatches);
              emit(AllBatchesLoaded());
            } else
              emit(AllBatchesLoadFailure("Can't Load Batches"));
          });
        }
      });
    }
  }
}
