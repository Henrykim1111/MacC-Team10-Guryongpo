//
//  ProfileView.swift
//  SoccerBeat
//
//  Created by daaan on 11/17/23.
//

import SwiftUI

struct ProfileView: View {
    @State var isFlipped: Bool = false
    @StateObject var viewModel = ProfileModel()
    @State var userName: String = ""
    
    var body: some View {
        ScrollView {
            ZStack {
                BackgroundImageView()
                    
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            
                            HStack {
                                Text("# 나만의 선수 카드를 만들어 보세요.")
                                    .floatingCapsuleStyle()
                                Spacer()
                            }                            .padding(.leading)
                            
                            Text("\n")
                            
                            VStack(alignment: .leading, spacing: 0.0) {
                                
                                HStack {
                                    Text("마이 프로필")
                                        .font(.custom("SFProText-HeavyItalic", size: 24))
                                        .foregroundStyle(.shareViewSubTitleTint)
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    TextField("Name", text: $userName)
                                        .onChange(of: userName) { _ in
                                            UserDefaults.standard.set(userName, forKey: "userName")
                                        }
                                    
                                    
                                    Text("How we are")
                                        .offset(y: -10)
                                }
                            }
                            .font(.custom("SFProText-HeavyItalic", size: 36))
                            .padding(.leading)
                            .padding(.leading)
                            
                            
                            HStack {
                                Text("# 파랑색은 시즌 최고 능력치입니다.")
                                    .floatingCapsuleStyle()
                                Spacer()
                            }                           .padding(.leading)
                            
                            HStack {
                                Text("# 민트색은 평균 능력치입니다.")
                                    .floatingCapsuleStyle()
                                Spacer()
                            }                            .padding(.leading)
                        }
                        
                            VStack {
                                MyCardView(isFlipped: $isFlipped, viewModel: viewModel)
                                PhotoSelectButtonView(viewModel: viewModel)
                                    .opacity(isFlipped ? 1 : 0)
                            }.frame(maxWidth: 112)
                    }
                    
                    
                    Spacer()
                    
                    let average = [3.0, 2.4, 3.4, 3.2, 2.8, 3.3]
                    let recent = [4.1, 3.0, 3.5, 3.8, 3.5, 2.8]
                    
                    ViewControllerContainer(RadarViewController(radarAverageValue: average, radarAtypicalValue: recent))
                        .fixedSize()
                        .frame(width: 360, height: 360)
                    
                    HStack {
                        Text("# 경기를 통해 획득한 트로피를 만나보세요.")
                            .floatingCapsuleStyle()
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("경기의 순간들")
                            .font(.custom("SFProText-HeavyItalic", size: 24))
                            .foregroundStyle(.shareViewSubTitleTint)
                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.leading)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0.0) {
                            Text("My")
                            Text("Trophy Collection")
                        }
                        .font(.custom("SFProText-HeavyItalic", size: 36))
                        .kerning(-1.5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("# 경기 중 체력에 따라 획득하는 트로피입니다.")
                            .floatingCapsuleStyle()
                        Spacer()
                    }
                    .padding(.leading)
                    
                    HStack {
                        Text("# 경기 중 스프린트에 따라 획득하는 트로피입니다.")
                            .floatingCapsuleStyle()
                        Spacer()
                    }.padding(.leading)
                    
                    HStack {
                        Text("# 경기 중 속도에 따라 획득하는 트로피입니다.")
                            .floatingCapsuleStyle()
                        Spacer()
                    }.padding(.leading)
                    
                }
            }
        }.onAppear {
            userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        }
    }
}

#Preview {
    ProfileView()
}
