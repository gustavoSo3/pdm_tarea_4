part of 'load_acounts_bloc.dart';

@immutable
abstract class LoadAcountsState {}

class LoadAcountsInitial extends LoadAcountsState {}

class LoadAcountsLoadingState extends LoadAcountsState {}

class LoadAcountsLoadState extends LoadAcountsState {
  final Map acounts;
  LoadAcountsLoadState({required this.acounts});
  List<Object> get props => [acounts];
}

class LoadAcountsEmptyState extends LoadAcountsState {}

class LoadAcountsErrorState extends LoadAcountsState {}
