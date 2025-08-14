
import SwiftUI
import AVKit

struct SwingAnalysisView: View {
    let result: SwingAnalysisResult
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Score header
                    scoreSection
                    
                    // Video player (if available)
                    if let videoURL = result.videoURL {
                        videoSection(url: videoURL)
                    }
                    
                    // Metrics
                    metricsSection
                    
                    // Feedback
                    feedbackSection
                    
                    // Action buttons
                    actionButtons
                }
                .padding()
            }
            .navigationTitle("Swing Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var scoreSection: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(PGColors.card, lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(result.score) / 100)
                    .stroke(scoreColor, lineWidth: 8)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(result.score)")
                        .font(.system(size: 36, weight: .bold))
                    Text("SCORE")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PGColors.subtext)
                }
            }
            
            Text(scoreDescription)
                .font(.headline)
                .foregroundStyle(scoreColor)
        }
        .padding()
    }
    
    private var scoreColor: Color {
        switch result.score {
        case 85...100: return .green
        case 70...84: return .orange
        default: return .red
        }
    }
    
    private var scoreDescription: String {
        switch result.score {
        case 85...100: return "Excellent Swing"
        case 70...84: return "Good Swing"
        case 55...69: return "Needs Work"
        default: return "Beginner"
        }
    }
    
    private func videoSection(url: URL) -> some View {
        PGCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Swing Video")
                    .font(.headline)
                
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 200)
                    .cornerRadius(8)
            }
        }
    }
    
    private var metricsSection: some View {
        PGCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Swing Metrics")
                    .font(.headline)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    MetricView(title: "Tempo", value: result.metrics.tempo)
                    MetricView(title: "Club Path", value: result.metrics.clubPath)
                    MetricView(title: "Face Angle", value: result.metrics.faceAngle)
                    MetricView(title: "Impact", value: result.metrics.impactPosition)
                    MetricView(title: "Backswing", value: "\(result.metrics.backswingAngle, specifier: "%.1f")°")
                    MetricView(title: "Follow Through", value: "\(result.metrics.followThroughAngle, specifier: "%.1f")°")
                }
            }
        }
    }
    
    private var feedbackSection: some View {
        VStack(spacing: 16) {
            // Strengths
            PGCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Strengths")
                            .font(.headline)
                    }
                    
                    ForEach(result.feedback.strengths, id: \.self) { strength in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.green)
                            Text(strength)
                                .font(.body)
                        }
                    }
                }
            }
            
            // Areas to improve
            PGCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Areas to Improve")
                            .font(.headline)
                    }
                    
                    ForEach(result.feedback.improvements, id: \.self) { improvement in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.orange)
                            Text(improvement)
                                .font(.body)
                        }
                    }
                }
            }
            
            // Recommended drills
            PGCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.blue)
                        Text("Recommended Drills")
                            .font(.headline)
                    }
                    
                    ForEach(result.feedback.drills, id: \.self) { drill in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.blue)
                            Text(drill)
                                .font(.body)
                        }
                    }
                }
            }
            
            // Overall suggestion
            PGCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overall Suggestion")
                        .font(.headline)
                    
                    Text(result.feedback.overallSuggestion)
                        .font(.body)
                        .foregroundStyle(PGColors.text)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button("Save Analysis") {
                // TODO: Save to user's swing history
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            
            Button("Share with Pro") {
                // TODO: Share analysis with golf instructor
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical)
    }
}

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(PGColors.subtext)
            
            Text(value)
                .font(.headline.bold())
                .foregroundStyle(PGColors.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(PGColors.background)
        .cornerRadius(8)
    }
}

#Preview {
    SwingAnalysisView(result: SwingAnalysisResult(
        videoURL: nil,
        metrics: SwingMetrics(
            tempo: "3:1",
            clubPath: "+2°",
            faceAngle: "-1°",
            backswingAngle: 105.0,
            followThroughAngle: 95.0,
            impactPosition: "Centered",
            swingPlane: "On plane"
        ),
        feedback: SwingFeedback(
            strengths: ["Great tempo", "Solid impact"],
            improvements: ["Club path", "Weight transfer"],
            drills: ["Gate drill", "Step-through drill"],
            overallSuggestion: "Focus on swing path for better consistency."
        ),
        score: 82
    ))
}
