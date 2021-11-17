package com.example.woman_safety
import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.startActivity
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

lateinit var results: MethodChannel.Result
var locationManager: LocationManager? = null
private lateinit var channel: MethodChannel
class MainActivity() : FlutterActivity(){
       private val CHANNEL:String = "com.example.woman_safety/sense"
    val start= "start"
    val stop= "stop"
    var name=""
    var list = listOf<String>()



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.FOREGROUND_SERVICE), PackageManager.PERMISSION_GRANTED)

        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager?
        LocalBroadcastManager.getInstance(this).registerReceiver(
                mMessageReceiver,  IntentFilter("event_shake"));
    }



    override fun onDestroy() {
       LocalBroadcastManager.getInstance(this).unregisterReceiver(
                mMessageReceiver);
        super.onDestroy()

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == start) {
               results=result
                name = call.argument("name")!!
                var data:String=call.argument("data")!!

                result.success("service started")
                val intent = Intent(this, MyService::class.java)
                intent.putExtra("name",name)
               intent.putExtra("data",data)
                startService(intent)
            }else {
                val intent = Intent(this, MyService::class.java)
                stopService(intent)
                result.success("service  aa stopped")
            }
        }
    }
    private val mMessageReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val message: String? = intent.getStringExtra("message")
            val intent = Intent(Intent.ACTION_DIAL)
            startActivity(intent);
            val serviceIntent = Intent(context, MyService::class.java)
            serviceIntent.putExtra("name",name)
            context.startService(serviceIntent)
        }
    }
}
