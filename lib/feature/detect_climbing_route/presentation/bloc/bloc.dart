import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../model/detection_model.dart';
part 'event.dart';
part 'state.dart';

class WallDetectionBloc extends Bloc<WallDetectionEvent, WallDetectionState> {
  late Interpreter _interpreter;
  final imagePicker = ImagePicker();
  final modelPath = 'assets/models/best_float16.tflite';

  WallDetectionBloc() : super(const WallDetectionState()) {
    on<LoadModelEvent>(_onLoadModel);
    on<PickImageEvent>(_onPickImage);
    on<RunModelOnImageEvent>(_onRunModel);
    on<ToggleBoxSelectionEvent>(_onToggleSelection);
    on<SaveSelectedBoxesEvent>((event, emit) async {
      final currentState = state;
      if (currentState.imageFile == null) return;

      try {
        final bytes = await currentState.imageFile!.readAsBytes();
        final originalImage = img.decodeImage(bytes);
        if (originalImage == null) return;
        final editedImage = img.copyResize(
          originalImage,
          width: currentState.imageWidth,
          height: currentState.imageHeight,
        );

        for (final index in currentState.selectedBoxIndices) {
          final box = currentState.detections[index];

          final left = ((box.x - box.w / 2) * currentState.imageWidth).toInt();
          final top = ((box.y - box.h / 2) * currentState.imageHeight).toInt();
          final right = ((box.x + box.w / 2) * currentState.imageWidth).toInt();
          final bottom = ((box.y + box.h / 2) * currentState.imageHeight)
              .toInt();

          img.fillRect(
            editedImage,
            left,
            top,
            right,
            bottom,
            img.getColor(0, 255, 0, 102),
          );
        }
        final editedBytes = img.encodeJpg(editedImage);

        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/wall_detection_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(path);
        await file.writeAsBytes(editedBytes);
        await GallerySaver.saveImage(file.path);
        Fluttertoast.showToast(msg: "Image Saved Sucessfully");
      } catch (e) {
        debugPrint('Save error: $e');
      }
    });
  }

  Future<void> _onLoadModel(
    LoadModelEvent event,
    Emitter<WallDetectionState> emit,
  ) async {
    _interpreter = await Interpreter.fromAsset(modelPath);
    emit(state.copyWith(isModelLoaded: true));
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<WallDetectionState> emit,
  ) async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return;

    emit(
      state.copyWith(
        imageFile: file,
        imageWidth: decoded.width,
        imageHeight: decoded.height,
        selectedBoxIndices: {},
      ),
    );

    add(RunModelOnImageEvent(file));
  }

  Future<void> _onRunModel(
    RunModelOnImageEvent event,
    Emitter<WallDetectionState> emit,
  ) async {
    try {
      final bytes = await event.imageFile.readAsBytes();
      final image = img.decodeImage(bytes)!;
      final resized = img.copyResize(image, width: 640, height: 640);

      final input = Float32List(640 * 640 * 3);
      int i = 0;
      for (int y = 0; y < 640; y++) {
        for (int x = 0; x < 640; x++) {
          final pixel = resized.getPixel(x, y);
          input[i++] = ((pixel >> 16) & 0xFF) / 255.0;
          input[i++] = ((pixel >> 8) & 0xFF) / 255.0;
          input[i++] = (pixel & 0xFF) / 255.0;
        }
      }

      final inputTensor = input.buffer.asFloat32List().reshape([
        1,
        640,
        640,
        3,
      ]);
      final output = List.generate(
        1,
        (_) => List.generate(6, (_) => List.filled(8400, 0.0)),
      );

      _interpreter.run(inputTensor, output);

      final rawOutput = output[0];
      final transposedOutput = List.generate(
        8400,
        (i) => List.generate(6, (j) => rawOutput[j][i]),
      );

      final detections = _removeNearDuplicates(
        processModelOutput(
          transposedOutput,
          state.imageWidth,
          state.imageHeight,
        ),
        0.03,
      );

      emit(state.copyWith(detections: detections));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onToggleSelection(
    ToggleBoxSelectionEvent event,
    Emitter<WallDetectionState> emit,
  ) {
    final context = event.tapPosition;
    final selected = Set<int>.from(state.selectedBoxIndices);

    for (int i = 0; i < state.detections.length; i++) {
      final det = state.detections[i];
      final left = (det.x - det.w / 2) * state.imageWidth;
      final top = (det.y - det.h / 2) * state.imageHeight;
      final right = (det.x + det.w / 2) * state.imageWidth;
      final bottom = (det.y + det.h / 2) * state.imageHeight;
      final rect = Rect.fromLTRB(left, top, right, bottom);

      if (rect.contains(context)) {
        selected.contains(i) ? selected.remove(i) : selected.add(i);
        break;
      }
    }

    emit(state.copyWith(selectedBoxIndices: selected));
  }

  List<Detection> _removeNearDuplicates(
    List<Detection> detections,
    double threshold,
  ) {
    final result = <Detection>[];
    for (final det in detections) {
      final isDuplicate = result.any(
        (existing) =>
            (det.x - existing.x).abs() < threshold &&
            (det.y - existing.y).abs() < threshold &&
            (det.w - existing.w).abs() < threshold &&
            (det.h - existing.h).abs() < threshold,
      );
      if (!isDuplicate) result.add(det);
    }
    return result;
  }
}
