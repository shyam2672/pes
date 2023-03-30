part of 'slot_change_cubit.dart';

@immutable
abstract class SlotChangeState {}

class SlotChangeInitial extends SlotChangeState {}


class SlotChangeLoading extends SlotChangeState {}

class SlotSelectionActive extends SlotChangeState {}

class ApplicationSubmitted extends SlotChangeState {}

class ApplicationNotSubmitted extends SlotChangeState {
  final String message;

  ApplicationNotSubmitted(this.message);
}
