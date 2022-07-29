// ignore_for_file: deprecated_member_use

part of 'pages.dart';

class MapPage extends StatefulWidget {
  final User user;
  final Arduino? arduino;
  const MapPage({Key? key, required this.user, this.arduino}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    // return MapPageDisconected();
    return (widget.arduino != null)
        ? MapPageSuccess(
            user: widget.user,
            arduino: widget.arduino,
          )
        : const MapPageDisconected();
  }
}

class MapPageSuccess extends StatefulWidget {
  final User user;
  final Arduino? arduino;

  const MapPageSuccess({Key? key, required this.user, this.arduino})
      : super(key: key);

  @override
  State<MapPageSuccess> createState() => _MapPageSuccessState();
}

class _MapPageSuccessState extends State<MapPageSuccess> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition phonePosition, arduinoPosition;
  bool doneLoad = false;
  Set<Marker> markers = <Marker>{};
  MapType mapType = MapType.normal;

  @override
  void initState() {
    determinePosition().then((pos) {
      setState(() {
        phonePosition = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 15,
        );
        markers.add(Marker(
            markerId: const MarkerId("phone"),
            position: phonePosition.target,
            infoWindow: const InfoWindow(title: "phone")));
      });
    }).whenComplete(() {
      setState(() {
        doneLoad = true;
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });

    arduinoPosition = CameraPosition(
      target: LatLng(
        widget.arduino!.latitude,
        widget.arduino!.longtitude,
      ),
      zoom: 15,
    );
    markers.add(Marker(
        markerId: const MarkerId("sepeda"),
        position: arduinoPosition.target,
        infoWindow: const InfoWindow(title: "sepeda")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (doneLoad)
          ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.sp)),
                          child: Icon(
                            Ionicons.phone_portrait_sharp,
                            color: accentColor,
                            size: 24.sp,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            final GoogleMapController controller =
                                await _controller.future;
                            determinePosition().then((pos) {
                              setState(() {
                                phonePosition = CameraPosition(
                                  target: LatLng(pos.latitude, pos.longitude),
                                  zoom: 15,
                                );
                                markers.removeWhere(
                                    (m) => m.markerId.value == "phone");
                                markers.add(Marker(
                                    markerId: const MarkerId("phone"),
                                    position: phonePosition.target,
                                    infoWindow:
                                        const InfoWindow(title: "phone")));
                              });
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                            });
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(phonePosition));
                          }),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.sp)),
                          child: Icon(
                            Ionicons.logo_android,
                            color: accentColor,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            final GoogleMapController controller =
                                await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    arduinoPosition));
                            setState(() {
                              markers.removeWhere(
                                  (m) => m.markerId.value == "sepeda");
                              markers.add(Marker(
                                  markerId: const MarkerId("sepeda"),
                                  position: arduinoPosition.target,
                                  infoWindow:
                                      const InfoWindow(title: "sepeda")));
                            });
                          }),
                    ),
                    SizedBox(height: 10.h),
                  ]),
            )
          : null,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: accent1Color,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: accentColor,
        title: Row(
          children: [
            Text(
              "Terakhir dilihat: ",
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            Text(
              '14-10-2022',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: const Text("Open from google maps?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "no",
                                style: TextStyle(color: Colors.black),
                              )),
                          TextButton(
                              onPressed: () async {
                                var url =
                                    'https://www.google.com/maps/search/?api=1&query=${arduinoPosition.target.latitude},${arduinoPosition.target.longitude}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Tidak dapat membuka $url';
                                }
                              },
                              child: const Text(
                                "yes",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      ));
            },
            icon: Icon(Ionicons.map_outline, size: 24.sp, color: Colors.white),
          ),
          PopupMenuButton<MapType>(
            onSelected: (MapType type) {
              setState(() {
                mapType = type;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<MapType>(
                  value: MapType.normal,
                  child: Text("Normal"),
                ),
                const PopupMenuItem<MapType>(
                  value: MapType.hybrid,
                  child: Text("Hybrid"),
                ),
                const PopupMenuItem<MapType>(
                  value: MapType.satellite,
                  child: Text("Satellite"),
                ),
                const PopupMenuItem<MapType>(
                  value: MapType.terrain,
                  child: Text("Terrain"),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        // child: RefreshIndicator(
        //   color: accent1Color,
        //   onRefresh: () async {},
        //   child: NotificationListener<OverscrollIndicatorNotification>(
        //     onNotification: (overscroll) {
        //       overscroll.disallowIndicator();
        //       return false;
        //     },
        child: (doneLoad)
            ? ListView(
                children: [
                  Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 0.84,
                    color: backgroundColor,
                    child: GoogleMap(
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      markers: markers,
                      initialCameraPosition: phonePosition,
                      mapType: mapType,
                      onMapCreated: (_controller) {
                        this._controller.complete(_controller);
                      },
                    ),
                  ),
                ],
              )
            : Center(child: SpinKitRing(color: accent1Color)),
        //   ),
        // ),
      ),
    );
  }
}

class MapPageDisconected extends StatelessWidget {
  const MapPageDisconected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      body:
          // RefreshIndicator(
          //   color: accent1Color,
          //   onRefresh: () async {},
          //   child:
          NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight * 0.38,
            ),
            notConnected(),
          ],
        ),
        //   ),
      ),
    );
  }
}
