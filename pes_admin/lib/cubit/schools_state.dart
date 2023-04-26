part of 'schools_cubit.dart';

@immutable
abstract class SchoolState {}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {}
class SchoolAdded extends SchoolState {}
class SchoolNotAdded extends SchoolState {}

class SchoolDeleted extends SchoolState {}

class SchoolNotDeleted extends SchoolState {}



class SchoolFailure extends SchoolState {
  final String error;
  SchoolFailure(this.error);
}
