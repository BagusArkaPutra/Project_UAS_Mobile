import 'package:flutter/material.dart';
import 'package:aplikasitask/widgets/screen/tambah_kebiasaan_screen.dart';
import 'package:aplikasitask/widgets/screen/kebiasaan_screen.dart';
import 'package:provider/provider.dart';

import 'datasource/data_source.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KebiasaanNotifier(),
      lazy: false,
      child: MaterialApp(
        title: 'Aplikasi Catatan Kebiasaan ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonColor: Color(0xFF5478F2),
          accentColor: Color(0xFF2E2F31),
          scaffoldBackgroundColor: Color(0xFFEAEAF2),
        ),
        initialRoute: KebiasaanScreen.id,
        routes: {
          KebiasaanScreen.id: (context) => KebiasaanScreen(),
          TambahKebiasaanScreen.id: (context) => TambahKebiasaanScreen(),
        },
      ),
    );
  }
}
