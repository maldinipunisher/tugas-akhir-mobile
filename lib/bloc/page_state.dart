part of 'page_bloc.dart';

abstract class PageState extends Equatable {
  const PageState();

  @override
  List<Object> get props => [];
}

class PageInitial extends PageState {}

class OnLoginPage extends PageState {}

class OnRegisterPage extends PageState {}

class OnNotificationPage extends PageState {
  final List<NotificationModel?>? notifications;

  const OnNotificationPage(this.notifications);
}

class OnSetupPage extends PageState {
  final User user;
  const OnSetupPage(this.user);
}

class OnSetup2Page extends PageState {
  final User user;
  const OnSetup2Page(this.user);
}

class OnHomePage extends PageState {
  final User user;
  final int pageIndex;
  const OnHomePage(this.user, {this.pageIndex = 0});
}
