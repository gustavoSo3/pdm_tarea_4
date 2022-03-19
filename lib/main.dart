import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_4_pdm/controller/load_acounts/load_acounts_bloc.dart';
import 'package:tarea_4_pdm/home/home_page.dart';

import 'package:tarea_4_pdm/controller/change_picture/change_picture_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChangePictureBloc()),
        BlocProvider(
            create: (context) =>
                LoadAcountsBloc()..add(InitialLoadAcountsEvent())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
