import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'leave_decision_state.dart';

class LeaveDecisionCubit extends Cubit<LeaveDecisionState> {
  final MainRepository mainRepository;
  LeaveDecisionCubit({required this.mainRepository}) : super(LeaveDecisionInitial());
  makeLeaveDecision(token, pes_id, decision) {
    emit(LeaveDecisionMarking());
    mainRepository.hasNetwork().then((Bool) {
      if (!Bool)
        emit(LeaveDecisionNotMarked("No Internet"));
      else {
        mainRepository.leaveApplicationDecision(token, pes_id,decision).then((status) {
          if (status == "Marked")
            emit(LeaveDecisionMarked(decision));
          else
            emit(LeaveDecisionNotMarked(status));
        });
      }
    });
  }
}
