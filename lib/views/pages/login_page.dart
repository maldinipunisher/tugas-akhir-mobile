part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordReveal = false;
  bool isTimeout = true;
  int timeout = 10;

  @override
  void initState() {
    isTimeout = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white.withOpacity(0.5),
          statusBarIconBrightness: Brightness.dark),
    );
    return WillPopScope(
      onWillPop: () async {
        if (prevPage != null) {
          BlocProvider.of<PageBloc>(context).add(prevPage!);
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45.h,
                    ),
                    Image.asset("assets/images/register.png"),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Masuk",
                          style: TextStyle(fontSize: 24.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      height: 45.h,
                      width: 343.w,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide:
                                BorderSide(width: 0.2, color: borderInputColor),
                          ),
                          hintText: "Email",
                          hintStyle:
                              TextStyle(fontSize: 14.sp, color: textInputColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      height: 45.h,
                      width: 343.w,
                      child: TextFormField(
                        obscureText: !isPasswordReveal,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide:
                                BorderSide(width: 0.2, color: borderInputColor),
                          ),
                          hintText: "Kata sandi",
                          hintStyle:
                              TextStyle(fontSize: 14.sp, color: textInputColor),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordReveal = !isPasswordReveal;
                              });
                            },
                            child: Icon(
                              (!isPasswordReveal)
                                  ? Ionicons.eye
                                  : Ionicons.eye_off,
                              color: darkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Belum punya akun?",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            prevPage = GoToLoginPage();

                            BlocProvider.of<PageBloc>(context)
                                .add(GoToRegisterPage());
                          },
                          child: Text(
                            " Daftar",
                            style:
                                TextStyle(fontSize: 14.sp, color: accentColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 33.h,
                    ),
                    if (!isTimeout)
                      SizedBox(
                        width: 343.w,
                        height: 40.h,
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isTimeout = true;
                              });
                              Timer timer =
                                  Timer(Duration(seconds: timeout), () {
                                setState(() {
                                  isTimeout = false;
                                });
                              });
                              try {
                                final user = await AuthService.login(
                                    _emailController.text,
                                    _passwordController.text);

                                prevPage = null;
                                timer.cancel();
                                // BlocProvider.of<PageBloc>(context)
                                //     .add(GoToHomePage(user));
                                context
                                    .read<PageBloc>()
                                    .add(GoToSetup2Page(user));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Timer(const Duration(seconds: 1), () {
                                    setState(() {
                                      isTimeout = false;
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "User tidak ditemukan, periksa email/password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                          label: "oke",
                                          textColor: Colors.white,
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar(
                                                    reason: SnackBarClosedReason
                                                        .dismiss);
                                          }),
                                      backgroundColor: accent1Color,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                            ),
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                      ),
                    if (isTimeout) SpinKitRing(color: accent1Color)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
