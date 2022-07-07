part of 'page_bloc.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

class GoToLoginPage extends PageEvent {}

class GoToRegisterPage extends PageEvent {}

class GoToHomePage extends PageEvent {
  final User user;
  final int pageIndex;
  const GoToHomePage(this.user, {this.pageIndex = 0});
}

class GoToNotificationPage extends PageEvent {
  final List<NotificationModel?>? notifications;

  const GoToNotificationPage(this.notifications);
}

class GoToSetupPage extends PageEvent {
  final User user;
  const GoToSetupPage(this.user);
}

class GoToSetup2Page extends PageEvent {
  final User user;
  const GoToSetup2Page(this.user);
}
