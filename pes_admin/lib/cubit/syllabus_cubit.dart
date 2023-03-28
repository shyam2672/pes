import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'syllabus_state.dart';

class SyllabusCubit extends Cubit<SyllabusState> {
  final MainRepository mainRepository;
  SyllabusCubit(this.mainRepository) : super(SyllabusInitial());

  loadSyllabus(batch, token) {
    emit(SyllabusLoading());
    mainRepository.getSyllabus(batch, token).then((syllabusUrl) {
      if (syllabusUrl != "") {
        emit(SyllabusLoaded(syllabusUrl));
      } else
        emit(LoadError());
    });
  }
}
