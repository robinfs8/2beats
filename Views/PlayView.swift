import SwiftUI
import AVFoundation
import AudioToolbox

// MARK: - Play View

struct PlayView: View {
    let mode: RhythmMode

    @State private var leftPulse = false
    @State private var rightPulse = false
    @State private var leftTimer: Timer?
    @State private var rightTimer: Timer?
    @State private var quoteTimer: Timer?

    @State private var currentLeftBeat: Int = 0
    @State private var currentRightBeat: Int = 0
    @State private var lastLeftBeatTime = Date()
    @State private var lastRightBeatTime = Date()

    @State private var currentQuote: String = ""
    @State private var phaseIndex: Int = 0


    let progressiveQuotes: [[String]] = [
        ["Take a moment… listen to the beats.", "Feel the rhythm before starting.", "Start slow. Let your hands find their flow.", "Focus on one hand first, then the other.", "Rhythm is felt, not forced. Take your time."],
        ["Good start! Keep your hands steady.", "Notice the pulse – match it.", "Relax your fingers, stay with the rhythm.", "Try to sense the beat before tapping.", "One hand at a time is perfect."],
        ["Your hands are starting to dance.", "Keep them independent, trust your feeling.", "This is a puzzle your brain loves.", "Stay present – let the sound guide you.", "Don't rush – precision feels better than speed."],
        ["Now it's getting interesting – flow is key.", "Watch the pulse, don't just listen.", "Focus your mind and let your hands follow.", "Each tap matters – feel the difference.", "This is not about perfection, it's about awareness."],
        ["Your hands are independent – embrace it.", "Every beat counts. Stay calm, stay sharp.", "Challenge accepted. Let the rhythm guide you.", "Notice the subtle shifts – adjust in real time.", "You're not just playing, you're coordinating a symphony.", "Close your eyes and hear the beat."]
    ]

    var body: some View {
        ZStack {
            ColorfulBackground()
                .ignoresSafeArea()

            VStack {
                VStack {
                    VStack(spacing: 16) {
                        Text(mode.title)
                            .bold()
                            .foregroundColor(.black.opacity(0.5))
                            .textCase(.uppercase)
                            .tracking(2)
                            .padding(.top)

                        HStack(spacing: 40) {
                            MetronomeSquare(isActive: leftPulse, color: .yellow, label: "Left")
                            MetronomeSquare(isActive: rightPulse, color: .purple, label: "Right")
                        }

                        BeatVisualization(
                            leftBeats: mode.leftBeatsPerMeasure,
                            rightBeats: mode.rightBeatsPerMeasure,
                            currentLeftBeat: currentLeftBeat,
                            currentRightBeat: currentRightBeat,
                            measureDuration: mode.measureDuration
                        )
                        .padding(.horizontal)
                    }

                    Text(currentQuote)
                        .fontWeight(.medium)
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .id(currentQuote)
                        .padding(.top)

                    Spacer()
                    
                    Text("Green = right timing. Red = missed.")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                

                // Tap Buttons
                VStack {
                    
                    HStack {
                        TouchDownSquareButton(label: "L", checkTiming: {
                            isHit(lastBeat: lastLeftBeatTime, interval: mode.leftInterval)
                        })
                        Spacer()
                        TouchDownSquareButton(label: "R", checkTiming: {
                            isHit(lastBeat: lastRightBeatTime, interval: mode.rightInterval)
                        })
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.vertical)
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { FinishView() } label: {
                    Text("Finish")
                        .bold()
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            setupAudio()
            startEngine()
            startQuoteProgression()
        }
        .onDisappear {
            stopEngine()
        }
    }

    // LOGIK (Unverändert)
    func startQuoteProgression() {
        phaseIndex = 0
        updateQuote()
        quoteTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { _ in
            Task { @MainActor in
                if phaseIndex < progressiveQuotes.count - 1 { phaseIndex += 1 }
                updateQuote()
            }
        }
    }
    func updateQuote() { currentQuote = progressiveQuotes[phaseIndex].randomElement() ?? "" }
    func startEngine() {
        stopEngine()
        currentLeftBeat = 0
        currentRightBeat = 0
        let now = Date()
        lastLeftBeatTime = now
        lastRightBeatTime = now
        triggerPulse(left: true)
        triggerPulse(left: false)
        leftTimer = Timer.scheduledTimer(withTimeInterval: mode.leftInterval, repeats: true) { _ in
            Task { @MainActor in
                lastLeftBeatTime = Date()
                currentLeftBeat = (currentLeftBeat + 1) % mode.leftBeatsPerMeasure
                triggerPulse(left: true)
            }
        }
        rightTimer = Timer.scheduledTimer(withTimeInterval: mode.rightInterval, repeats: true) { _ in
            Task { @MainActor in
                lastRightBeatTime = Date()
                currentRightBeat = (currentRightBeat + 1) % mode.rightBeatsPerMeasure
                triggerPulse(left: false)
            }
        }
    }
    func stopEngine() {
        leftTimer?.invalidate()
        rightTimer?.invalidate()
        quoteTimer?.invalidate()
    }
    func setupAudio() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
    }
    func triggerPulse(left: Bool) {
        if left {
            leftPulse = true
            AudioServicesPlaySystemSound(1103)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { leftPulse = false }
        } else {
            rightPulse = true
            AudioServicesPlaySystemSound(1105)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { rightPulse = false }
        }
    }
    func isHit(lastBeat: Date, interval: Double) -> Bool {
        let now = Date()
        let timeSinceLast = now.timeIntervalSince(lastBeat)
        return abs(timeSinceLast) < 0.12 || abs(interval - timeSinceLast) < 0.12
    }
}

// MARK: - Metronome Square

struct MetronomeSquare: View {
    let isActive: Bool
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(isActive ? color : Color.black.opacity(0.1))
                .frame(width: 45, height: 45)
                .cornerRadius(20)

            Text(label)
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.black.opacity(0.4))
                .textCase(.uppercase)
        }
    }
}

// MARK: - Touch Down Square Button

struct TouchDownSquareButton: View {
    let label: String
    let checkTiming: () -> Bool

    @State private var isPressed = false
    @State private var wasHit = false


    var body: some View {
        ZStack {
            Rectangle()
                .fill(isPressed ? (wasHit ? Color.green : Color.red) : Color.black)
                
                .cornerRadius(20)
                .frame(maxWidth: .infinity)
                .padding()

            Text(label)
                .fontWeight(.black)
                .foregroundStyle(.white)
        }
        .padding()
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        wasHit = checkTiming()
                    }
                }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Beat Visualization

struct BeatVisualization: View {
    let leftBeats: Int
    let rightBeats: Int
    let currentLeftBeat: Int
    let currentRightBeat: Int
    let measureDuration: TimeInterval
    

    var body: some View {
        VStack(spacing: 15) {
            lcmRow(beats: leftBeats, current: currentLeftBeat, color: .yellow)
            
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(height: 1)

            lcmRow(beats: rightBeats, current: currentRightBeat, color: .purple)
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(20)
    }

    private func lcmRow(beats: Int, current: Int, color: Color) -> some View {
        HStack {
            ForEach(0..<beats, id: \.self) { index in
                Rectangle()
                    .fill(current == index ? color : color.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(2)
            }
        }
    }
}
