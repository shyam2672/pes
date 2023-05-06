import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/outreachslot.dart';
import 'package:pes/data/models/school.dart';
import 'package:pes/data/models/topic.dart';


import 'package:pes/data/repositories/main_server_repository.dart';

part 'outreach_slots_state.dart';

class OutreachCubit extends Cubit<OutreachState> {
  OutreachCubit({required this.mainRepo}) : super(OutreachInitial());
  List<outreachSlot> slots = [];
  List<String> schools = [];
  List<String> topics = [];

  


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

 void loadoutreachschools(String token) {
    print(schools);
    if (schools.isEmpty) {
      emit(OutreachLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(OutreachFailure("No Internet"));
        else {
          mainRepo.getoutreachSchools(token).then((List resp) {
            if (resp[0] == true) {
              schools = resp[1];
              emit(OutreachLoaded());
            } else
              emit(OutreachFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

   void loadoutreachtopics(String token) {
    print(topics);
    if (topics.isEmpty) {
      emit(OutreachLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(OutreachFailure("No Internet"));
        else {
          mainRepo.getoutreachTopics(token).then((List resp) {
            if (resp[0] == true) {
              topics = resp[1];
              emit(OutreachLoaded());
            } else
              emit(OutreachFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

  
  addOutreach(token,school,topic,description,date,timestart,timeend,remarks ) {
    emit(AddOutreachApplying());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(OutreachFailure("No Internet"));
      else {
        mainRepo.addoutreach(token,school,topic,description,date,timestart,timeend,remarks).then((status) {
          if (status == "Added successfully")
            emit(AddOutreachApplied());
          else
            emit(OutreachFailure(status));
        });
      }
    });
  }

  // void rejectoutreach(token, id) {
  //   print("ff");
  //   emit(OutreachLoading());
  //   mainRepo.hasNetwork().then((Bool) {
  //     if (!Bool)
  //       emit(OutreachFailure('No internet'));
  //     else {
  //       mainRepo.rejectoutreachslot(token, id).then((resp) {
  //         print(resp);
  //         if (resp == "Rejected") {
  //           print("fffff");
  //           emit(OutreachRejected());
  //         } else
  //           emit(OutreachNotRejected());
  //       });
  //     }
  //   });
  // }

  // void acceptoutreach(token, id) {
  //   print("ff");
  //   emit(OutreachLoading());
  //   mainRepo.hasNetwork().then((Bool) {
  //     if (!Bool)
  //       emit(OutreachFailure('No internet'));
  //     else {
  //       mainRepo.acceptoutreachslot(token, id).then((resp) {
  //         print("dsgdfhg hfghgh");
  //         print(resp);
  //         if (resp == "Accepted") {
  //           print("fffff");
  //           emit(OutreachAccepted());
  //         } else
  //           emit(OutreachNotAccepted());
  //       });
  //     }
  //   });
  // }
}
