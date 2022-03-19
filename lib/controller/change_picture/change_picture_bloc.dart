import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'change_picture_event.dart';
part 'change_picture_state.dart';

class ChangePictureBloc extends Bloc<ChangePictureEvent, ChangePictureState> {
  ChangePictureBloc() : super(ChangePictureInitial()) {
    on<ChangePictureStartEvent>(_takePicture);
  }

  FutureOr<void> _takePicture(event, emit) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      File? finalImage = image != null ? File(image.path) : null;

      if (finalImage != null) {
        emit(ChangePicturePictureSelectedState(picture: finalImage));
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(ChangePictureErrorState());
    }
  }
}
