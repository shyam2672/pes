import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/join_application.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'join_application_state.dart';

class JoinApplicationCubit extends Cubit<JoinApplicationState> {
  JoinApplicationCubit({required this.mainRepo}) : super(JoinApplicationInitial());
  final MainRepository mainRepo;
  List<JoinApplication> applications=[];
  void loadApplications(String token){
    if (applications.isEmpty) {
      emit(JoinApplicationLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(JoinApplicationLoadFailed("No Internet"));
        else {
          mainRepo.getJoiningApplications(token).then((JoinApplicationResponse appResponse) {
            if (appResponse.hasLoaded) {
              applications = appResponse.applications;
              emit(JoinApplicationLoaded());
            } else
              emit(JoinApplicationLoadFailed("Can't Load Applications"));
          });
        }
      });
    }
  }
}

