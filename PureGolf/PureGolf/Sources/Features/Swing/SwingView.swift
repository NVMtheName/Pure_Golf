
import SwiftUI
import AVFoundation

struct SwingView: View {
    @StateObject private var swingAnalyzer = SwingAnalyzer()
    @State private var showingAnalysis = false
    @State private var analysisResult: SwingAnalysisResult?
    @State private var isRecording = false
    
    var body: some View {
        ZStack {
            if swingAnalyzer.isAuthorized {
                cameraView
            } else {
                permissionView
            }
        }
        .pgBackground()
        .onAppear {
            swingAnalyzer.requestCameraPermission()
        }
        .sheet(isPresented: $showingAnalysis) {
            if let result = analysisResult {
                SwingAnalysisView(result: result)
            }
        }
    }
    
    private var cameraView: some View {
        VStack(spacing: 0) {
            // Camera preview
            CameraPreviewView(session: swingAnalyzer.captureSession)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .topLeading) {
                    recordingIndicator
                }
                .overlay(alignment: .bottom) {
                    cameraControls
                }
        }
    }
    
    private var recordingIndicator: some View {
        Group {
            if isRecording {
                HStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                        .opacity(swingAnalyzer.isRecording ? 1 : 0.3)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: swingAnalyzer.isRecording)
                    
                    Text("Recording")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black.opacity(0.6))
                .cornerRadius(16)
                .padding()
            }
        }
    }
    
    private var cameraControls: some View {
        VStack(spacing: 16) {
            if swingAnalyzer.isAnalyzing {
                VStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Analyzing swing...")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .background(.black.opacity(0.6))
                .cornerRadius(12)
            }
            
            HStack(spacing: 24) {
                // Record button
                Button {
                    if swingAnalyzer.isRecording {
                        Task {
                            await stopRecording()
                        }
                    } else {
                        startRecording()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(swingAnalyzer.isRecording ? .red : .white)
                            .frame(width: 70, height: 70)
                        
                        if swingAnalyzer.isRecording {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white)
                                .frame(width: 20, height: 20)
                        } else {
                            Circle()
                                .stroke(.black, lineWidth: 3)
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                .disabled(swingAnalyzer.isAnalyzing)
                
                // Gallery button (placeholder for saved analyses)
                Button {
                    // TODO: Show saved swing analyses
                } label: {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.black.opacity(0.6))
                        .cornerRadius(25)
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    private var permissionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundStyle(PGColors.subtext)
            
            VStack(spacing: 8) {
                Text("Camera Access Required")
                    .font(.title2.bold())
                
                Text("Allow camera access to record and analyze your golf swing")
                    .font(.body)
                    .foregroundStyle(PGColors.subtext)
                    .multilineTextAlignment(.center)
            }
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func startRecording() {
        isRecording = true
        swingAnalyzer.startRecording()
    }
    
    private func stopRecording() async {
        isRecording = false
        let result = await swingAnalyzer.stopRecordingAndAnalyze()
        analysisResult = result
        showingAnalysis = true
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview { SwingView() }
