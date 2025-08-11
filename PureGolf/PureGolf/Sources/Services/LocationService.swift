import Foundation
import CoreLocation
import UIKit

@MainActor
final class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()

    private let manager = CLLocationManager()

    @Published var authorization: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    @Published var isPrecise: Bool = true

    private let precisePurposeKey = "NearbyCourses"

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
    }

    // MARK: Permission
    func requestWhenInUse() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        manager.requestWhenInUseAuthorization()
    }

    // MARK: Location
    func requestOneShotLocation() {
        manager.requestLocation()
    }

    func start() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }

    func requestTemporaryPreciseIfNeeded() async {
        guard #available(iOS 14.0, *) else { return }
        if manager.accuracyAuthorization != .fullAccuracy {
            try? await manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: precisePurposeKey)
        }
        isPrecise = (manager.accuracyAuthorization == .fullAccuracy)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorization = manager.authorizationStatus
            if self.authorization == .authorizedWhenInUse || self.authorization == .authorizedAlways {
                if #available(iOS 14.0, *) {
                    self.isPrecise = (manager.accuracyAuthorization == .fullAccuracy)
                }
                self.start()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        Task { @MainActor in
            self.lastLocation = loc
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Swallow benign errors
    }
}
