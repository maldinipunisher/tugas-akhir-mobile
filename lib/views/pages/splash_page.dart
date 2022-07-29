part of 'pages.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Mobile Controller",
          style: TextStyle(
              fontSize: 24.sp,
              color: accent1Color,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
