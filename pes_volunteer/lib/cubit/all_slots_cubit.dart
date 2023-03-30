import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/main.dart';


part 'all_slots_state.dart';

class AllSlotsCubit extends Cubit<AllSlotsState> {
  AllSlotsCubit({required this.mainRepo}) : super(AllSlotsInitial());
  List<Slot> slots = [], allSlots = [];

  final MainRepository mainRepo;

  loadVolunteerSlots(token) {
    if (slots.isEmpty) {
      print("Getting Slots from Server");
      emit(AllLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(AllLoadFailure("No Internet"));
        else {
          mainRepo.getSlots(token).then((SlotResponse slotResponse) {
            if (slotResponse.hasLoaded) {
              slots = slotResponse.slots;
              emit(AllLoaded());
            } else
              emit(AllLoadFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

  void loadAllSlots(String token) {
    if (allSlots.isEmpty) {
      emit(AllLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(AllLoadFailure("No Internet"));
        else {
          mainRepo.getAllSlots(token).then((SlotResponse slotResponse) {
            if (slotResponse.hasLoaded) {
              allSlots = slotResponse.slots;
              emit(AllLoaded());
            } else
              emit(AllLoadFailure("Can't Load Slots"));
          });
        }
      });
    }
  }
}
