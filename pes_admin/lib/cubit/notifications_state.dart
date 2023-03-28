part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {}

class NotificationsAdded extends NotificationsState{}

class NotificationsNotAdded extends NotificationsState{}

class NotificationsError extends NotificationsState {
  String error;
  NotificationsError({required this.error});
}
