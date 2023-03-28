import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final MainRepository mainRepo;
  AttendanceCubit({required this.mainRepo}) : super(AttendanceInitial());

  markAttendance(token, slotId, remarks) {
    emit(AttendanceMarking());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(AttendanceNotMarked("No Internet"));
      else {
        mainRepo.markAttendance(token, slotId, remarks).then((status) {
          if (status == "Attendance Marked")
            emit(AttendanceMarked());
          else
            emit(AttendanceNotMarked(status));
        });
      }
    });
  }
}
