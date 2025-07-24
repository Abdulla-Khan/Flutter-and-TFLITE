import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/detect_climbing_route/presentation/bloc/bloc.dart';
import 'feature/detect_climbing_route/presentation/view/screens/detect_climbing_route_view.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (_) => WallDetectionBloc()..add(LoadModelEvent()),
      child: WallDetectionView(),
    ),
  ),
);
