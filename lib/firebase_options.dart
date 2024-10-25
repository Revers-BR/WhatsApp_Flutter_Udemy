import 'package:firebase_core/firebase_core.dart';

const firebaseOptions = FirebaseOptions(
    apiKey: String.fromEnvironment("apiKey"), 
    appId: String.fromEnvironment("appId"), 
    messagingSenderId:  String.fromEnvironment("messagingSenderId"), 
    projectId:  String.fromEnvironment("projectId"),
    storageBucket: String.fromEnvironment("storageBucket")
);

