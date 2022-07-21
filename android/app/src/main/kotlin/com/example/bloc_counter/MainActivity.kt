package com.example.bloc_counter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.Log
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import android.content.Intent
import android.content.Context
import android.app.PendingIntent
import android.app.NotificationManager
import android.app.NotificationChannel
import android.media.RingtoneManager
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "yen.flutter.intro/notification"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler {
                call,
                result ->
            if (call.method == "getNotfication") {
                sendTimerNotification(call.argument("title"), call.argument("detail"))
                result.success("發送通知")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendTimerNotification(title: String?, messageBody: String?) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val pendingIntent: PendingIntent
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_MUTABLE)
            Log.d("tag", "FLAG_MUTABLE")
        } else {
            pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT)
            Log.d("tag", "FLAG_ONE_SHOT")
        }

        val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val notificationBuilder =
                NotificationCompat.Builder(this, "timer")
                        .setSmallIcon(R.drawable.launch_background)
                        .setContentTitle(title)
                        .setContentText(messageBody)
                        .setAutoCancel(true)
                        .setSound(defaultSoundUri)
                        .setContentIntent(pendingIntent)

        val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                    NotificationChannel(
                            "timer",
                            "Channel human readable title",
                            NotificationManager.IMPORTANCE_HIGH
                    )
            notificationManager.createNotificationChannel(channel)
        }

        notificationManager.notify(0, notificationBuilder.build())
    }
}
