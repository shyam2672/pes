import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'join_decision_state.dart';

class JoinDecisionCubit extends Cubit<JoinDecisionState> {
  final MainRepository mainRepository;
  JoinDecisionCubit({required this.mainRepository}) : super(JoinDecisionInitial());
  makeJoinDecision(token, phone, decision) {
    emit(JoinDecisionMarking());
    mainRepository.hasNetwork().then((Bool) {
      if (!Bool)
        emit(JoinDecisionNotMarked("No Internet"));
      else {
        mainRepository.joinApplicationDecision(token, phone,decision).then((status) {
          if (status == "Marked")
            emit(JoinDecisionMarked(decision: decision));
          else
            emit(JoinDecisionNotMarked(status));
        });
      }
    });
  }
}
