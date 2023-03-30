import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'slot_change_state.dart';

class SlotChangeCubit extends Cubit<SlotChangeState> {
  final MainRepository mainRepo;
  List selectedSlots = [];
  
  SlotChangeCubit({required this.mainRepo}) : super(SlotChangeInitial());

  slotChangeApplication(token) {
    emit(SlotChangeLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(ApplicationNotSubmitted("No Internet"));
      else {
        mainRepo.slotChangeApplication(token, selectedSlots).then((status) {
          if (status == "SlotChanged")
            emit(ApplicationSubmitted());
          else
            emit(ApplicationNotSubmitted(status));
        });
      }
    });
  }
}
