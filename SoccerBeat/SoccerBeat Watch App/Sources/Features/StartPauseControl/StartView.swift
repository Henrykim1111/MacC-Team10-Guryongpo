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
                            Alert(title: Text("건강 액세스 권한 필요"),
                                  message: Text(
                                    """
                                    원활한 앱 사용을 위해
                                    아이폰의 설정 앱에서 SoccerBeat의
                                    건강 권한을 허용한 후 다시 실행해주세요.
                                    """
                                  ),
                                  dismissButton: .default(Text("닫기")))
                        }

                    Button(action: handleButtonPress) {
                        Image(.startButton)
                    }
                    .alert(isPresented: $isShowingLocationAlert) {
                        Alert(title: Text("위치 엑세스 권한 필요"),
                              message: Text(
                                """
                                원활한 앱 사용을 위해
                                아이폰의 설정 앱에서 SoccerBeat의
                                위치 권한을 허용한 후 다시 실행해주세요.
                                """
                              ),
                              dismissButton: .default(Text("닫기")))
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
        && !workoutManager.hasNoLocationAuthorization

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
