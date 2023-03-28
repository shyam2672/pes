import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'add_studentNeeds_state.dart';

class AddStudentNeedsCubit extends Cubit<AddStudentNeedsState> {
  final MainRepository mainRepo;
  AddStudentNeedsCubit({required this.mainRepo})
      : super(AddStudentNeedsInitial());
  addStudentNeeds(token, data) {
    emit(AddStudentNeedsApplying());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(AddStudentNeedsNotApplied("No Internet"));
      else {
        mainRepo.addStudentNeeds(token, data).then((status) {
          if (status == "Added successfully")
            emit(AddStudentNeedsApplied());
          else
            emit(AddStudentNeedsNotApplied(status));
        });
      }
    });
  }
}