part of 'pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool isPasswordReveal = false;
  bool isPasswordConfirmationReveal = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
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
                          "Daftar",
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide:
                                BorderSide(width: 0.2, color: borderInputColor),
                          ),
                          hintText: "Nama",
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
                    SizedBox(
                      height: 45.h,
                      width: 343.w,
                      child: TextFormField(
                        obscureText: !isPasswordConfirmationReveal,
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide:
                                BorderSide(width: 0.2, color: borderInputColor),
                          ),
                          hintText: "Konfirmasi kata sandi",
                          hintStyle:
                              TextStyle(fontSize: 14.sp, color: textInputColor),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordConfirmationReveal =
                                    !isPasswordConfirmationReveal;
                              });
                            },
                            child: Icon(
                              (!isPasswordConfirmationReveal)
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
                          "Sudah punya akun?",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            prevPage = GoToRegisterPage();
                            BlocProvider.of<PageBloc>(context)
                                .add(GoToLoginPage());
                          },
                          child: Text(
                            " Masuk",
                            style:
                                TextStyle(fontSize: 14.sp, color: accentColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 33.h,
                    ),
                    SizedBox(
                      width: 343.w,
                      height: 40.h,
                      child: ElevatedButton(
                          onPressed: () async {
                            if ((EmailValidator.validate(
                                    _emailController.text) &&
                                (_passwordController.text ==
                                    _passwordConfirmationController.text))) {
                              final user = await AuthService.register(
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text)
                                  .onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
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
                                return null;
                              });
                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Pembuatan akun baru berhasil!",
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
                                context.read<PageBloc>().add(GoToLoginPage());
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Email tidak valid atau password tidak sama!",
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
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                          ),
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                    )
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
