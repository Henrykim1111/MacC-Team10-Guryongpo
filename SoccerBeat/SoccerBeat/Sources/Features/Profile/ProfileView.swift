//
//  ProfileView.swift
//  SoccerBeat
//
//  Created by daaan on 11/17/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileModel: ProfileModel
    @State private var isFlipped = false
    @State private var userName = ""
    @State private var userImage: UIImage?
    @FocusState private var isFocused: Bool
    let nameLength = 15
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                InformationButton(message: "나의 선수 카드와 최대 능력치를 만나보세요.")
                                Spacer()
                            }
                            .padding(.top, 48)
                            .padding(.bottom, 30)
                            
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("선수 프로필")
                                            .font(.matchDetailSubTitle)
                                            .foregroundStyle(.shareViewSubTitleTint)
                                        Spacer()
                                    }
                                    
                                    VStack(spacing: 0) {
                                        ZStack {
                                            if !userName.isEmpty {
                                                Text(userName)
                                                    .foregroundStyle(.clear)
                                                    .padding(.horizontal)
                                                    .frame(height: 40)
                                                    .overlay {
                                                        Capsule()
                                                            .stroke(style: .init(lineWidth: 0.8))
                                                            .frame(height: 40)
                                                            .foregroundColor(userName.count >= nameLength + 1 ? .red : .brightmint)
                                                    }
                                            }
                                            
                                            TextField("Name", text: $userName)
                                                .padding(.horizontal)
                                                .frame(height: 40)
                                                .limitText($userName, to: nameLength)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(1)
                                                .onChange(of: userName) { _ in
                                                    UserDefaults.standard.set(userName, forKey: "userName")
                                                }
                                        }
                                    }
                                    .offset(y: 24)
                                    
                                    VStack {
                                        MyCardView(isFlipped: $isFlipped)
                                            .frame(width: 210)
                                        PhotoSelectButtonView(profileModel: profileModel)
                                            .opacity(isFlipped ? 1 : 0)
                                            .padding(.top, 10)
                                    }
                                    .offset(y: 16)

                                }
                                .font(.custom("SFProDisplay-HeavyItalic", size: 36))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 110)
                    
                    VStack(spacing: 6) {
                        HStack {
                            HStack(spacing: 0) {
                                Text("")
                                Text("파란색")
                                    .bold()
                                    .foregroundStyle(
                                        .raderMaximumColor)
                                Text("은 시즌 최고 능력치입니다.")
                            }
                            .floatingCapsuleStyle()
                            Spacer()
                        }
                        
                        HStack {
                            HStack(spacing: 0) {
                                Text("")
                                Text("민트색")
                                    .bold()
                                    .foregroundStyle(.matchDetailViewAverageStatColor)
                                Text("은 경기 평균 능력치입니다.")
                            }
                            .floatingCapsuleStyle()
                            Spacer()
                        }
                    }
                    
                    let average = DataConverter.toLevels(profileModel.averageAbility)
                    let maximumAbility = DataConverter.toLevels(profileModel.maxAbility)
                    
                    ViewControllerContainer(ProfileViewController(radarAverageValue: average, radarAtypicalValue: maximumAbility))
                        .fixedSize()
                        .frame(width: 304, height: 348)
                        .zIndex(-1)
                    
                    Spacer()
                        .frame(height: 110)
                    
                    TrophyCollectionView()
                    
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .onAppear {
                userName = UserDefaults.standard.string(forKey: "userName") ?? ""
            }
        }
        .toolbar {
            NavigationLink {
                ShareView()
            } label: {
                Text("공유하기")
                    .foregroundStyle(.shareViewTitleTint)
            }
        }
        .navigationTitle("")
        .padding()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
