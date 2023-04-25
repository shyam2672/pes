import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/outreachslot.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'outreach_state.dart';

class OutreachCubit extends Cubit<OutreachState> {
  OutreachCubit({required this.mainRepo}) : super(OutreachInitial());
  List<outreachSlot> slots = [];

  final MainRepository mainRepo;

  void loadoutreachslots(String token) {
    print(slots);
    if (slots.isEmpty) {
      emit(OutreachLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(OutreachFailure("No Internet"));
        else {
          mainRepo.getoutreachSlots(token).then((List resp) {
            if (resp[0] == true) {
              slots = resp[1];
              emit(OutreachLoaded());
            } else
              emit(OutreachFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

  void rejectoutreach(token, id) {
    print("ff");
    emit(OutreachLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(OutreachFailure('No internet'));
      else {
        mainRepo.rejectoutreachslot(token, id).then((resp) {
          print(resp);
          if (resp == "Rejected") {
            print("fffff");
            emit(OutreachRejected());
          } else
            emit(OutreachNotRejected());
        });
      }
    });
  }

  void acceptoutreach(token, id) {
    print("ff");
    emit(OutreachLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(OutreachFailure('No internet'));
      else {
        mainRepo.acceptoutreachslot(token, id).then((resp) {
          print("dsgdfhg hfghgh");
          print(resp);
          if (resp == "Accepted") {
            print("fffff");
            emit(OutreachAccepted());
          } else
            emit(OutreachNotAccepted());
        });
      }
    });
  }
}
