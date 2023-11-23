package com.example.flutter_ios_demo_app


import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe


class MainActivity : FlutterActivity() {
    companion object {
        private val METHOD_CHANNEL = "com.rocky.flutter_location" // Define your method channel name
        private val EVENT_CHANNEL = "com.location.eventchannel" // Define your event channel name
    }
    val locationStreamHandler = LocationStreamHandlers()
    var service: Intent? = null
    private var lastKnownLocation: LocationEvent? = null
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    val locationPermissionUtils by lazy { LocationPermissionUtils(this) }
    private val locationMethodChannelHandler by lazy { LocationMethodChannelHandler(this) }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Register Service
        service = Intent(this, LocationService::class.java)
        //Register service
        if (!EventBus.getDefault().isRegistered(this)) {
            //Register EventBus
            EventBus.getDefault().register(this)
        }

        // Register the MethodChannelHandler
        methodChannel = MethodChannel(flutterEngine?.dartExecutor!!.binaryMessenger, METHOD_CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            locationMethodChannelHandler.handleMethodCall(call, result)
        }

        // Register the EventChannel Hanlder
        eventChannel = EventChannel(flutterEngine!!.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel!!.setStreamHandler(locationStreamHandler) //inside oncreate

    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 10) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startService(service)
            } else {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(
                        (context as Activity),
                        android.Manifest.permission.ACCESS_FINE_LOCATION
                    )
                ) {
                    // If User Checked 'Don't Show Again' checkbox for runtime
                    // permission, then navigate user to Settings
                    locationPermissionUtils.navigateToAppSettings()
                }
                //code for deny
            }
        }
    }

    override fun startActivityForResult(intent: Intent?, requestCode: Int) {
        super.startActivityForResult(intent, requestCode)
        when (requestCode) {
            1001 -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if ( locationPermissionUtils.checkLocationPermission()) {
                    startService(service)
                } else {
                    requestPermissions(
                        arrayOf<String>(
                            android.Manifest.permission.ACCESS_COARSE_LOCATION,
                            android.Manifest.permission.ACCESS_FINE_LOCATION,
                            android.Manifest.permission.ACCESS_BACKGROUND_LOCATION
                        ), 10
                    )
                }
            }

            else -> {}
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopService(service)
        if (EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().unregister(this)
        }
    }

    @Subscribe
    fun receiveLocationEvent(locationEvent: LocationEvent) {  //getting update from service
        lastKnownLocation = locationEvent
        //pass location to event channels
        locationStreamHandler.sendLocationToFLutter(locationEvent)
    }

}