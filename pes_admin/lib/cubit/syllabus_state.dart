part of 'syllabus_cubit.dart';

@immutable
abstract class SyllabusState {}

class SyllabusInitial extends SyllabusState {}

class SyllabusLoading extends SyllabusState {}

class SyllabusLoaded extends SyllabusState {
  final String syllabusUrl;
  SyllabusLoaded(this.syllabusUrl);
}

class LoadError extends SyllabusState {}
