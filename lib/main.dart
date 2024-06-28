import 'dart:io';

import 'package:chat_demo/screen/splash/splash_screen.dart';
import 'package:chat_demo/screen/welcome/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options:  const FirebaseOptions(
        apiKey: 'AIzaSyC2OfoqA3olX9zKND8uxzfHrKoop2W13NU',
        authDomain: 'kevaldemo-f0d36.firebaseapp.com',
        projectId: 'kevaldemo-f0d36',
        storageBucket: 'kevaldemo-f0d36.appspot.com',
        messagingSenderId: '111879291951',
        appId: '1:111879291951:web:a79092ed558225d671f2da',
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: const MaterialApp(
        title: 'Demo',
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
         home: SplashScreen(),
      ),
    );
  }
}
