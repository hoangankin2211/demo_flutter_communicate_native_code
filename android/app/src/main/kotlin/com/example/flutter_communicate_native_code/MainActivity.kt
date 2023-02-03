package com.example.flutter_communicate_native_code
import android.Manifest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.LocationServices

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sample.flutter.dev/methodChannel";
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
                call,
                result->
            when (call.method) {
                "getBatteryLevel" -> {
                    handleGetBatteryCall(result)
                }
                "getCurrentLocation" -> {
                    handleGetCurrentPosition(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun handleGetCurrentPosition(result:MethodChannel.Result){
        val location = getCurrentLocation();
        result.success(location);
    }

    private fun getCurrentLocation():String{
        var result = "Can not get the current position";
        val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return "Can not get the current position";
        }
        fusedLocationClient.lastLocation
            .addOnSuccessListener { location->
                if (location != null) {
                    result = "Latitude: " + location.latitude.toString() +  "\nLongitude: " + location.longitude.toString()
                }
            }
        return result;
    }


    private fun handleGetBatteryCall(result:MethodChannel.Result){
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
            result.success(batteryLevel)
        } else {
            result.error("UNAVAILABLE", "Battery level not available.", null)
        }
    }

    private fun getBatteryLevel():Int{
        var batteryLevel:Int = 0

        batteryLevel = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }else{
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }
}
