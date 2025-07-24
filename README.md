# Flutter with Tensor Flow Lite

A Flutter app that detects climbing holds in images using a TensorFlow Lite model. This project demonstrates clean architecture, state management with Bloc, and custom UI overlays for ML-powered features.

---

## 🚀 Features

- Pick an image of a climbing wall from your gallery
- Run a machine learning model (on-device) to detect climbing holds
- See bounding boxes drawn over detected holds
- Tap boxes to select/deselect them
- Save the result with selected boxes highlighted to your gallery

---

## 🏗️ Architecture Overview

The app is organized into three main layers:

- **Model Layer:** Handles data structures and processing of raw ML model output (`lib/feature/detect_climbing_route/model/detection_model.dart`).
- **Bloc Layer:** Contains all business logic and state management using the Bloc pattern (`lib/feature/detect_climbing_route/presentation/bloc/`).
- **UI Layer:** Widgets and custom painters for displaying images, bounding boxes, and user interactions (`lib/feature/detect_climbing_route/presentation/view/`).

**Why this structure?**

- Keeps code maintainable and scalable
- Makes business logic testable and UI reactive
- Separates concerns for easier collaboration and extension

---

## 🧠 How It Works (Step-by-Step)

1. **User picks an image** → Bloc opens the image picker and decodes the image
2. **Model runs** → Bloc runs the TFLite model and processes the output into `Detection` objects
3. **UI displays image and boxes** → CustomPainter draws bounding boxes
4. **User taps boxes** → Bloc updates which boxes are selected
5. **User saves result** → Bloc draws selected boxes on the image and saves it to the gallery

---

## 📦 Key Packages Used

- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): State management
- [`tflite_flutter`](https://pub.dev/packages/tflite_flutter): On-device ML inference
- [`image_picker`](https://pub.dev/packages/image_picker): Pick images from gallery
- [`image`](https://pub.dev/packages/image): Image processing (drawing, resizing)
- [`gallery_saver_plus`](https://pub.dev/packages/gallery_saver_plus): Save images to gallery
- [`fluttertoast`](https://pub.dev/packages/fluttertoast): User notifications

---

## 🛠️ Getting Started

1. **Clone the repo:**
   ```sh
   git clone <your-repo-url>
   cd flutter_tflite_sample_app
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Add the TFLite model:**
   - Place your `.tflite` model file in `assets/models/` (already included: `best_float16.tflite`)
   - Ensure `pubspec.yaml` lists the model under `assets:`
4. **Run the app:**
   ```sh
   flutter run
   ```

---

## 📁 Project Structure

```
lib/
  main.dart
  feature/
    detect_climbing_route/
      model/
        detection_model.dart
      presentation/
        bloc/
          bloc.dart, event.dart, state.dart
        view/
          screens/
            detect_climbing_route_view.dart
          widgets/
            bounding_box_painter.dart
assets/
  models/
    best_float16.tflite
```

---

## 🤔 Extending the App

- Add support for more object types or detection classes
- Show detection confidence scores in the UI
- Allow users to edit or resize boxes
- Add loading indicators and better error handling
- Write tests for Bloc and widgets

---

## 🙌 Contributing

Pull requests and suggestions are welcome! If you find a bug or want to add a feature, open an issue or PR.

---

Happy climbing—and coding!
