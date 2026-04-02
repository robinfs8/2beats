import SwiftUI

struct ModeSelectionView: View {
    // levels
    let availableModes = [
        RhythmMode(title: "Calm",    description: "Slow and steady",    leftBeatsPerMeasure: 2, rightBeatsPerMeasure: 4),
        RhythmMode(title: "Flow",    description: "Gentle challenge",   leftBeatsPerMeasure: 3, rightBeatsPerMeasure: 2),
        RhythmMode(title: "Focus",   description: "Classic polyrhythm", leftBeatsPerMeasure: 3, rightBeatsPerMeasure: 4),
        RhythmMode(title: "Vibe",    description: "Getting difficult",  leftBeatsPerMeasure: 2, rightBeatsPerMeasure: 5),
        RhythmMode(title: "Complex", description: "Test coordination",  leftBeatsPerMeasure: 5, rightBeatsPerMeasure: 4),
        RhythmMode(title: "Expert",  description: "Extreme rhythm",     leftBeatsPerMeasure: 3, rightBeatsPerMeasure: 5)
    ]

    var body: some View {
        ZStack {
            // Background
            ColorfulBackground()
                .ignoresSafeArea()

            // White Card
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rhythms")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("Choose a level or create your own rhythm.")
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.top)
                    .padding(.bottom)

                    // List to choose rhythms, or create own rhythm
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            // Presets
                            ForEach(availableModes, id: \.self) { mode in
                                NavigationLink {
                                    PlayView(mode: mode)
                                } label: {
                                    SimpleModeRow(mode: mode)
                                }
                            }
                            
                            // Trenner
                            Rectangle()
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 1)
                                .padding(.vertical)

                            // Custom Bereich
                            CustomBeatPickerCard()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(20)
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .navigationBarHidden(false)
    }

}

// MARK: - Zeile für Rhythmen
struct SimpleModeRow: View {
    let mode: RhythmMode
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(mode.title)
                    .bold()
                    .foregroundColor(.black)
                
                Text("\(mode.leftBeatsPerMeasure) vs. \(mode.rightBeatsPerMeasure) beat")
                    .foregroundColor(.black.opacity(0.7))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.black.opacity(0.3))
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(20)
    }
}

// MARK: - Vereinfachter Custom Picker (iPad-optimiert)
struct CustomBeatPickerCard: View {
    @State private var leftBeats: Int = 3
    @State private var rightBeats: Int = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Own rhythm")
                .bold()
                .foregroundColor(.black)

            VStack(spacing: 8) {
                Stepper(value: $leftBeats, in: 2...9) {
                    Text("Left: \(leftBeats)")
                }
                .foregroundColor(.black)
                
                Stepper(value: $rightBeats, in: 2...9) {
                    Text("Right: \(rightBeats)")
                }
                .foregroundColor(.black)
            }
            .padding(.vertical)

            NavigationLink {
                PlayView(mode: RhythmMode(title: "Custom", description: "", leftBeatsPerMeasure: leftBeats, rightBeatsPerMeasure: rightBeats))
            } label: {
                Text("Choose custom")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue) // Schwarz für den Button-Stil
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(20)
    }
}


struct ColorfulBackground: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan]
    
    var body: some View {
        GeometryReader { geo in
            let size: CGFloat = 60
            let columns = Int(geo.size.width / size) + 1
            let rows = Int(geo.size.height / size) + 1
            
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { _ in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { _ in
                            Rectangle()
                                .fill(colors.randomElement() ?? .red)
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
    }
}
