part of 'delete_batch_cubit.dart';

@immutable
abstract class BatchDeleteState {}

class BatchDeleteInitial extends BatchDeleteState {}

class BatchDeleteLoading extends BatchDeleteState {}

class BatchSelectionActive extends BatchDeleteState {}

class BatchDelApplicationSubmitted extends BatchDeleteState {}

class BatchDelApplicationNotSubmitted extends BatchDeleteState {
  final String message;

  BatchDelApplicationNotSubmitted(this.message);
}
