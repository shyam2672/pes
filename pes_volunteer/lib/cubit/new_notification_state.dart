part of 'new_notification_cubit.dart';

@immutable
abstract class NewNotificationState {}

class NewNotificationInitial extends NewNotificationState {}

class SomeNewNotification extends NewNotificationState {}

class NoNewNotification extends NewNotificationInitial {}
