part of 'bloc.dart';

abstract class WallDetectionEvent extends Equatable {
  const WallDetectionEvent();
}

class LoadModelEvent extends WallDetectionEvent {
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends WallDetectionEvent {
  @override
  List<Object?> get props => [];
}

class RunModelOnImageEvent extends WallDetectionEvent {
  final File imageFile;

  const RunModelOnImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class ToggleBoxSelectionEvent extends WallDetectionEvent {
  final Offset tapPosition;

  const ToggleBoxSelectionEvent(this.tapPosition);

  @override
  List<Object?> get props => [tapPosition];
}

class SaveSelectedBoxesEvent extends WallDetectionEvent {
  @override
  List<Object?> get props => [];
}
