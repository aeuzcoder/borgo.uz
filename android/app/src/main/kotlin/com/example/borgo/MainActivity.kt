package uz.borgo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.dart.DartExecutor


class MainActivity: FlutterActivity() {
    override fun onStart() {
        super.onStart()
        flutterEngine?.dartExecutor?.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
    }
}