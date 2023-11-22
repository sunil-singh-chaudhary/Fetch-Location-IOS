import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var locationHandler: LocationHandler?
    private let locationeventHandler = LocationEventHandler()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        // Initialize the method channel
        let methodChannel = FlutterMethodChannel(name: "com.rocky.flutter_location", binaryMessenger: controller.binaryMessenger)
        
        locationeventHandler.setUp(withMessenger: controller.binaryMessenger) // TODO: SetUp is important otherwise error throw  MissingPluginException(No implementation found for method listen on channel


    
        // Initialize location handler
        locationHandler = LocationHandler(methodChannel: methodChannel, locationeventhandler: locationeventHandler)

        // Handle method channel calls
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "requestLocationPermission":
                self?.locationHandler?.requestLocationPermission(result: result)
                // Simulate continuous location updates
                self?.locationHandler?.startLocationUpdates()  //add this method here so can update

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
}
