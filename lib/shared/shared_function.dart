part of 'shared.dart';

Future saveDeviceId(String deviceId) async {
  final sf = await SharedPreferences.getInstance();
  sf.setString("deviceId", deviceId);
}

Future<String?> getDeviceId() async {
  final sf = await SharedPreferences.getInstance();
  final deviceId = sf.getString("deviceId");
  DataService.deviceId = deviceId ?? "";
  return deviceId;
}

Widget notConnected() => SizedBox(
      width: 256.w,
      height: 108.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Ionicons.alert_circle_outline,
            size: 70.sp,
            color: warningTextColor,
          ),
          SizedBox(
            height: 9.h,
          ),
          Text(
            "Perangkat tidak tersambung\nharap nyalakan perangkat terlebih dahulu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          )
        ],
      ),
    );

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}h');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}j');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}d');

  return tokens.join(':');
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
