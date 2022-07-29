part of 'pages.dart';

class SetupPage extends StatelessWidget {
  final User user;
  const SetupPage({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SetupPageSuccess(user: user);
  }
}

class SetupPageSuccess extends StatefulWidget {
  final User user;

  const SetupPageSuccess({required this.user, Key? key}) : super(key: key);

  @override
  _SetupPageSuccessState createState() => _SetupPageSuccessState();
}

class _SetupPageSuccessState extends State<SetupPageSuccess>
    with WidgetsBindingObserver {
  double turns = 0.0;
  late Timer _timer;
  int _timeout = 30; //5 seconds
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _timer = timer;
          });
          changeRotation();
        });
        break;
      case AppLifecycleState.inactive:
        _timer.cancel();
        break;
      case AppLifecycleState.paused:
        _timer.cancel();
        break;
      case AppLifecycleState.detached:
        _timer.cancel();
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timer = timer;
        _timeout--;
      });
      changeRotation();
    });

    super.initState();
  }

  void changeRotation() {
    setState(() {
      turns += 1 / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );

    return (_timeout > 0)
        ? StreamBuilder<DocumentSnapshot>(
            stream: DataService.getStatus,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData &&
                    snapshot.data!.data() != null &&
                    (snapshot.data!.data() as Map).isNotEmpty) {
                  context.read<PageBloc>().add(GoToHomePage(widget.user));
                }
              }
              return Scaffold(
                body: SizedBox(
                  height: ScreenUtil().screenHeight,
                  width: ScreenUtil().screenWidth,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedRotation(
                          duration: const Duration(seconds: 1),
                          turns: turns,
                          child: Icon(
                            Ionicons.cog,
                            size: 150.w,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "Mengonfigurasi perangkat pertama kali",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Text(
                          "proses mungkin akan memakan\nwaktu beberapa menit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp, color: warningTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
        : SetupPageFailed(user: widget.user);
  }
}

class SetupPageFailed extends StatelessWidget {
  final User user;
  const SetupPageFailed({required this.user, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );

    return Scaffold(
      body: SizedBox(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Ionicons.alert_circle_outline,
                size: 100.w,
                color: warningTextColor,
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Tidak dapat menyambung ke perangkat",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                "harap pastikan perangkat terhubung\ndan terpasang dengan benar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: 150.w,
                height: 30.h,
                child: ElevatedButton(
                    onPressed: () {
                      context.read<PageBloc>().add(GoToSetupPage(user));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                    child: Text(
                      "Coba Lagi",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
