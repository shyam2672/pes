part of 'slots_cubit.dart';

@immutable
abstract class SlotsState {}

class SlotsInitial extends SlotsState {}

class Loading extends SlotsState {}

class Loaded extends SlotsState {}

class SlotDeleted extends SlotsState {}

class SlotNotDeleted extends SlotsState {}

class LoadFailure extends SlotsState {
  final String error;

  LoadFailure(this.error);
}
