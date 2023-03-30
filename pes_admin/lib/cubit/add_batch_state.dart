part of 'add_batch_cubit.dart';

@immutable
abstract class AddBatchState {}

class AddBatchInitial extends AddBatchState {}

class AddBatchLoading extends AddBatchState {}

class ApplicationSubmitted extends AddBatchState {}

class ApplicationData extends AddBatchState {}

class AddBatchError extends AddBatchState {
  final String error;

  AddBatchError(this.error);
}
