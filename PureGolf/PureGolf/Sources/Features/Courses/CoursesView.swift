import SwiftUI

// Local UI model for the Courses screen (renamed to avoid conflicts)
private struct NearbyCourse: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let city: String
    let distanceMiles: Double
    let imageName: String?   // Asset name in Assets.xcassets (optional)
}

// Fallback image if an asset is missing.
private struct CourseImage: View {
    let imageName: String?
    var body: some View {
        Group {
            if let name = imageName, let ui = UIImage(named: name) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [PGColors.card, PGColors.card.opacity(0.7)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: "photo")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(PGColors.subtext)
                }
            }
        }
        .frame(width: 72, height: 72)
        .clipped()
        .cornerRadius(12)
    }
}

struct CoursesView: View {
    // Mock nearby data (replace with real API later)
    private let nearby: [NearbyCourse] = [
        .init(name: "Pacific Dunes", city: "Bandon",        distanceMiles: 1.2, imageName: "course_pacific_dunes"),
        .init(name: "Pebble Beach",  city: "Pebble Beach",  distanceMiles: 3.8, imageName: "course_pebble_beach"),
        .init(name: "Spyglass Hill", city: "Pebble Beach",  distanceMiles: 4.1, imageName: "course_spyglass_hill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Courses")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("NEARBY COURSES")
                    .font(.caption)
                    .foregroundStyle(PGColors.subtext)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            // List of courses with pictures
            List {
                Section {
                    ForEach(nearby) { course in
                        HStack(spacing: 14) {
                            CourseImage(imageName: course.imageName)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("\(course.city)  •  \(String(format: "%.1f", course.distanceMiles)) mi")
                                    .font(.subheadline)
                                    .foregroundStyle(PGColors.subtext)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .foregroundStyle(PGColors.subtext)
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(PGColors.card)
                        )
                        .listRowBackground(Color.clear)
                        .contentShape(Rectangle())
                    }
                } footer: {
                    EmptyView()
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)    // remove default list bg
            .background(PGColors.background)     // match app bg
        }
        // Fill the screen including safe areas (no black edges)
        .background(PGColors.background.ignoresSafeArea())
    }
}

#Preview {
    CoursesView()
        .preferredColorScheme(.dark)
}
