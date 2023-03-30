import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'student_needs_delete_state.dart';

class StudentNeedsDelete extends Cubit<StudentNeedsDeleteState> {
  final MainRepository mainRepo;
  List selectedNeeds = [];

  StudentNeedsDelete({required this.mainRepo}) : super(StudentNeedsDeleteInitial());

  NeedsDeleteApplication(token) {
    emit(StudentNeedsDeleteLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(ApplicationNotSubmitted("No Internet"));
      else {
        mainRepo.NeedsDeleteApplication(token, selectedNeeds).then((status) {
          if (status == "NeedsDeleted")
            emit(ApplicationSubmitted());
          else
            emit(ApplicationNotSubmitted(status));
        });
      }
    });
  }

  void selectNeedsDelete() {
    selectedNeeds = [];
    emit(StudentNeedsSelectionActive());
  }
}
