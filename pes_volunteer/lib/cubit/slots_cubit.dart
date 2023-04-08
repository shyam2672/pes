import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/main.dart';

part 'slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  SlotsCubit({required this.mainRepo}) : super(SlotsInitial());
  List<Slot> slots = [], allSlots = [];

  final MainRepository mainRepo;

  loadVolunteerSlots(token) {
    if (slots.isEmpty) {
      print("Getting Slots from Server");
      emit(Loading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(LoadFailure("No Internet"));
        else {
          mainRepo.getSlots(token).then((SlotResponse slotResponse) {
            if (slotResponse.hasLoaded) {
              slots = slotResponse.slots;
              emit(Loaded());
            } else
              emit(LoadFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

  void loadAllSlots(String token) {
    if (allSlots.isEmpty) {
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

    void delstot(token, id) {
    print("ff");
    emit(Loading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(LoadFailure("No internet"));
      else {
        mainRepo.delMySlot(token, id).then((resp) {
          print(resp);
          if (resp == "Deleted") {
            print("fffff");
            emit(SlotDeleted());
          } else
            emit(SlotNotDeleted());
        });
      }
    });
  }
}
