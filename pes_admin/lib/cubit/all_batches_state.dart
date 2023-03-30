part of 'all_batches_cubit.dart';

@immutable
abstract class AllBatchesState {}

class AllBatchesInitial extends AllBatchesState {}

class AllBatchesLoading extends AllBatchesState {}

class AllBatchesLoaded extends AllBatchesState {}

class AllBatchesLoadFailure extends AllBatchesState {
  final String error;

  AllBatchesLoadFailure(this.error);
}
