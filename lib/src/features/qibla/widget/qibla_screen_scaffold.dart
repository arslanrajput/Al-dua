import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/constants.dart';
import '../../error/widget/failure_widget.dart';
import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../blocs/qibla_bloc/qibla_bloc.dart';
import '../theme/qibla_theme.dart';
import 'qibla_content.dart';

class QiblaScaffold extends StatefulWidget {
  const QiblaScaffold();

  @override
  State<QiblaScaffold> createState() => _QiblaScaffoldState();
}

class _QiblaScaffoldState extends State<QiblaScaffold> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<QiblaBloc>(context).add(
      RequestQiblahDirection(
        BlocProvider.of<LocationBloc>(context).state,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: HomeTheme.primaryText(context)),
      ),
      body: Container(
        decoration: QiblaTheme.screenGradient(context),
        child: SafeArea(
          child: BlocBuilder<QiblaBloc, QiblaState>(
            builder: (context, state) {
              Widget child;
              if (state is QiblaLoading) {
                child = const LoadingWidget();
              } else if (state is QiblaLoaded) {
                child = QiblaContent(qiblaBearing: state.direction);
              } else if (state is QiblaFailed) {
                child = FailureWidget(
                  state.failure,
                  () {
                    BlocProvider.of<LocationBloc>(context).add(
                      InitLocation(),
                    );
                  },
                  withAppbar: false,
                );
              } else {
                child = const SizedBox.shrink();
              }

              return AnimatedSwitcher(
                duration: kAnimationDuration,
                reverseDuration: Duration.zero,
                switchInCurve: kAnimationCurve,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
