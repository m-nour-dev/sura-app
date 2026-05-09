package com.sura.app.sura_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class AdhanService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private val CHANNEL_ID = "adhan_foreground"
    private val NOTIF_ID = 1001

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action == "STOP_ADHAN") {
            stopAdhan()
            stopSelf()
            return START_NOT_STICKY
        }
        startForeground(NOTIF_ID, createNotification())
        playAdhan(intent?.getStringExtra("sound") ?: "adhan_egypt")
        return START_STICKY
    }

    private fun playAdhan(soundName: String) {
        val resId = resources.getIdentifier(soundName, "raw", packageName)
        if (resId == 0) {
             stopSelf()
             return
        }
        mediaPlayer = MediaPlayer.create(this, resId)
        mediaPlayer?.setOnCompletionListener {
            stopSelf()
        }
        mediaPlayer?.start()
    }

    private fun stopAdhan() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
    }

    private fun createNotification(): Notification {
        createChannel()
        val stopIntent = Intent(this, AdhanService::class.java).apply { action = "STOP_ADHAN" }
        val stopPendingIntent = PendingIntent.getService(this, 0, stopIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("تشغيل الأذان")
            .setContentText("يتم الآن تشغيل الأذان. اضغط لإيقافه.")
            .setSmallIcon(R.drawable.ic_notification)
            .addAction(R.drawable.ic_stop, "إيقاف الأذان", stopPendingIntent)
            .setOngoing(true)
            .build()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, "تشغيل الأذان", NotificationManager.IMPORTANCE_HIGH)
            channel.description = "تشغيل الأذان في المقدمة"
            channel.setSound(null, AudioAttributes.Builder().build())
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        stopAdhan()
        super.onDestroy()
    }
}

class AdhanReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val serviceIntent = Intent(context, AdhanService::class.java)
        serviceIntent.putExtra("sound", intent.getStringExtra("sound") ?: "adhan_egypt")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}

