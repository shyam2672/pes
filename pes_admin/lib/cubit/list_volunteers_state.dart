part of 'list_volunteers_cubit.dart';

@immutable
abstract class ListVolunteersState {}

class ListVolunteersInitial extends ListVolunteersState {}

class ListVolunteersLoading extends ListVolunteersState {}

class ListVolunteersLoaded extends ListVolunteersState {}

class ListVolunteersLoadingError extends ListVolunteersState {
  String error;
  ListVolunteersLoadingError({required this.error});
}
