part of 'pages.dart';

class NotificationPage extends StatefulWidget {
  final List<NotificationModel?>? notifications;
  const NotificationPage({Key? key, required this.notifications})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return NotificationSuccess(notifications: widget.notifications);
  }
}

class NotificationSuccess extends StatefulWidget {
  final List<NotificationModel?>? notifications;
  const NotificationSuccess({Key? key, this.notifications}) : super(key: key);

  @override
  State<NotificationSuccess> createState() => _NotificationSuccessState();
}

class _NotificationSuccessState extends State<NotificationSuccess> {
  List<String> notificationText = [
    "Perangkat berhasil dipasang",
    "Alarm berbunyi"
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(prevPage!);
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          leading: IconButton(
            onPressed: () {
              context.read<PageBloc>().add(prevPage!);
            },
            icon: Icon(
              Ionicons.chevron_back,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tersambung",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body:
            // RefreshIndicator(
            //   color: accent1Color,
            //   onRefresh: () async {},
            //   child: NotificationListener<OverscrollIndicatorNotification>(
            //     onNotification: (overscroll) {
            //       overscroll.disallowIndicator();
            //       return false;
            //     },
            //     child:
            (widget.notifications!.isNotEmpty)
                ? ListView(
                    children: List.generate(
                      widget.notifications!.length,
                      (index) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.1.sp,
                            color: greyTextColor,
                          ),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          style: ListTileStyle.list,
                          onTap: () {},
                          subtitle: Text(
                            widget.notifications![index]!.body,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.notifications![index]!.title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.sp),
                              ),
                              Text(
                                DateFormat("d MMM yyyy HH:mm").format(widget
                                    .notifications![index]!.date!
                                    .toLocal()),
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "Tidak ada notifikasi",
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                    ),
                  ),
      ),
      //   ),
      // ),
    );
  }
}

class NotificationDisconected extends StatelessWidget {
  const NotificationDisconected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body:
            // RefreshIndicator(
            //   color: accent1Color,
            //   onRefresh: () async {},
            //   child: NotificationListener<OverscrollIndicatorNotification>(
            //     onNotification: (overscroll) {
            //       overscroll.disallowIndicator();
            //       return false;
            //     },
            //     child:
            ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Ionicons.chevron_back,
                        color: Colors.black, size: 24.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().screenHeight * 0.30,
            ),
            notConnected(),
          ],
        ),
      ),
      //   ),
      // ),
    );
  }
}
