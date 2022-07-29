part of 'pages.dart';

class Wrapper extends StatefulWidget {
  final User? user;

  const Wrapper({Key? key, required this.user}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((data) {
      firebaseMessagingForegroundHandler(data, context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      BlocProvider.of<PageBloc>(context).add(GoToLoginPage());
    } else {
      getDeviceId().then((_) {
        if (DataService.deviceId.isNotEmpty) {
          DataService.checkDeviceId().then((value) {
            if (value) {
              BlocProvider.of<PageBloc>(context)
                  .add(GoToHomePage(widget.user!));
            } else {
              context.read<PageBloc>().add(GoToSetupPage(widget.user!));
            }
          }).onError((error, stackTrace) {
            context.read<PageBloc>().add(GoToSetupPage(widget.user!));
          });
        } else {
          context.read<PageBloc>().add(GoToSetup2Page(widget.user!));
        }
      });
    }

    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (state is PageInitial)
              ? const SplashPage()
              : (state is OnRegisterPage)
                  ? const RegisterPage()
                  : (state is OnHomePage)
                      ? NavigationPage(
                          user: state.user,
                          deviceId: DataService.deviceId,
                          pageIndex: state.pageIndex,
                        )
                      : (state is OnNotificationPage)
                          ? NotificationPage(
                              notifications: state.notifications,
                            )
                          : (state is OnSetupPage)
                              ? SetupPage(user: state.user)
                              : (state is OnSetup2Page)
                                  ? Setup2Page(user: state.user)
                                  : const LoginPage(),
        );
      },
    );
  }
}
