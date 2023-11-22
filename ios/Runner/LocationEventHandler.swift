//
//  LocationEventHandler.swift
//  Runner
//
//  Created by sunil singh on 22/11/23.
//

class LocationEventHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    // Set up the event channel
    func setUp(withMessenger messenger: FlutterBinaryMessenger) {
        let eventChannel = FlutterEventChannel(name: "com.location.eventchannel", binaryMessenger: messenger)
        eventChannel.setStreamHandler(self)
    }

    // Handle when the Flutter side starts listening
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    // Handle when the Flutter side stops listening
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    // Send a location update through the event channel
    func sendLocationUpdate(latitude: Double, longitude: Double) {
        eventSink?(["latitude": latitude, "longitude": longitude])
    }
}
