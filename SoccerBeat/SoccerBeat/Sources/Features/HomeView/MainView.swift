//
//  MainView.swift
//  SoccerBeat
//
//  Created by daaan on 11/16/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var profileModel: ProfileModel
    @EnvironmentObject var healthInteractor: HealthInteractor
    @EnvironmentObject var soundManager: SoundManager
    @State private var isFlipped = false
    @State private var currentLocation = "---"
    @Binding var workouts: [WorkoutData]

    @State private var isShowingBug = false
    private let alertTitle = "문제가 있으신가요?"

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerView
                if workouts.isEmpty {
                    emptyStateView
                } else {
                    contentView
                    Spacer()
                        .frame(height: 80)
                    AnalyticsView()
                }
            }
        }
        .refreshable {
            await healthInteractor.fetchWorkoutData()
        }
        .padding(.horizontal)
        .navigationTitle("")
    }

    private var headerView: some View {
        HStack {
            soundButton
            Spacer()
            bugButton
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }

    private var soundButton: some View {
        Button {
            soundManager.toggleMusic()
        } label: {
            HStack {
                Image(systemName: soundManager.isMusicPlaying ? "speaker" : "speaker.slash")
                Text(soundManager.isMusicPlaying ? "On" : "Off")
            }
            .padding(.horizontal)
            .font(.mainInfoText)
            .overlay {
                Capsule()
                    .stroke()
                    .frame(height: 24)
            }
        }
        .foregroundStyle(.white)
    }

    private var bugButton: some View {
        Button {
            isShowingBug.toggle()
        } label: {
            Image(systemName: "ant")
                .foregroundStyle(.white)
                .font(.mainInfoText)
                .padding()
        }
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.8)
                .frame(height: 24)
        }
        .alert(
            LocalizedStringKey(alertTitle),
            isPresented: $isShowingBug
        ) {
            Button("취소", role: .cancel) {
                isShowingBug.toggle()
            }
            Button("문의하기") {
                let url = createEmailUrl(to: "guryongpo23@gmail.com", subject: "", body: "")
                openURL(urlString: url)
            }
        } message: {
            Text("불편을 드려 죄송합니다. \n\nSoccerBeat의 개발자 계정으로 문의를 주시면 빠른 시일 안에 답변드리겠습니다. ")
        }
    }

    private var emptyStateView: some View {
        EmptyDataView()
              .environmentObject(profileModel)
              .environmentObject(healthInteractor)
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            recentMatchHeaderView
            recentMatchPreview
            allMatchesLink
        }
    }

    private var recentMatchHeaderView: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(workouts[0].yearMonthDay)
                    .font(.mainSubTitleText)
                    .opacity(0.7)
                Text("최근 경기")
                    .font(.mainTitleText)
            }
            Spacer()
            NavigationLink {
                ProfileView()
            } label: {
                CardFront(degree: .constant(0), width: 72, height: 110)
            }
        }
        .padding()
    }

    private var recentMatchPreview: some View {
        let lastWorkoutData = workouts[0]

        return NavigationLink {
            MatchDetailView(workoutData: lastWorkoutData)
        } label: {
            ZStack {
                LightRectangleView(alpha: 0.6, color: .black, radius: 15)
                HStack {
                    VStack {
                        HStack {
                            let recent = DataConverter.toLevels(lastWorkoutData)
                            let average = DataConverter.toLevels(profileModel.averageAbility)

                            ViewControllerContainer(RadarViewController(
                                radarAverageValue: average,
                                radarAtypicalValue: recent
                            ))
                            .scaleEffect(CGSize(width: 0.6, height: 0.6))
                            .padding()
                            .fixedSize()
                            .frame(width: 220, height: 210)

                            Spacer()
                            VStack(alignment: .trailing) {
                                VStack(alignment: .leading) {
                                    Text(currentLocation)
                                        .font(.mainDateLocation)
                                        .foregroundStyle(.mainDateTime)
                                        .opacity(0.8)
                                        .task {
                                            currentLocation = await lastWorkoutData.location
                                        }
                                    Group {
                                        Text("경기 시간")
                                        Text(lastWorkoutData.time)
                                    }
                                    .font(.mainTime)
                                    .foregroundStyle(.mainMatchTime)
                                }
                                Spacer()
                                HStack {
                                    ForEach(lastWorkoutData.matchBadge.indices, id: \.self) { index in
                                        let row = index
                                        let column = lastWorkoutData.matchBadge[index]
                                        if let badgeName = ShortenedBadgeImageDictionary[row][column],
                                           !badgeName.isEmpty {
                                            Image(badgeName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 32, height: 36)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }

    private var allMatchesLink: some View {
        NavigationLink {
            MatchRecapView(userWorkouts: $workouts)
        } label: {
            ZStack {
                LightRectangleView(alpha: 0.15, color: .seeAllMatch, radius: 22)
                    .frame(height: 38)
                HStack {
                    Spacer()
                    Image(systemName: "soccerball")
                    Text("모든 경기 보기 +")
                    Spacer()
                }
                .padding()
            }
        }
    }

    func openURL(urlString: String) {
        if let url = URL(string: "\(urlString)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    func createEmailUrl(to: String, subject: String, body: String) -> String {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
    }
}

#Preview {
    @StateObject var health = HealthInteractor.shared
    @StateObject var sound = SoundManager()
    @StateObject var profileModel = ProfileModel(healthInteractor: .shared)
    @State var workouts = WorkoutData.exampleWorkouts

    return MainView(workouts: $workouts)
        .environmentObject(health)
        .environmentObject(sound)
        .environmentObject(profileModel)
}
