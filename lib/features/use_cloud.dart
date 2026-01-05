
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CloudProvider {
  Future<void> initialize();
  Future<void> uploadData(String collection, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> fetchData(String collection, String docId);
  String get name;
}

class FirebaseCloudProvider implements CloudProvider {

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseCloudProvider && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String get name => 'Firebase';

  @override
  Future<void> initialize() async {
    try{
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    } catch (e) {
      final settings = SettingsDataModel();
      await settings.loadSettings();
      settings.infoMessage = settings.loc!.errInitFire(e);
    }
  }

  @override
  Future<void> uploadData(String collection, Map<String, dynamic> data) async {
    final docId = data['id'];
    try {
      await FirebaseFirestore.instance.collection(collection).doc(docId).set(data);
    } catch (e) {
      // Handle error
      // print("Error uploading data: $e");
      final settings = SettingsDataModel();
      await settings.loadSettings();
      settings.infoMessage = settings.loc!.errUploFire(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchData(String collection, String docId) async {
    try{
      final docSnapshot = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
      final data = docSnapshot.data();
      if (data != null) {
        return [data];
      } else {
        return [];
      }
    } catch (e) {
      // Handle error
      return [
        {"Error": "$e"}
      ];
    }
  }
}

class GoogleCloudProvider implements CloudProvider {
  @override
  bool operator ==(Object other) => other is GoogleCloudProvider;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String get name => 'Google Cloud';

  @override
  Future<void> initialize() async {
    // Initialize Google Cloud SDK or API here
  }

  @override
  Future<void> uploadData(String collection, Map<String, dynamic> data) async {
    // Implement Google Cloud data upload logic here
  }

  @override
  Future<List<Map<String, dynamic>>> fetchData(String collection, String docId) async {
    // Implement Google Cloud data fetch logic here
    return [];
  }
}

class UserBackendCloudProvider implements CloudProvider {
  @override
  bool operator ==(Object other) => other is UserBackendCloudProvider;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String get name => 'User Backend';
  
  @override
  Future<void> initialize() async {
    // Initialize user backend API here
  }

  @override
  Future<void> uploadData(String collection, Map<String, dynamic> data) async {
    // Implement user backend data upload logic here
  }

  @override
  Future<List<Map<String, dynamic>>> fetchData(String collection, String docId) async {
    // Implement user backend data fetch logic here
    return [];
  }
}

class CloudService {
  final CloudProvider _provider;

  CloudService(this._provider);

  String get name => _provider.name;

  Future<void> initialize() => _provider.initialize();

  Future<void> uploadData(String collection, Map<String, dynamic> data) =>
      _provider.uploadData(collection, data);

  Future<List<Map<String, dynamic>>> fetchData(String collection, String docId) =>
      _provider.fetchData(collection, docId);
}