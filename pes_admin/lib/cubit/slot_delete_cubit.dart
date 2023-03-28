import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'slot_delete_state.dart';

class SlotDeleteCubit extends Cubit<SlotDeleteState> {
  final MainRepository mainRepo;
  List selectedSlots = [];

  SlotDeleteCubit({required this.mainRepo}) : super(SlotDeleteInitial());

  slotDeleteApplication(token) {
    emit(SlotDeleteLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(ApplicationNotSubmitted("No Internet"));
      else {
        mainRepo.slotDeleteApplication(token, selectedSlots).then((status) {
          if (status == "SlotDeleted")
            emit(ApplicationSubmitted());
          else
            emit(ApplicationNotSubmitted(status));
        });
      }
    });
  }

  void selectSlotDelete() {
    selectedSlots = [];
    emit(SlotSelectionActive());
  }
}
