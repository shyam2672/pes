part of 'topic_cubit.dart';

@immutable
abstract class TopicState {}

class TopicInitial extends TopicState {}

class TopicLoading extends TopicState {}

class TopicLoaded extends TopicState {}
class TopicAdded extends TopicState {}
class TopicNotAdded extends TopicState {}

class TopicDeleted extends TopicState {}

class TopicNotDeleted extends TopicState {}



class TopicFailure extends TopicState {
  final String error;
  TopicFailure(this.error);
}
