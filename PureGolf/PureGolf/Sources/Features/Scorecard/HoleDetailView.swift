
import SwiftUI

struct HoleDetailView: View {
    @State private var hole: HoleScore
    let onUpdate: (HoleScore) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingShotTracker = false
    
    init(hole: HoleScore, onUpdate: @escaping (HoleScore) -> Void) {
        self._hole = State(initialValue: hole)
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Hole Header
                    VStack(spacing: 8) {
                        Text("Hole \(hole.holeNumber)")
                            .font(.title.bold())
                            .foregroundStyle(PGColors.text)
                        
                        Text("Par \(hole.par) • HCP \(hole.handicap)")
                            .font(.subheadline)
                            .foregroundStyle(PGColors.subtext)
                        
                        if hole.strokes > 0 {
                            Text(hole.scoreText)
                                .font(.headline)
                                .foregroundStyle(hole.scoreToPar <= 0 ? .green : .red)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(hole.scoreToPar <= 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Score Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Score")
                            .font(.headline)
                            .foregroundStyle(PGColors.text)
                        
                        HStack(spacing: 12) {
                            ForEach(1...8, id: \.self) { score in
                                Button {
                                    hole.strokes = score
                                } label: {
                                    Text("\(score)")
                                        .font(.headline.bold())
                                        .frame(width: 44, height: 44)
                                        .background(hole.strokes == score ? PGColors.accent : PGColors.card)
                                        .foregroundStyle(hole.strokes == score ? .black : PGColors.text)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Additional Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hole Stats")
                            .font(.headline)
                            .foregroundStyle(PGColors.text)
                        
                        // Putts
                        HStack {
                            Text("Putts:")
                                .foregroundStyle(PGColors.text)
                            Spacer()
                            HStack(spacing: 8) {
                                ForEach(0...4, id: \.self) { putts in
                                    Button {
                                        hole.putts = putts
                                    } label: {
                                        Text("\(putts)")
                                            .font(.subheadline.bold())
                                            .frame(width: 32, height: 32)
                                            .background(hole.putts == putts ? PGColors.accent : PGColors.background)
                                            .foregroundStyle(hole.putts == putts ? .black : PGColors.text)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        
                        // Fairway Hit (for par 4 and 5)
                        if hole.par >= 4 {
                            HStack {
                                Text("Fairway:")
                                    .foregroundStyle(PGColors.text)
                                Spacer()
                                HStack(spacing: 8) {
                                    Button("Hit") {
                                        hole.fairwayHit = true
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.small)
                                    .tint(hole.fairwayHit == true ? .green : .gray)
                                    
                                    Button("Miss") {
                                        hole.fairwayHit = false
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.small)
                                    .tint(hole.fairwayHit == false ? .red : .gray)
                                }
                            }
                        }
                        
                        // Green in Regulation
                        HStack {
                            Text("GIR:")
                                .foregroundStyle(PGColors.text)
                            Spacer()
                            HStack(spacing: 8) {
                                Button("Yes") {
                                    hole.greenInRegulation = true
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                                .tint(hole.greenInRegulation == true ? .green : .gray)
                                
                                Button("No") {
                                    hole.greenInRegulation = false
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                                .tint(hole.greenInRegulation == false ? .red : .gray)
                            }
                        }
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Shot Tracking
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Shots (\(hole.shots.count))")
                                .font(.headline)
                                .foregroundStyle(PGColors.text)
                            
                            Spacer()
                            
                            Button("Add Shot") {
                                showingShotTracker = true
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                        
                        if !hole.shots.isEmpty {
                            ForEach(hole.shots) { shot in
                                ShotRowView(shot: shot)
                            }
                        } else {
                            Text("No shots recorded")
                                .foregroundStyle(PGColors.subtext)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundStyle(PGColors.text)
                        
                        TextField("Add notes about this hole...", text: $hole.notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .pgBackground()
            .navigationTitle("Hole \(hole.holeNumber)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onUpdate(hole)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingShotTracker) {
            ShotTrackerView { shot in
                hole.shots.append(shot)
            }
        }
    }
}

struct ShotRowView: View {
    let shot: Shot
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Shot \(shot.shotNumber)")
                    .font(.subheadline.bold())
                    .foregroundStyle(PGColors.text)
                
                Text("\(shot.club) • \(Int(shot.distance)) yds")
                    .font(.caption)
                    .foregroundStyle(PGColors.subtext)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(shot.accuracy.emoji)
                Text(shot.lie.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(PGColors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .foregroundStyle(PGColors.subtext)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ShotTrackerView: View {
    let onSave: (Shot) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedClub = "7 Iron"
    @State private var distance = ""
    @State private var accuracy = Shot.ShotAccuracy.good
    @State private var lie = Shot.LieType.fairway
    @State private var notes = ""
    
    let clubs = ["Driver", "3 Wood", "5 Wood", "3 Iron", "4 Iron", "5 Iron", "6 Iron", "7 Iron", "8 Iron", "9 Iron", "PW", "SW", "LW", "Putter"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Club") {
                    Picker("Club", selection: $selectedClub) {
                        ForEach(clubs, id: \.self) { club in
                            Text(club).tag(club)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section("Distance") {
                    TextField("Distance (yards)", text: $distance)
                        .keyboardType(.numberPad)
                }
                
                Section("Accuracy") {
                    Picker("Accuracy", selection: $accuracy) {
                        ForEach(Shot.ShotAccuracy.allCases, id: \.self) { acc in
                            Text("\(acc.emoji) \(acc.rawValue)").tag(acc)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Lie") {
                    Picker("Lie", selection: $lie) {
                        ForEach(Shot.LieType.allCases, id: \.self) { lieType in
                            Text(lieType.rawValue).tag(lieType)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Additional notes...", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("Add Shot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard let dist = Double(distance), dist > 0 else { return }
                        
                        let shot = Shot(
                            shotNumber: 1, // This should be calculated
                            club: selectedClub,
                            distance: dist,
                            accuracy: accuracy,
                            lie: lie,
                            location: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Would use GPS
                            timestamp: Date(),
                            notes: notes.isEmpty ? nil : notes
                        )
                        
                        onSave(shot)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(distance.isEmpty)
                }
            }
        }
    }
}

#Preview {
    HoleDetailView(hole: HoleScore(holeNumber: 1, par: 4, handicap: 12)) { _ in }
}
