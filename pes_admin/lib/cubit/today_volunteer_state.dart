part of 'today_volunteer_cubit.dart';

@immutable
abstract class TodayVolunteerState {}

class TodayVolunteerInitial extends TodayVolunteerState {}

class TodayVolunteerLoading extends TodayVolunteerState {}

class TodayVolunteerLoaded extends TodayVolunteerState {}


class TodayVolunteerFailure extends TodayVolunteerState {
  final String error;

  TodayVolunteerFailure(this.error);
}
