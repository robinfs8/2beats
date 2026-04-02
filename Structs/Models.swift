import Foundation

// MARK: - Data Models

struct RhythmMode: Hashable {
    let title: String
    let description: String
    let leftBeatsPerMeasure: Int
    let rightBeatsPerMeasure: Int


    var measureDuration: TimeInterval {
        return 3.400 //seconds for one full 4/4 beat
    }

    // Interval for timers
    var leftInterval: TimeInterval {
        return measureDuration / Double(leftBeatsPerMeasure)
    }

    var rightInterval: TimeInterval {
        return measureDuration / Double(rightBeatsPerMeasure)
    }
}

