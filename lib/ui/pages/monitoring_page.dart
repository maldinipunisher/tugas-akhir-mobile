part of 'pages.dart';

class MonitoringPage extends StatefulWidget {
  final User user;
  const MonitoringPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return MonitoringPageSuccess(
      user: widget.user,
    );
  }
}

class MonitoringPageSuccess extends StatefulWidget {
  final User user;

  const MonitoringPageSuccess({Key? key, required this.user}) : super(key: key);

  @override
  State<MonitoringPageSuccess> createState() => _MonitoringPageSuccessState();
}

class _MonitoringPageSuccessState extends State<MonitoringPageSuccess> {
  Arduino? arduino;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text(
          'Status',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              prevPage = GoToHomePage(widget.user, pageIndex: 2);
              context
                  .read<PageBloc>()
                  .add(GoToNotificationPage(arduino!.notifications));
            },
            icon: Icon(
              Ionicons.notifications,
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: RefreshIndicator(
          color: accent1Color,
          onRefresh: () async {},
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: ListView(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: DataService.getStatus,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done ||
                          snapshot.connectionState == ConnectionState.active) {
                        final data = snapshot.data!.data() as Map;
                        final List<NotificationModel?> notifications = [];
                        for (var notification in data['notifications']) {
                          notifications
                              .add(NotificationModel.toMap(notification));
                        }
                        arduino = Arduino(DataService.deviceId,
                            trigger: data['trigger'],
                            alarm: data['alarm'],
                            latitude: data['latitude'],
                            longtitude: data['longtitude'],
                            lock: data['lock'],
                            lastOnline: (data['waktu'] as Timestamp).toDate(),
                            firstStart:
                                (data['waktu_mulai'] as Timestamp).toDate(),
                            status: data['status'],
                            notifications: notifications);
                      }

                      return (arduino != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  SizedBox(height: 54.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      card(
                                        Icon(Ionicons.bug_outline,
                                            color: accentColor, size: 32.sp),
                                        "Status Perangkat",
                                        Text(
                                          arduino!.status,
                                          style: TextStyle(
                                              color: successTextColor,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      card(
                                        Icon(Ionicons.alarm_outline,
                                            color: warningTextColor,
                                            size: 32.sp),
                                        "Status Alarm",
                                        Text(
                                          arduino!.alarm,
                                          style: TextStyle(
                                              color: greyTextColor,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      card(
                                        Icon(Ionicons.hourglass_outline,
                                            color: orangeColor, size: 32.sp),
                                        "Terakhir Online",
                                        Text(
                                          formatDuration(DateTime.now()
                                              .toLocal()
                                              .difference(arduino!.lastOnline)),
                                          style: TextStyle(
                                              color: successTextColor,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      card(
                                        Icon(Ionicons.lock_closed,
                                            color: purpleColor, size: 32.sp),
                                        "Status Keamanan",
                                        Text(
                                          arduino!.lock,
                                          style: TextStyle(
                                              color: warningTextColor,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      card(
                                        Icon(Ionicons.power_outline,
                                            color: Colors.blue, size: 32.sp),
                                        "Pertama Online",
                                        Text(
                                          formatDuration(DateTime.now()
                                              .toLocal()
                                              .difference(arduino!.firstStart)),
                                          style: TextStyle(
                                              color: successTextColor,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      const Text(""),
                                    ],
                                  )
                                ])
                          : Center(
                              child: notConnected(),
                            );
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget card(Icon icon, String title, Text status) => Container(
        width: 158.w,
        height: 158.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19.r),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3), blurRadius: 4, color: Colors.grey),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            SizedBox(height: 11.h),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
            SizedBox(height: 30.h),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              status,
            ]),
          ],
        ),
      );
}

class MonitoringPageDisconected extends StatelessWidget {
  const MonitoringPageDisconected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      body: RefreshIndicator(
        color: accent1Color,
        onRefresh: () async {},
        child: NotificationListener<OverscrollIndicatorNotification>(
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
        ),
      ),
    );
  }
}
