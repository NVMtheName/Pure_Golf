import Foundation
import CoreLocation

enum CourseService {
    /// Returns courses sorted by distance from the given coordinate.
    static func nearbyCourses(from coordinate: CLLocationCoordinate2D, limit: Int = 20) -> [(course: Course, distanceMiles: Double)] {
        let origin = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let mapped = MockData.courses.map { c -> (Course, Double) in
            let loc = CLLocation(latitude: c.latitude, longitude: c.longitude)
            let meters = origin.distance(from: loc)
            let miles = meters / 1609.344
            return (c, miles)
        }
        .sorted { $0.1 < $1.1 }

        if limit > 0 && mapped.count > limit {
            return Array(mapped.prefix(limit)).map { ($0.0, $0.1) }
        }
        return mapped.map { ($0.0, $0.1) }
    }
}
