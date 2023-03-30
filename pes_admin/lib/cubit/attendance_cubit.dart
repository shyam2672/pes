import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  Map filters = {'pathshaala': 'All', 'attendanceCrit': 'All'};
  List Attendances = [];

  final MainRepository mainRepo;
  AttendanceCubit({required this.mainRepo}) : super(AttendanceInitial());

  loadAttendance(token) {
    emit(AttendanceLoading());
    print(Attendances);
    if (Attendances.isEmpty) {
      mainRepo.hasNetwork().then(
        (Bool) {
          if (!Bool){
            emit(AttendanceLoadFailure(error: "No Internet"));
          }
          else {
            mainRepo
                .getVolunteerAttendance(token)
                .then((VolunteerAttendanceResponse attendanceResponse) {
              if (attendanceResponse.hasLoaded) {
                Attendances = attendanceResponse.VolunteerAttendances;
                print(Attendances);
                emit(AttendanceLoaded());
              } else {
                emit(AttendanceLoadFailure(error: "Something Went Wrong"));
              }
            });
          }
        },
      );
    } else {
      emit(AttendanceLoaded());
    }
  }
}
