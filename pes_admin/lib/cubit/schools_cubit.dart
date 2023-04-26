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
          emit(SchoolFailure("No Internet"));
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

  void deleteSchool(token, id) {
    print("ff");
    emit(SchoolLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(SchoolFailure('No internet'));
      else {
        mainRepo.delete_school(token, id).then((resp) {
          print(resp);
          if (resp == "Deleted") {
            print("fffff");
            emit(SchoolDeleted());
          } else
            emit(SchoolNotDeleted());
        });
      }
    });
  }

  void addSchool(token, name,address) {
    print("ff");
    emit(SchoolLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(SchoolFailure('No internet'));
      else {
        mainRepo.add_school(token, name,address).then((resp) {
          print(resp);
          if (resp == "Added") {
            print("fffff");
            emit(SchoolAdded());
          } else
            emit(SchoolNotAdded());
        });
      }
    });
  }

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
