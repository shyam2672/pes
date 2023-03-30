import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'volunteer_slots_state.dart';

class VolunteerSlotsCubit extends Cubit<VolunteerSlotsState> {
  final MainRepository mainRepository;
  VolunteerSlotsCubit({required this.mainRepository}) : super(VolunteerSlotsInitial());
  List<Slot> allSlots=[];
  List current=[],requested=[];

  void individualSlots(String token,String pes_id){
    //emit(VolunteerSlotsInitial());
    if(allSlots.isEmpty){
      emit(VolunteerSlotsLoading());
      mainRepository.hasNetwork().then((Bool) {
        if (!Bool)
          emit(VolunteerSlotsLoadFailed(error: "No Internet"));
        else {
          mainRepository.individualSlots(token,pes_id).then((response) {
            if (response[0]==true) {
              allSlots = response[1];
              current = response[2];
              requested = response[3];
              emit(VolunteerSlotsLoaded());
            } else{
              print("xyz");
              emit(VolunteerSlotsLoadFailed(error: "Can't Load Slots"));
            }
          });
        }
      }
      );

    }
  }
}
