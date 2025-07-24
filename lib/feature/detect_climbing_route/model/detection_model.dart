class Detection {
  final double x;
  final double y;
  final double w;
  final double h;
  final double confidence;
  final int classIndex;

  Detection({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.confidence,
    required this.classIndex,
  });
}

List<Detection> processModelOutput(
  List<List<double>> result,
  int imageWidth,
  int imageHeight, {
  double threshold = 0.4,
}) {
  return result
      .where((pred) => pred[4] > threshold)
      .map(
        (pred) => Detection(
          x: pred[0],
          y: pred[1],
          w: pred[2],
          h: pred[3],
          confidence: pred[4],
          classIndex: pred[5].toInt(),
        ),
      )
      .toList();
}
