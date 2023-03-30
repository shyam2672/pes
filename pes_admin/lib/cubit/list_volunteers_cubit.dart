import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'list_volunteers_state.dart';

class ListVolunteersCubit extends Cubit<ListVolunteersState> {
  final MainRepository mainRepo;
  ListVolunteersCubit({required this.mainRepo}) : super(ListVolunteersInitial());
  List<VolunteerSlotPage> volunteers = [];
  void loadVolunteerList(String token){
    if(volunteers.isEmpty){
      emit(ListVolunteersLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(ListVolunteersLoadingError(error: "No Internet"));
        else {
          mainRepo.listVolunteers(token).then((ListVolunteersResponse listResponse) {
            if (listResponse.hasLoaded) {
              volunteers = listResponse.volunteers;
              emit(ListVolunteersLoaded());
            } else
              emit(ListVolunteersLoadingError(error: "Can't Load Slots"));
          });
        }
      });

    }
  }

}
