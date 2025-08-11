import Foundation
import CoreLocation

struct Course: Identifiable, Codable, Hashable {
    var id: UUID = .init()
    var name: String
    var city: String
    var state: String
    var par: Int
    var latitude: Double
    var longitude: Double
    var blurb: String
    var imageURL: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct FeedItem: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subtitle: String
}

enum AppError: Error, LocalizedError {
    case locationDenied
    case locationRestricted
    case locationUnavailable
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .locationDenied: return "Location permission is denied."
        case .locationRestricted: return "Location services are restricted."
        case .locationUnavailable: return "Could not determine your location."
        case .unknown(let s): return s
        }
    }
}
