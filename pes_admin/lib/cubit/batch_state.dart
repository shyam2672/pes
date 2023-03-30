part of 'batch_cubit.dart';

@immutable
abstract class BatchState {}

class BatchInitial extends BatchState {}


class Loading extends BatchState {}

class Loaded extends BatchState {}

class LoadFailure extends BatchState {
  final String error;

  LoadFailure(this.error);
}
