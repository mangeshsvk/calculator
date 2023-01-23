import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/calc_colors.dart';

import '../../viewmodels/blocs/app/app_bloc.dart';

class OnlineStatusWidget extends StatelessWidget {
  const OnlineStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state is AppOnLoadState) {
        if (state.isOnline) {
          return  Text('Online Mode',style: Theme.of(context).textTheme.headline1!.copyWith(color: LightColors.appPrimaryColorDark),);
        } else {
          return  Text('Offline Mode',style: Theme.of(context).textTheme.headline1!.copyWith(color: LightColors.errorColor),);
        }
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
