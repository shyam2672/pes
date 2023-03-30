part of 'batch_edit_cubit.dart';

@immutable
abstract class BatchEditState {}

class BatchEditInitial extends BatchEditState {}

class BatchEditSelect extends BatchEditState {}

class BatchEditUnselect extends BatchEditState {}

class BatchEditing extends BatchEditState {
  Batch batch;

  BatchEditing({required this.batch});
}

class BatchEditSubmitting extends BatchEditState {}

class BatchEdited extends BatchEditState {}

class BatchEditError extends BatchEditState {
  final String error;

  BatchEditError({required this.error});
}
