import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../widgets/bounding_box_painter.dart';

class WallDetectionView extends StatelessWidget {
  final GlobalKey imagePaintKey = GlobalKey();

  WallDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WallDetectionBloc, WallDetectionState>(
        builder: (context, state) {
          if (state.imageFile == null) {
            return const Center(child: Text('Pick an image to detect grips'));
          }

          return Center(
            child: RepaintBoundary(
              key: imagePaintKey,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: state.imageWidth.toDouble(),
                  height: state.imageHeight.toDouble(),
                  child: Stack(
                    children: [
                      Image.file(
                        state.imageFile!,
                        width: state.imageWidth.toDouble(),
                        height: state.imageHeight.toDouble(),
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTapDown: (details) =>
                              context.read<WallDetectionBloc>().add(
                                ToggleBoxSelectionEvent(details.localPosition),
                              ),
                          child: CustomPaint(
                            painter: BoundingBoxPainter(
                              state.detections,
                              state.imageWidth,
                              state.imageHeight,
                              state.selectedBoxIndices,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<WallDetectionBloc>().add(SaveSelectedBoxesEvent());
            },
            child: const Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<WallDetectionBloc>().add(PickImageEvent());
            },
            child: const Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }
}
