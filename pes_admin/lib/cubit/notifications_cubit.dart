import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/notifications.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final MainRepository mainRepo;
  NotificationsCubit({required this.mainRepo}) : super(NotificationsInitial());
  List<AppNotification> notifications = [];
  void loadNotifications(String token) {
    print(notifications);
    if (notifications.isEmpty) {
      emit(NotificationsLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(NotificationsError(error: 'No internet'));
        else {
          mainRepo.displayNotifications(token).then((List resp) {
            if (resp[0]==true) {
              notifications = resp[1];
              emit(NotificationsLoaded());
            } else
              emit(NotificationsError(error: "Can't Load Notificatilns"));
          });
        }
      });
    }
  }

  void addNotification(token,title,data){
   emit(NotificationsLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(NotificationsError(error: 'No internet'));
      else {
        mainRepo.addNotification(token,title,data).then((resp) {
          if (resp=="Sent") {
            emit(NotificationsAdded());
          } else
            emit(NotificationsNotAdded());
        });
      }
    }); 
  }
}
