import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'leave_pehchaan_state.dart';

class LeavePehchaanCubit extends Cubit<LeavePehchaanState> {
  final MainRepository mainRepo;
  LeavePehchaanCubit({required this.mainRepo}) : super(LeavePehchaanInitial());
  leavePehchaan(token,reason){
	  emit(LeavePehchaanApplying());
	  mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(LeavePehchaanNotApplied("No Internet"));
      else {
        mainRepo.leavePehchaan(token, reason).then((status) {
          if (status == "Submitted successfully")
            emit(LeavePehchaanApplied());
          else
            emit(LeavePehchaanNotApplied(status));
        });
      }
    });

  }
}
