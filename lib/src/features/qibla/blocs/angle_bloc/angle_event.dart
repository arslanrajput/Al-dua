part of 'angle_bloc.dart';

abstract class AngleEvent extends Equatable {
  const AngleEvent();
}

class SetCompassHeading extends AngleEvent {
  final double heading;

  const SetCompassHeading(this.heading);

  @override
  List<Object> get props => [heading];
}

class NotifyFailure extends AngleEvent {
  @override
  List<Object> get props => [];
}
