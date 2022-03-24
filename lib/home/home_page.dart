// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tarea_4_pdm/controller/change_picture/change_picture_bloc.dart';

import '../controller/load_acounts/load_acounts_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState

    FeatureDiscovery.clearPreferences(context, <String>{
      'ver_tarjeta',
      'cambiar_foto',
      'show_tutorial',
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                final _directory = await getApplicationDocumentsDirectory();

                Uint8List? screenshot = await _controller.capture();
                final image = File('${_directory.path}/screenshot.png');
                image.writeAsBytesSync(screenshot!);
                Share.shareFiles([image.path]);
              },
              icon: Icon(Icons.share),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<ChangePictureBloc, ChangePictureState>(
                listener: (context, state) {
                  if (state is ChangePictureErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error changing picture"),
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is ChangePicturePictureSelectedState) {
                    return CircleAvatar(
                      backgroundImage: FileImage(state.picture),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 122, 113, 113),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  }
                },
              ),
            ),
            Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Usuario[dc37a]"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      DescribedFeatureOverlay(
                        featureId:
                            'ver_tarjeta', // Unique id that identifies this overlay.
                        tapTarget: const Icon(Icons
                            .credit_card), // The widget that will be displayed as the tap target.
                        title: Text('Ver Tarjeta'),
                        description: Text(
                            'Presiona para ver las tarjetas asociadas a tu cuenta.'),
                        backgroundColor: Theme.of(context).primaryColor,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: MaterialButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.credit_card,
                            size: 30,
                          ),
                          color: Colors.indigo,
                          textColor: Colors.white,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                      Text("Ver tarjeta"),
                    ],
                  ),
                  Column(
                    children: [
                      DescribedFeatureOverlay(
                        featureId:
                            'cambiar_foto', // Unique id that identifies this overlay.
                        tapTarget: const Icon(Icons
                            .camera_alt), // The widget that will be displayed as the tap target.
                        title: Text('Cambiar Foto'),
                        description:
                            Text('Presiona para cambiar la foto de tu cuenta.'),
                        backgroundColor: Theme.of(context).primaryColor,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: MaterialButton(
                          onPressed: () {
                            BlocProvider.of<ChangePictureBloc>(context)
                                .add(ChangePictureStartEvent());
                          },
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.orange,
                          textColor: Colors.white,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                      Text("Cambiar Foto"),
                    ],
                  ),
                  Column(
                    children: [
                      DescribedFeatureOverlay(
                        featureId:
                            'show_tutorial', // Unique id that identifies this overlay.
                        tapTarget: const Icon(Icons
                            .play_arrow), // The widget that will be displayed as the tap target.
                        title: Text('Inicia el tutorial'),
                        description: Text('Presiona para ver este tutorial.'),
                        backgroundColor: Theme.of(context).primaryColor,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: MaterialButton(
                          onPressed: () {
                            FeatureDiscovery.clearPreferences(context, <String>{
                              'ver_tarjeta',
                              'cambiar_foto',
                              'show_tutorial',
                            });
                            FeatureDiscovery.discoverFeatures(
                              context,
                              const <String>{
                                // Feature ids for every feature that you want to showcase in order.
                                'ver_tarjeta',
                                'cambiar_foto',
                                'show_tutorial',
                              },
                            );
                          },
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                          ),
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                      Text("Ver Tutorial"),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<LoadAcountsBloc, LoadAcountsState>(
                    listener: (context, state) {
                      if (state is LoadAcountsErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error charging acounts"),
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadAcountsEmptyState) {
                        return Center(
                          child: Text("You dont have any acount"),
                        );
                      } else if (state is LoadAcountsLoadState) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: state.acounts['db'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${state.acounts['db'][index]['cuenta']}",
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "~${state.acounts['db'][index]['cuenta']}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "\$${state.acounts['db'][index]['balance']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "Saldo disponible",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
