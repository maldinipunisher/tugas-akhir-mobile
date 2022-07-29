part of 'pages.dart';

class HomePage extends StatefulWidget {
  final User user;
  final Arduino? arduino;
  const HomePage({Key? key, required this.user, required this.arduino})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late bool isAlarmOn;
  late bool isLockOn;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      DataService.setTokenApp(token: token);
    });
    // isAlarmOn = (widget.arduino == null)
    //     ? false
    //     : (widget.arduino!.alarm == "on")
    //         ? true
    //         : false;

    isLockOn = (widget.arduino == null)
        ? false
        : (widget.arduino!.lock == "on")
            ? true
            : false;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.arduino!.alarm);
    return BlocSelector<NotificationBloc, NotificationState, bool>(
      selector: (state) {
        return state.newNotification;
      },
      builder: (context, newNotification) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white.withOpacity(0.5),
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            // leadingWidth: 502.w,
            title: (widget.arduino != null && widget.arduino!.status == "on")
                ? Row(
                    children: [
                      SizedBox(width: 31.w),
                      Text(
                        "Status: ",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      Text(
                        "tersambung",
                        style:
                            TextStyle(color: successTextColor, fontSize: 14.sp),
                      )
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(width: 31.w),
                      Text(
                        "Status: ",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      Text(
                        "terputus",
                        style:
                            TextStyle(color: warningTextColor, fontSize: 14.sp),
                      )
                    ],
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  prevPage = GoToHomePage(widget.user, pageIndex: 0);
                  context.read<NotificationBloc>().add(ReadNotification());
                  context
                      .read<PageBloc>()
                      .add(GoToNotificationPage(widget.arduino!.notifications));
                },
                icon: Icon(Ionicons.notifications,
                    color:
                        (newNotification) ? warningTextColor : greyTextColor),
              ),
            ],
          ),
          body:
              // RefreshIndicator(
              //   color: accent1Color,
              //   onRefresh: () async {
              //     setState(() {});
              //   },
              //   child:
              NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat datang,\n${widget.user.displayName}",
                            style: TextStyle(
                              fontSize: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 27.h,
                      ),
                      SizedBox(
                        height: 165.h,
                        width: 307.h,
                        child: Image.asset("assets/images/home.png"),
                      ),
                      SizedBox(
                        height: 64.h,
                      ),
                      if (widget.arduino != null &&
                          (widget.arduino!.status == "on"))
                        home(widget.arduino!),
                      if (widget.arduino == null ||
                          (widget.arduino!.status == "off"))
                        notConnected(),
                    ],
                  ),
                ),
              ],
              //   ),
            ),
          ),
        );
      },
    );
  }

  Widget home(Arduino arduino) => Column(
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 25.w),
          //   height: 45.h,
          //   width: 319.w,
          //   decoration: BoxDecoration(
          //     color: accent1Color,
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.circular(46.r),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           Icon(
          //             Ionicons.alarm_outline,
          //             color: Colors.white,
          //             size: 32.sp,
          //           ),
          //           SizedBox(
          //             width: 4.w,
          //           ),
          //           Text(
          //             "Alarm",
          //             style: TextStyle(fontSize: 14.sp, color: Colors.white),
          //           ),
          //         ],
          //       ),
          //       Switch(
          //           trackColor: MaterialStateProperty.all(
          //               Colors.white.withOpacity(0.5)),
          //           inactiveThumbColor: Colors.white,
          //           activeColor: accent2Color,
          //           value: (widget.arduino == null)
          //               ? false
          //               : (widget.arduino!.alarm == "on")
          //                   ? true
          //                   : false,
          //           onChanged: (alarm) async {
          //             setState(() {
          //               widget.arduino!.alarm = (alarm) ? "on" : "off";
          //             });
          //             final result = await DataService.update(widget.arduino!);
          //             if (!result) {
          //               setState(() {
          //                 widget.arduino!.alarm = "off";
          //               });
          //             }
          //           })
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 18.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            height: 45.h,
            width: 319.w,
            decoration: BoxDecoration(
              color: accent1Color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(46.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Ionicons.lock_closed,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "Penguncian",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ],
                ),
                Switch(
                    trackColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.5)),
                    inactiveThumbColor: Colors.white,
                    activeColor: accent2Color,
                    value: (widget.arduino == null)
                        ? false
                        : (widget.arduino!.lock == "on")
                            ? true
                            : false,
                    onChanged: (lock) async {
                      setState(() {
                        widget.arduino!.lock = (lock) ? "on" : "off";
                      });
                      final result = await DataService.update(widget.arduino!);
                      if (!result) {
                        setState(() {
                          widget.arduino!.lock = "off";
                        });
                      }
                    })
              ],
            ),
          ),
        ],
      );
}
