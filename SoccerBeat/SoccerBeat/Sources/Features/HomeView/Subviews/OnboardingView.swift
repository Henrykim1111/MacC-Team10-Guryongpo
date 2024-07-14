//
//  OnboardingView.swift
//  SoccerBeat
//
//  Created by Henry's Mac on 7/12/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                }
                
            }
            Spacer()
            Text(LocalizedStringKey("현재 기록된 경기가 없습니다."))
                .font(.onboardingTop)
                .foregroundStyle(.onboardingText)
            Image("OnboardingWatchImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
            Text(LocalizedStringKey("애플워치에서 사커비트를 켜서"))
                .font(.onboardingBottom)
                .foregroundStyle(.playTimeNumber)
            Text(LocalizedStringKey("첫 경기를 기록하세요!"))
                .font(.onboardingBottom)
                .foregroundStyle(.onboardingText)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
