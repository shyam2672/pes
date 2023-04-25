import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/school.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolState> {
  SchoolsCubit({required this.mainRepo}) : super(SchoolInitial());
  List<School> schools = [];

  final MainRepository mainRepo;

  void loadSchoolsslots(String token) {
    print(schools);
    if (schools.isEmpty) {
      emit(SchoolLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(SchoolsFailure("No Internet"));
        else {
          mainRepo.getSchools(token).then((List resp) {
            if (resp[0] == true) {
              schools = resp[1];
              emit(SchoolLoaded());
            } else
              emit(SchoolFailure("Can't Load Slots"));
          });
        }
      });
    }
  }

  // void rejectSchools(token, id) {
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
