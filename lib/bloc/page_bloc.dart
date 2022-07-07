import 'package:bloc/bloc.dart';
import 'package:controller_mobile/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageInitial()) {
    on<GoToLoginPage>((event, emit) => emit(OnLoginPage()));
    on<GoToRegisterPage>((event, emit) => emit(OnRegisterPage()));
    on<GoToHomePage>((event, emit) =>
        emit(OnHomePage(event.user, pageIndex: event.pageIndex)));
    on<GoToNotificationPage>(
        (event, emit) => emit(OnNotificationPage(event.notifications)));
    on<GoToSetupPage>((event, emit) => emit(OnSetupPage(event.user)));
    on<GoToSetup2Page>((event, emit) => emit(OnSetup2Page(event.user)));
  }
}
