part of 'services.dart';

class DataService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String deviceId = "";

  static Stream<DocumentSnapshot> get getStatus {
    final res = _db.collection("data").doc(deviceId).snapshots();
    return res;
  }

  static Future<bool> checkDeviceId() async {
    try {
      final res = await _db.collection("data").doc(deviceId).get();
      final data = (res.data() as Map);
      return (data.isNotEmpty) ? true : false;
    } catch (e) {
      throw "error not found";
    }
  }

  static Future<void> setTokenApp({String? token = ""}) async {
    try {
      _db.collection("data").doc(deviceId).update({
        "token_app": token,
      });
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  static Future<bool> update(Arduino arduino) async {
    try {
      _db.collection("data").doc(deviceId).update({
        "alarm": arduino.alarm,
        "latitude": arduino.latitude,
        "longtitude": arduino.longtitude,
        "lock": arduino.lock,
        "status": arduino.status,
      });
      return true;
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
