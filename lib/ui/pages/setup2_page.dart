part of 'pages.dart';

class Setup2Page extends StatefulWidget {
  final User user;
  const Setup2Page({required this.user, Key? key}) : super(key: key);

  @override
  State<Setup2Page> createState() => _Setup2PageState();
}

class _Setup2PageState extends State<Setup2Page> {
  final _deviceId = TextEditingController();

  @override
  void dispose() {
    _deviceId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                height: 45.h,
                width: 343.w,
                child: TextFormField(
                  controller: _deviceId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                      borderSide:
                          BorderSide(width: 0.2, color: borderInputColor),
                    ),
                    hintText: "ID Perangkat",
                    hintStyle:
                        TextStyle(fontSize: 14.sp, color: textInputColor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Masukkan ID perangkat yang terdapat pada kendaraan",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: warningTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                  width: 343.w,
                  height: 40.h,
                  child: ElevatedButton(
                      onPressed: () async {
                        await saveDeviceId(_deviceId.text);

                        setState(() {
                          DataService.deviceId = _deviceId.text;
                        });
                        context
                            .read<PageBloc>()
                            .add(GoToSetupPage(widget.user));
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ),
                      child: Text(
                        "Selesai",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ))),
            ],
          ),
        ),
      ),
    ));
  }
}
