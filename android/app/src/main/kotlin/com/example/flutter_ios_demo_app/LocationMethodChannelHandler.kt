package com.example.flutter_ios_demo_app

import androidx.core.app.ActivityCompat
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class LocationMethodChannelHandler(private val activity: MainActivity) {
    private val locationPermissionUtils = activity.locationPermissionUtils

    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "requestLocationPermission" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (locationPermissionUtils.checkLocationPermission()) {
                        activity.startService(activity.service)
                    } else {
                        requestLocationPermissions()
                    }
                } else {
                    activity.startService(activity.service)
                }

                result.success(null)
            }

//            "stopLocationService" -> {
//                activity.stopService(activity.service)
//                result.success(null)
//            }



            else -> {
                result.notImplemented()
            }
        }
    }

    private fun requestLocationPermissions() {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(
                android.Manifest.permission.ACCESS_COARSE_LOCATION,
                android.Manifest.permission.ACCESS_FINE_LOCATION
            ),
            10
        )
    }
}