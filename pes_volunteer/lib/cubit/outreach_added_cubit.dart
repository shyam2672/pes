import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
part 'outreach_added_state.dart';

class AddOutreachCubit extends Cubit<AddOutreachState> {
  final MainRepository mainRepo;
  AddOutreachCubit({required this.mainRepo})
      : super(AddOutreachInitial());

  addOutreach(token,school,topic,description,date,timestart,timeend,remarks ) {
    emit(AddOutreachApplying());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(AddOutreachNotApplied("No Internet"));
      else {
        mainRepo.addoutreach(token,school,topic,description,date,timestart,timeend,remarks).then((status) {
          if (status == "Added successfully")
            emit(AddOutreachApplied());
          else
            emit(AddOutreachNotApplied(status));
        });
      }
    });
  }
}