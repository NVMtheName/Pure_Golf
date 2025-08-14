
import Foundation
import AVFoundation
import Vision
import UIKit

// Data models for swing analysis
struct SwingAnalysisResult {
    let id = UUID()
    let timestamp = Date()
    let videoURL: URL?
    let metrics: SwingMetrics
    let feedback: SwingFeedback
    let score: Int // 0-100
}

struct SwingMetrics {
    let tempo: String
    let clubPath: String
    let faceAngle: String
    let backswingAngle: Double
    let followThroughAngle: Double
    let impactPosition: String
    let swingPlane: String
}

struct SwingFeedback {
    let strengths: [String]
    let improvements: [String]
    let drills: [String]
    let overallSuggestion: String
}

@MainActor
class SwingAnalyzer: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var isRecording = false
    @Published var isAnalyzing = false
    
    let captureSession = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput?
    private var recordingURL: URL?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    self?.startSession()
                }
            }
        }
    }
    
    private func setupCamera() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            // Setup video output
            videoOutput = AVCaptureMovieFileOutput()
            if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    private func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func startRecording() {
        guard let videoOutput = videoOutput else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("swing_\(Date().timeIntervalSince1970).mov")
        
        guard let url = recordingURL else { return }
        
        isRecording = true
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }
    
    func stopRecordingAndAnalyze() async -> SwingAnalysisResult {
        guard let videoOutput = videoOutput else {
            return generateMockResult()
        }
        
        videoOutput.stopRecording()
        isRecording = false
        isAnalyzing = true
        
        // Wait for recording to finish
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let result = await analyzeSwing()
        isAnalyzing = false
        
        return result
    }
    
    private func analyzeSwing() async -> SwingAnalysisResult {
        // Simulate AI analysis time
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // In a real implementation, this would:
        // 1. Use Vision framework to detect body poses
        // 2. Track club movement through frames
        // 3. Calculate swing metrics
        // 4. Generate personalized feedback
        
        return generateAnalysisResult()
    }
    
    private func generateAnalysisResult() -> SwingAnalysisResult {
        let metrics = SwingMetrics(
            tempo: "3.2:1",
            clubPath: "+1.5°",
            faceAngle: "-0.8°",
            backswingAngle: 105.5,
            followThroughAngle: 98.2,
            impactPosition: "Centered",
            swingPlane: "On plane"
        )
        
        let feedback = SwingFeedback(
            strengths: [
                "Excellent tempo and rhythm",
                "Good impact position",
                "Solid follow-through"
            ],
            improvements: [
                "Slightly inside club path",
                "Could benefit from more shoulder turn",
                "Work on weight transfer"
            ],
            drills: [
                "Alignment stick drill for swing path",
                "Weight shift drill with step-through",
                "Tempo training with metronome"
            ],
            overallSuggestion: "Great swing foundation! Focus on swing path for more consistency."
        )
        
        return SwingAnalysisResult(
            videoURL: recordingURL,
            metrics: metrics,
            feedback: feedback,
            score: Int.random(in: 75...92)
        )
    }
    
    private func generateMockResult() -> SwingAnalysisResult {
        let metrics = SwingMetrics(
            tempo: "2.8:1",
            clubPath: "+3.2°",
            faceAngle: "Square",
            backswingAngle: 98.0,
            followThroughAngle: 85.5,
            impactPosition: "Slightly forward",
            swingPlane: "Steep"
        )
        
        let feedback = SwingFeedback(
            strengths: ["Good balance", "Smooth tempo"],
            improvements: ["Club path", "Swing plane"],
            drills: ["Gate drill", "Plane board work"],
            overallSuggestion: "Work on swing path for better ball striking."
        )
        
        return SwingAnalysisResult(
            videoURL: nil,
            metrics: metrics,
            feedback: feedback,
            score: 68
        )
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension SwingAnalyzer: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        }
    }
}
