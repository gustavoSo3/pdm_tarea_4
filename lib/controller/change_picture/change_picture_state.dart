part of 'change_picture_bloc.dart';

@immutable
abstract class ChangePictureState {}

class ChangePictureInitial extends ChangePictureState {}

class ChangePictureErrorState extends ChangePictureState {}

class ChangePicturePictureSelectedState extends ChangePictureState {
  final File picture;
  ChangePicturePictureSelectedState({required this.picture});
  List<Object> get props => [picture];
}
