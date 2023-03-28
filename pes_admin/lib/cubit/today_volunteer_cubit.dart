import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'today_volunteer_state.dart';

class TodayVolunteerCubit extends Cubit<TodayVolunteerState> {
  TodayVolunteerCubit({required this.mainRepo})
      : super(TodayVolunteerInitial());
  List<VolunteerHomeScreen> p1_volunteers = [],
      p2_volunteers = [],
      allVolunteers = [];

  final MainRepository mainRepo;

  void loadVolunteer(String token) {
    print(allVolunteers);
    if (allVolunteers.isEmpty) {
      emit(TodayVolunteerLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(TodayVolunteerFailure("No Internet"));
        else {
          mainRepo
              .getHomeVolunteers(token)
              .then((VolunteerHomeResponse volunteerResponse) {
            if (volunteerResponse.hasLoaded) {
              p1_volunteers = volunteerResponse.p1_volunteers;
              p2_volunteers = volunteerResponse.p2_volunteers;
              allVolunteers.addAll(p1_volunteers);
              allVolunteers.addAll(p2_volunteers);
              emit(TodayVolunteerLoaded());
            } else
              emit(TodayVolunteerFailure("Can't Load Today's Volunteers"));
          });
        }
      });
    }
  }
}
