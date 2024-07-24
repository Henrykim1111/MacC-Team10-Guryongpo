//
//  SoccerBeatApp.swift
//  SoccerBeat
//
//  Created by daaan on 10/21/23.
//

import SwiftUI

@main
struct SoccerBeatApp: App {
    @State var isShowingOnboardingView : Bool
    @StateObject var soundManager = SoundManager()
    @StateObject var healthInteracter = HealthInteractor.shared
    @StateObject var profileModel = ProfileModel(healthInteractor: HealthInteractor.shared)
    @State private var hasHealthAuthorization: Bool
    @State private var hasLocationAuthorization: Bool
    
    init() {
        self.hasHealthAuthorization = HealthInteractor.shared.haveHealthAuthorization()
        self.hasLocationAuthorization = HealthInteractor.shared.hasLocationAuthorization()
        self.isShowingOnboardingView = false
    }
    var body: some Scene {
        WindowGroup {
            Group {
                if hasHealthAuthorization && hasLocationAuthorization {
                    ContentView(isShowingOnboardingView: $isShowingOnboardingView)
                } else if !hasHealthAuthorization {
                    NoAuthorizationView(requestingAuth: .health)
                } else if !hasLocationAuthorization {
                    NoAuthorizationView(requestingAuth: .location)
                }
            }
            .environmentObject(soundManager)
            .environmentObject(healthInteracter)
            .environmentObject(profileModel)
            .onReceive(
                NotificationCenter
                    .default
                    .publisher(
                        for: UIApplication.didBecomeActiveNotification
                    )
            ) { _ in
                hasHealthAuthorization = healthInteracter.haveHealthAuthorization()
                hasLocationAuthorization = healthInteracter.hasLocationAuthorization()
                Task {
                    if hasHealthAuthorization && hasLocationAuthorization {
                        await self.healthInteracter.fetchWorkoutData()
                    }
                }
            }
            .task {
                healthInteracter.requestAuthorization()
            }
            .onReceive(healthInteracter.authSuccess) {
                Task { await healthInteracter.fetchWorkoutData() }
            }
        }
    }
}
