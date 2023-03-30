import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'slot_edit_state.dart';

class SlotEditCubit extends Cubit<SlotEditState> {
  Map slotData = {};
  
  final MainRepository mainRepo;

  SlotEditCubit({required this.mainRepo}) : super(SlotEditInitial());

  editSlot(Slot slot) {
    emit(SlotEditing(slot: slot));
    slotData['slot_id'] = slot.slotId;
    slotData['day'] = slot.day;
    slotData['time_start'] = slot.timeStart;
    slotData['time_end'] = slot.timeEnd;
    slotData['pathshaala'] = slot.pathshaala;
    slotData['batch'] = slot.batch;
      }

  selectSlot() {
    if (state is SlotEditSelect) {
      emit(SlotEditUnselect());
    } else {
      emit(SlotEditSelect());
    }
  }

  submitEdits(token) {
    Slot slot = Slot.fromJson(slotData);
    emit(SlotEditSubmitting());
    // emit(SlotEdited());

    mainRepo.hasNetwork().then((Bool) {
      if (!Bool) {
        emit(SlotEditError(error: "No Internet"));
      } else {
        mainRepo.editExistingSlot(token, slot).then((response) {
          if (response == 'Submitted') {
            emit(SlotEdited());
          } else {
            emit(SlotEditError(error: response));
            Timer(Duration(seconds: 2), () => emit(SlotEditUnselect()));
          }
        });
      }
    });
  }
}
