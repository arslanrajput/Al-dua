import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vector_math/vector_math.dart' show radians;

part 'angle_event.dart';
part 'angle_state.dart';

class AngleBloc extends Bloc<AngleEvent, AngleState> {
  /// Qibla bearing in degrees (0 = north, clockwise).
  final double qiblaBearingDegrees;

  AngleBloc(this.qiblaBearingDegrees) : super(AngleInitial(0, 0)) {
    on<AngleEvent>((event, emit) {
      if (event is SetCompassHeading) {
        final dialRadians = -radians(event.heading);
        final qiblaRadians = radians(qiblaBearingDegrees);

        final delta = (state.radian - dialRadians).abs();
        if (delta > 0.008) {
          emit(
            AngleLoaded(
              angle: event.heading,
              radian: dialRadians,
              qiblaDirection: qiblaRadians,
            ),
          );
        }
      } else if (event is NotifyFailure) {
        emit(AngleFailed(0, 0));
      }
    });
  }
}
