part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object?> get props => [];
}

class AppOnLoadEvent extends AppEvent{}
class AppOnlineEvent extends AppEvent{}
class AppOfflineEvent extends AppEvent{}