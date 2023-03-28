part of 'slot_cubit.dart';

@immutable
abstract class SlotState {}

class SlotInitial extends SlotState {}


class Loading extends SlotState {}

class Loaded extends SlotState {}

class LoadFailure extends SlotState {
  final String error;

  LoadFailure(this.error);
}
