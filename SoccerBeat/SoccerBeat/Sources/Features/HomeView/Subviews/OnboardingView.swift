//
//  OnboardingView.swift
//  SoccerBeat
//
//  Created by Henry's Mac on 7/12/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Text(LocalizedStringKey("현재 기록된 경기가 없습니다."))
                .font(.onboardingTop)
                .foregroundStyle(.onboardingText)
            Spacer()
                .frame(height: 30)
            Image("OnboardingWatchImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
            Spacer()
                .frame(height: 40)
            Text(LocalizedStringKey("애플워치에서 사커비트를 켜서"))
                .font(.onboardingBottom)
                .foregroundStyle(.playTimeNumber)
            Text(LocalizedStringKey("첫 경기를 기록하세요!"))
                .font(.onboardingBottom)
                .foregroundStyle(.onboardingText)
        }
    }
}

#Preview {
    OnboardingView()
}
