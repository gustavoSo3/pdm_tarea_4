import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'load_acounts_event.dart';
part 'load_acounts_state.dart';

class LoadAcountsBloc extends Bloc<LoadAcountsEvent, LoadAcountsState> {
  LoadAcountsBloc() : super(LoadAcountsInitial()) {
    on<InitialLoadAcountsEvent>(_loadAcounts);
  }

  Future<FutureOr<void>> _loadAcounts(event, emit) async {
    emit(LoadAcountsLoadingState());

    final url = Uri.parse(
        'https://api.sheety.co/636a7e3404056e6b0e577f63559cbff5/apiTarea4/db');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      emit(LoadAcountsErrorState());
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['db'].isEmpty) {
      print('hello');
      print(decodedResponse['db'].isEmpty);
      emit(LoadAcountsEmptyState());
    } else {
      emit(LoadAcountsLoadState(acounts: decodedResponse));
    }
  }
}
