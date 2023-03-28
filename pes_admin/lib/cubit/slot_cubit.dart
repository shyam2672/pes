import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';


part 'slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  SlotCubit({required this.mainRepo}) : super(SlotInitial());
  List<Slot> slots = [], allSlots = [];

  final MainRepository mainRepo;

  void loadAllSlots(String token) {
    emit(Loading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(LoadFailure("No Internet"));
      else {
        mainRepo.getAllSlots(token).then((SlotResponse slotResponse) {
          if (slotResponse.hasLoaded) {
            allSlots = slotResponse.slots;
            emit(Loaded());
          } else
            emit(LoadFailure("Can't Load Slots"));
        });
      }
    });
  }
}
      
      
