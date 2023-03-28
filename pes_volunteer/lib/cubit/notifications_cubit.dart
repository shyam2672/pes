import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes/data/models/notification.dart';
import 'package:pes/data/repositories/main_server_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final MainRepository mainRepository;

  NotificationsCubit({required this.mainRepository})
      : super(NotificationsInitial());

  List<AppNotification> notifications = [];

  getNotifications(String token) {
    emit(NotificationsLoading());
    if (notifications.isEmpty) {
      mainRepository.hasNetwork().then(
        (Bool) {
          if (!Bool) {
            emit(NotificationsError(error: "No Internet"));
            Timer(Duration(seconds: 3), () {
              emit(NotificationsInitial());
            });
          } else {
            mainRepository.getNotifications(token).then((var response) {
              notifications = response;
              emit(NotificationsLoaded());
            });
          }
        },
      );
    } else {
      emit(NotificationsLoaded());
    }
  }

  readNotifications(token, String id) {
    mainRepository.readNotification(token, id);
  }
}
