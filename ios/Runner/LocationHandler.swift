import Flutter
import CoreLocation

class LocationHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private var eventSink: FlutterEventSink?
    private let methodChannel: FlutterMethodChannel
    private let locationeventhandler: LocationEventHandler
    private var locationManager: CLLocationManager?



    init(methodChannel: FlutterMethodChannel, locationeventhandler: LocationEventHandler) {
        self.methodChannel = methodChannel
        self.locationeventhandler = locationeventhandler
        super.init()

        print("LocationHandler initialized")
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        print("Listening for location updates")
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        print("Cancelled location updates")
        return nil
    }

    func requestLocationPermission(result: @escaping FlutterResult) {
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        DispatchQueue.global(qos: .background).async {
            let servicesEnabled = CLLocationManager.locationServicesEnabled()

            DispatchQueue.main.async {
                if servicesEnabled {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined:
                        self.locationManager?.requestWhenInUseAuthorization()
                    case .denied, .restricted:
                        result(false)
                    case .authorizedAlways, .authorizedWhenInUse:
                        result(true)
                    @unknown default:
                        result(false)
                    }
                } else {
                    result(false)
                }
            }
        }
    }

    func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
        print("Started location updates")
    }

    func stopLocationUpdates() {
        locationManager?.stopUpdatingLocation()
        print("Stopped location updates")
    }
     


    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            methodChannel.invokeMethod("locationPermissionGranted", arguments: true)
            print("Location authorization granted")
        case .denied, .restricted:
            methodChannel.invokeMethod("locationPermissionGranted", arguments: false)
            print("Location authorization denied")
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            print("Location pass->: \(location.coordinate.latitude)")

            locationeventhandler.sendLocationUpdate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    

}
