import SwiftUI

struct FinishView: View {
    @Environment(\.dismiss) private var dismiss

    // Zufällige Gratulation
    private let congratulations = [
        (title: "Well Done!",     message: "You've mastered the rhythm.\nYour focus is unstoppable."),
        (title: "Impressive!",     message: "Perfect timing, perfect focus.\nKeep up the momentum."),
        (title: "Excellent Work!", message: "You're in complete control.\nThe beat is yours."),
        (title: "Outstanding!",    message: "Your concentration is razor-sharp.\nKeep pushing forward."),
        (title: "Brilliant!",      message: "You've found your flow.\nThis is just the beginning.")
    ]

    @State private var selectedCongratulation: (title: String, message: String)
    @State private var showContent = false

    init() {
        _selectedCongratulation = State(initialValue: congratulations.randomElement()!)
    }

    var body: some View {
        ZStack {
            // 1. Hintergrund: Das bunte Gitter
            ColorfulBackground()
                .ignoresSafeArea()

            // 2. Die Karte (Weiß)
            VStack(spacing: 0) {
                VStack(spacing: 28) {
                   

                    // MARK: - Checkmark + Title
                    VStack(spacing: 28) {
                   
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(Color.white)
                        }
                        .accessibilityLabel("Session complete")

                        VStack(spacing: 2) {
                            Text(selectedCongratulation.title)
                                .font(.largeTitle).bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)

                            Text(selectedCongratulation.message)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                        }
                    }
                    .scaleEffect(showContent ? 1.0 : 0.85)
                    .opacity(showContent ? 1.0 : 0.0)

                    Spacer()
                    

                    // MARK: - Action Buttons
                    VStack(spacing: 14) {
                        
                        NavigationLink(destination: HomeView()) {
                            
                            Text("Back to Home")
                                 .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .controlSize(.large)
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Try again")
                                .foregroundStyle(.blue)
                                
                        }
                        .padding(.bottom)
                        
                       
                        
                    }
                    .padding(.horizontal)
                    .opacity(showContent ? 1.0 : 0.0)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 500)
                .background(Color.white)
                .cornerRadius(20)
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.72).delay(0.15)) {
                showContent = true
            }
        }
    }
}
