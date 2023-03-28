part of 'slot_edit_cubit.dart';

@immutable
abstract class SlotEditState {}

class SlotEditInitial extends SlotEditState {}

class SlotEditSelect extends SlotEditState {}

class SlotEditUnselect extends SlotEditState {}

class SlotEditing extends SlotEditState {
  Map slotData = {};
  
  Slot slot;

  SlotEditing({required this.slot});
}

class SlotEditSubmitting extends SlotEditState {}

class SlotEdited extends SlotEditState {}

class SlotEditError extends SlotEditState {
  final String error;

  SlotEditError({required this.error});
}
