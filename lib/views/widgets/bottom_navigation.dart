part of 'widgets.dart';

class BottomNavigationWidget extends StatefulWidget {
  final PageController pageController;
  final int pageIndex;
  const BottomNavigationWidget({
    Key? key,
    required this.pageController,
    required this.pageIndex,
  }) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pageIndex = widget.pageIndex;
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: 40.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Material(
              child: Ink(
                width: ScreenUtil().screenWidth / 3,
                height: 40.h,
                color: (pageIndex == 0) ? accentColor : Colors.transparent,
                child: InkWell(
                  splashColor: accent1Color.withOpacity(0.4),
                  onTap: () {
                    if (pageIndex != 0) {
                      widget.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                      setState(() {
                        pageIndex = 0;
                      });
                    }
                  },
                  child: Icon(Ionicons.home,
                      color: (pageIndex == 0) ? Colors.white : darkColor,
                      size: 32.sp),
                ),
              ),
            ),
            Material(
              child: Ink(
                width: ScreenUtil().screenWidth / 3,
                height: 40.h,
                color: (pageIndex == 1) ? accentColor : Colors.transparent,
                child: InkWell(
                  splashColor: accent1Color.withOpacity(0.4),
                  onTap: () {
                    if (pageIndex != 1) {
                      setState(() {
                        widget.pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                        pageIndex = 1;
                      });
                    }
                  },
                  child: Icon(Ionicons.location_outline,
                      color: (pageIndex == 1) ? Colors.white : darkColor,
                      size: 32.sp),
                ),
              ),
            ),
            Material(
              child: Ink(
                width: ScreenUtil().screenWidth / 3,
                height: 40.h,
                color: (pageIndex == 2) ? accentColor : Colors.transparent,
                child: InkWell(
                  splashColor: accent1Color.withOpacity(0.4),
                  onTap: () {
                    if (pageIndex != 2) {
                      widget.pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                      setState(() {
                        pageIndex = 2;
                      });
                    }
                  },
                  child: Icon(Ionicons.stats_chart,
                      color: (pageIndex == 2) ? Colors.white : darkColor,
                      size: 32.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
