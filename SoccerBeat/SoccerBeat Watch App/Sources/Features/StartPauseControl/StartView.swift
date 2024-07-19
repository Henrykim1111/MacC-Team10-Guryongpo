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
                                    iPhone을 사용하여
                                    SoccerBeat에서 건강
                                    정보에 엑세스하도록 허용
                                    합니다. 설정 > 개인정보
                                    보호 및 보안 > 건강 >
                                    SoccerBeat로 이동하세요.
                                    건강 권한을 모두 활성화를
                                    마친 후, SoccerBeat로
                                    돌아가 시작을 누르고
                                    경기를 시작하세요.
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
                                SoccerBeat가 Apple
                                Watch에서 위치 정보에
                                액세스해야 합니다. 위치 
                                정보 액세스를 활성화하려면
                                iPhone에서 설정 > 개인정보
                                보호 및 보안 > 위치 서비스
                                > SoccerBeat로 이동하세요.
                                활성화를 마친 후, SoccerBeat로
                                돌아가 시작을 누르고
                                경기를 시작하세요.
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
