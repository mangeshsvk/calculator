part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object> get props => [];
}
class AppInitial extends AppState {}

class AppOnLoadState extends AppState{
  final bool isOnline;
  final bool isOutputCurrencyAvailable;
  const AppOnLoadState({required this.isOnline,required this.isOutputCurrencyAvailable,});

  @override
  List<Object> get props => [isOnline,isOutputCurrencyAvailable];
}

class AppLoadingState extends AppState{
  const AppLoadingState();
}
