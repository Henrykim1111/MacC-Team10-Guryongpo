//
//  SummaryView.swift
//  SoccerBeat Watch App
//
//  Created by jose Yun on 10/23/23.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var matricsIndicator: MatricsIndicator
    @State private var isShowingSummary = false
    
    var body: some View {
        if isShowingSummary {
            ScrollView(showsIndicators: false) {
                SummaryComponent(title: "뛴 거리",
                                 content: (matricsIndicator.distanceMeter / 1000).rounded(at: 2) + " km")
                SummaryComponent(title: "최고 속도", content: (matricsIndicator.maxSpeedMPS * 3.6).rounded(at: 1) + " km/h")
                SummaryComponent(title: "스프린트 횟수", content:  matricsIndicator.sprintCount.formatted() + " Times")
                
                SummaryComponent(title: "파워", content:  matricsIndicator.maxPower.rounded(at: 1) + " w")

                Button {
                    workoutManager.showingSummaryView = false
                } label: {
                    Text("완료")
                        .font(.summaryDoneButton)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .foregroundStyle(.summaryGradient)
                        .background(
                            Capsule()
                                .fill(.columnTitle)
                        )
                }

            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
        } else {
            PhraseView()
                .navigationBarHidden(true)
                .task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
                    withAnimation {
                        isShowingSummary.toggle()
                        workoutManager.showingPrecount = false
                    }
                }
        }
    }
}

#Preview {
    SummaryView()
}
