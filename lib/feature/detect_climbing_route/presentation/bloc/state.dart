part of 'bloc.dart';

class WallDetectionState extends Equatable {
  final File? imageFile;
  final List<Detection> detections;
  final Set<int> selectedBoxIndices;
  final int imageWidth;
  final int imageHeight;
  final bool isModelLoaded;
  final String? error;

  const WallDetectionState({
    this.imageFile,
    this.detections = const [],
    this.selectedBoxIndices = const {},
    this.imageWidth = 0,
    this.imageHeight = 0,
    this.isModelLoaded = false,
    this.error,
  });

  WallDetectionState copyWith({
    File? imageFile,
    List<Detection>? detections,
    Set<int>? selectedBoxIndices,
    int? imageWidth,
    int? imageHeight,
    bool? isModelLoaded,
    String? error,
  }) {
    return WallDetectionState(
      imageFile: imageFile ?? this.imageFile,
      detections: detections ?? this.detections,
      selectedBoxIndices: selectedBoxIndices ?? this.selectedBoxIndices,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    imageFile,
    detections,
    selectedBoxIndices,
    imageWidth,
    imageHeight,
    isModelLoaded,
    error,
  ];
}
