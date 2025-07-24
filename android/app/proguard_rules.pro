# Required for TFLite GPU delegate (preserve these classes)
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }

# Optional: Suppress warnings
-dontwarn org.tensorflow.lite.gpu.**