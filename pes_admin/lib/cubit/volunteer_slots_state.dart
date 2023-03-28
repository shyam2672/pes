part of 'volunteer_slots_cubit.dart';

@immutable
abstract class VolunteerSlotsState {}

class VolunteerSlotsInitial extends VolunteerSlotsState {}

class VolunteerSlotsLoading extends VolunteerSlotsState {}
class VolunteerSlotsLoaded extends VolunteerSlotsState {}
class VolunteerSlotsLoadFailed extends VolunteerSlotsState {
  String error;
  VolunteerSlotsLoadFailed({required this.error});
}
