import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/calc_theme.dart';
import '/viewmodels/blocs/app/app_bloc.dart';
import '/views/pages/calculator_page.dart';
import '/views/pages/picker_page.dart';
import '/views/utils/loading_widget.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/injector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Injector.init(
    appRunner: () =>
        runApp(
          const AppWrapper(),
        ),
  );
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => AppBloc()..add(AppOnLoadEvent())),
      ],
      child: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  AppMainState createState() => AppMainState();
}

class AppMainState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
          designSize: const Size(
            AppConsts.screenWidth,
            AppConsts.screenHeight,
          ),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: CalcThemes().calcWhiteTheme,
              home: child,
            );
          },
          child: BlocBuilder<AppBloc,AppState>(
           builder: (context,state){
             if (state is AppOnLoadState){
               if(state.isOutputCurrencyAvailable){
                 return const CalculatorPage();
               }
               else{
                 return  const PickerPage();
               }
             }
             else{
               return const Scaffold(
                 body: Center(child: LoadingView(),),
               );
             }
           }),
        );
  }
}
