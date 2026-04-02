import SwiftUI

struct HomeView: View {
    @State private var showInfo = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Hintergrund
                ColorfulBackground()
                    .ignoresSafeArea()

                // 2. Die Karte
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        // Titel
                        Text("2Beats")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top)

                        // Kurze Beschreibung
                        Text("Two hands. Two rhythms. Train concentration and rhythm awareness.")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()

                       

                        // Buttons am unteren Ende der Karte
                        VStack(spacing: 16) {
                            NavigationLink {
                                ModeSelectionView()
                            } label: {
                                Text("Start")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                            .controlSize(.large)

                            Button {
                                showInfo = true
                            } label: {
                                Text("About the App")
                                    .foregroundStyle(.blue)
                                    
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 500)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .frame(maxWidth: Layout.maxCardWidth)
                .padding(.horizontal)
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
        }
    }
}

// MARK: - Info View (iPad-optimiert)

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var animateCircles = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: - About
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("2Beats challenges you to keep two independent beat patterns going – one for each hand – at the same time.")
                        Text("This is called a polyrhythm.")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    .padding(.vertical)
                } header: {
                    Text("What is 2Beats?")
                        .font(.footnote)
                }

               

                // MARK: - How It Works
                Section {
                    HowItWorksStep(number: "1", title: "Listen", description: "Two separate sounds play — one per hand.")
                    HowItWorksStep(number: "2", title: "Watch",  description: "Dots light up as each beat arrives.")
                    HowItWorksStep(number: "3", title: "Tap",    description: "Press Left and Right at the right moments.")
                } header: {
                    Text("How It Works")
                        .font(.footnote)
                }

                // MARK: - Benefits
                Section {
                    BenefitRow(
                        icon: "brain.head.profile",
                        iconColor: .purple,
                        title: "Cognitive Training",
                        description: "Engages both brain hemispheres simultaneously."
                    )
                    BenefitRow(
                        icon: "hand.raised.fill",
                        iconColor: .pink,
                        title: "Hand Independence",
                        description: "Each hand follows its own timing pattern."
                    )
                    BenefitRow(
                        icon: "waveform",
                        iconColor: .teal,
                        title: "Rhythm Awareness",
                        description: "Develop a feel for how different beats relate."
                    )
                } header: {
                    Text("Why Practice This?")
                        .font(.footnote)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("About 2Beats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateCircles = true
            }
        }
    }
}

// MARK: - Hilfskomponenten

struct BenefitRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
        }
        .padding(.vertical)
    }
}

struct HowItWorksStep: View {
    let number: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Text(number)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 26, height: 26)
                .background(Color.indigo, in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.medium))
                Text(description).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical)
    }
}

