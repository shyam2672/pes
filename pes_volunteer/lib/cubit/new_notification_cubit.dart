import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'new_notification_state.dart';

class NewNotificationCubit extends Cubit<NewNotificationState> {
  NewNotificationCubit({required this.mainRepository})
      : super(NewNotificationInitial());
  final MainRepository mainRepository;

  getNewNotification(String token) {
    emit(NoNewNotification());
    mainRepository.hasNetwork().then(
      (Bool) {
        if (!Bool) {
          emit(NoNewNotification());
        } else {
          mainRepository
              .getNewNotificationBool(token)
              .then((bool hasNewNotification) {
            if (hasNewNotification)
              emit(SomeNewNotification());
            else
              emit(NoNewNotification());
          });
        }
      },
    );
  }
}
