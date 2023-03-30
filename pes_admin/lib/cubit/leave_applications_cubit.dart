import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/leave_applications.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'leave_applications_state.dart';

class LeaveApplicationsCubit extends Cubit<LeaveApplicationsState> {
  LeaveApplicationsCubit({required this.mainRepo}) : super(LeaveApplicationsInitial());
  final MainRepository mainRepo;
  List<LeaveApplication> applications=[];
  void loadApplications(String token){
    if (applications.isEmpty) {
      emit(LeaveApplicationsLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(LeaveApplicationsLoadFailed("No Internet"));
        else {
          mainRepo.getLeavingApplications(token).then((LeaveApplicationsResponse appResponse) {
            if (appResponse.hasLoaded) {
              applications = appResponse.applications;
              emit(LeaveApplicationsLoaded());
            } else
              emit(LeaveApplicationsLoadFailed("Can't Load Applications"));
          });
        }
      });
    }
  }
}

