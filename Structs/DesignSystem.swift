import SwiftUI

// MARK: - App Color Identity

extension Color {
    /// Indigo = Left hand. Orange = Right hand.
    static let leftHand: Color = .indigo
    static let rightHand: Color = .orange
}

// MARK: - Layout Constants

enum Layout {
    /// Maximum width of the white card, keeps background visible on iPad.
    static let maxCardWidth: CGFloat = 560
    /// Maximum height of the white card on iPad (regular size class), prevents excessive vertical stretching.
    static let maxCardHeightIPad: CGFloat = 700
}

