import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/studentNeeds.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'studentNeeds_state.dart';

class StudentNeedsCubit extends Cubit<StudentNeedsState> {
  final MainRepository mainRepo;
  StudentNeedsCubit({required this.mainRepo}) : super(StudentNeedsInitial());
  List<AppStudentNeeds> studentNeeds = [];
  void loadStudentNeeds(String token) {
    print(studentNeeds);
    if (studentNeeds.isEmpty) {
      emit(StudentNeedsLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(StudentNeedsError(error: 'No internet'));
        else {
          mainRepo.getStudentNeeds(token).then((List resp) {
            if (resp[0] == true) {
              studentNeeds = resp[1];
              emit(StudentNeedsLoaded());
            } else
              emit(StudentNeedsError(error: "Can't Load Student Needs"));
          });
        }
      });
    }
  }

  void addStudentNeeds(token, name, title, data) {
    emit(StudentNeedsLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(StudentNeedsError(error: 'No internet'));
      else {
        mainRepo.addStudentNeeds(token, name, title, data).then((resp) {
          if (resp == "Sent") {
            emit(StudentNeedsAdded());
          } else
            emit(StudentNeedsNotAdded());
        });
      }
    });
  }

  void delStudentNeeds(token, id) {
    print("ff");
    emit(StudentNeedsLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(StudentNeedsError(error: 'No internet'));
      else {
        mainRepo.delStudentNeeds(token, id).then((resp) {
          print(resp);
          if (resp == "Deleted") {
            print("fffff");
            emit(StudentNeedsDeleted());
          } else
            emit(StudentNeedsNotDeleted());
        });
      }
    });
  }
}
