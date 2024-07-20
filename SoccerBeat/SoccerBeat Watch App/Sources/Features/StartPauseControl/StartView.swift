//
//  StartView.swift
//  SoccerBeat Watch App
//
//  Created by Gucci on 10/22/23.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var isShowingHealthAlert = false
    @State private var isShowingLocationAlert = false

    var body: some View {
        VStack {
            if !workoutManager.showingPrecount {
                ZStack {
                    Image(.backgroundGlow)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .alert(isPresented: $isShowingHealthAlert) {
                            Alert(title: Text("need_health_authorization"),
                                  message: Text("inform_need_health"),
                                  dismissButton: .default(Text("close")))
                        }

                    Button(action: handleButtonPress) {
                        Image(.startButton)
                    }
                    .alert(isPresented: $isShowingLocationAlert) {
                        Alert(title: Text("need_location_authorization"),
                              message: Text("inform_need_location"),
                              dismissButton: .default(Text("close")))
                    }
                }

            } else {
                PrecountView()
            }
        }
        .buttonStyle(.borderless)
    }

    private func handleButtonPress() {
        checkLocationAuthorization()
        checkHealthAuthorization()
        handleWorkoutStart()
    }

    private func checkLocationAuthorization() {
        workoutManager.checkLocationAuthorization()
        if !workoutManager.hasLocationAuthorization {
            isShowingLocationAlert.toggle()
        }
    }

    private func checkHealthAuthorization() {
        if workoutManager.hasNoHealthAuthorization {
            isShowingHealthAlert.toggle()
        }
    }

    private func handleWorkoutStart() {
        let hasAllAuthorization = !workoutManager.hasNoHealthAuthorization
        && workoutManager.hasLocationAuthorization

        if hasAllAuthorization && workoutManager.isHealthDataAvailable {
            workoutManager.showingPrecount.toggle()
        }
    }
}

#Preview {
    @StateObject var workoutManager = DIContianer.makeWorkoutManager()

    return StartView()
        .environmentObject(workoutManager)
}
