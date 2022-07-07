// ignore_for_file: must_be_immutable

part of 'pages.dart';

class NavigationPage extends StatefulWidget {
  final User user;
  final String deviceId;
  int pageIndex;
  NavigationPage(
      {Key? key,
      required this.user,
      required this.deviceId,
      required this.pageIndex})
      : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late PageController _pageController;
  Arduino? arduino;
  // int pageIndex = 0;

  @override
  void initState() {
    DataService.deviceId = widget.deviceId;
    _pageController = PageController(initialPage: widget.pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FutureBuilder(
          future: Future.value(true),
          builder: (context, snapshot) {
            return BottomNavigationWidget(
              pageController: _pageController,
              pageIndex: widget.pageIndex,
            );
          }),
      body: StreamBuilder<DocumentSnapshot>(
          stream: DataService.getStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data!.data() as Map;
              final List<NotificationModel?> notifications = [];
              for (var notification in data['notifications']) {
                notifications.add(NotificationModel.toMap(notification));
              }
              arduino = Arduino(
                widget.deviceId,
                trigger: data['trigger'],
                alarm: data['alarm'],
                latitude: data['latitude'],
                longtitude: data['longtitude'],
                lock: data['lock'],
                firstStart: (data['waktu_mulai'] as Timestamp).toDate(),
                lastOnline: (data['waktu'] as Timestamp).toDate(),
                status: data['status'],
                notifications: notifications,
              );
            }

            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.right,
              color: accent1Color,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      widget.pageIndex = page;
                    });
                  },
                  children: [
                    HomePage(
                      user: widget.user,
                      arduino: arduino,
                    ),
                    MapPage(
                      user: widget.user,
                      arduino: arduino,
                    ),
                    MonitoringPage(
                      user: widget.user,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
