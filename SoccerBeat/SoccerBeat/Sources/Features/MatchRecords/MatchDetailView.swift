//
//  MatchDetailView.swift
//  SoccerBeat
//
//  Created by Hyungmin Kim on 2023/10/22.
//

import SwiftUI
import Charts
import CoreLocation

struct MatchDetailView: View {
    @Binding var workouts: [WorkoutData]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack {
                    MatchTimeView(workouts: $workouts)
                    Spacer()
                        .frame(height: 48)
                    ErrorView(workouts: $workouts)
                    PlayerAbilityView(workouts: $workouts)
                        .zIndex(-1)
                    Spacer()
                        .frame(height: 100)
                    FieldRecordView(workouts: $workouts)
                    Spacer()
                        .frame(height: 100)
                    FieldMovementView(workouts: $workouts)
                        .padding()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

struct ErrorView: View {
    @Binding var workouts: [WorkoutData]
    
    var body: some View {
        if !workouts.isEmpty {
            if !workouts[0].error {
                EmptyView()
            } else {
                VStack {
                    Image(.errormark)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 74, height: 80)
                        .padding()
                    Text("데이터에 오류가 발생했습니다. ")
                        .font(.averageValue)
                        .foregroundStyle(.white)
                        .padding(2)
                    Text("건강 및 위치 권한을 재확인하거나")
                    Text("삭제 및 재설치를 권장드립니다.")
                }
                .font(.fieldRecordTitle)
                .foregroundStyle(.mainSubTitleColor)
                .padding(32)
            }
        } else {
            EmptyView()
        }
    }
}

struct MatchTimeView: View {
    @Binding var workouts: [WorkoutData]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                InformationButton(message: "경기의 상세 리포트를 만나보세요.")
                Spacer()
            }
            .zIndex(1)
            
            VStack(alignment: .leading, spacing: -8) {
                HStack(spacing: 0) {
                    Text("경기 시간")
                    if !workouts.isEmpty {
                        Text(" \(workouts[0].time)")
                    } else {
                        Text(" --:--")
                    }
                }
            }
            .font(.matchDetailTitle)
        }
        Spacer()
    }
}

struct PlayerAbilityView: View {
    @EnvironmentObject var profileModel: ProfileModel
    @Binding var workouts: [WorkoutData]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    
                    Spacer()
                        .frame(minHeight: 30)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 0) {
                            Text("빨간색")
                                .bold()
                                .foregroundStyle(.matchDetailViewTitleColor)
                            Text("은 이번 경기의 능력치입니다.")
                        }
                        .floatingCapsuleStyle()
                        
                        HStack(spacing: 0) {
                            Text("민트색")
                                .bold()
                                .foregroundStyle(.matchDetailViewAverageStatColor)
                            Text("은 경기의 평균 능력치입니다.")
                        }
                        .floatingCapsuleStyle()
                    }
                    HStack {
                        Spacer()
                        if !workouts.isEmpty {
                            let recent = DataConverter.toLevels(workouts[0])
                            let average = DataConverter.toLevels(profileModel.averageAbility)
                            
                            ViewControllerContainer(RadarViewController(radarAverageValue: average, radarAtypicalValue: recent))
                                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                                .padding()
                                .fixedSize()
                                .frame(width: 304, height: 348)
                                .zIndex(-1)
                        } else {
                            let blankRecent = DataConverter.toLevels(WorkoutData.blankExample)
                            let blankAverage = DataConverter.toLevels(WorkoutAverageData.blankAverage)
                            
                            ViewControllerContainer(RadarViewController(radarAverageValue: blankAverage, radarAtypicalValue: blankRecent))
                                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                                .padding()
                                .fixedSize()
                                .frame(width: 304, height: 348)
                                .zIndex(-1)
                            
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
}

struct FieldRecordView: View {
    @Binding var workouts: [WorkoutData]
    @State var isInfoOpen: Bool = false
    var body: some View {
        VStack {
            HStack {
                InformationButton(message: "경기의 상세 데이터에 따라 뱃지가 수여됩니다.")
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading, spacing: -8) {
                        Text("Field Record")
                    }
                    .font(.matchDetailTitle)
                }
                Spacer()
            }
            Spacer()
                .frame(minHeight: 30)
            HStack {
                if !workouts.isEmpty {
                    if !workouts[0].error {
                        ForEach(workouts[0].matchBadge.indices, id: \.self) { index in
                            if let badgeName = BadgeImageDictionary[index][workouts[0].matchBadge[index]] {
                                if badgeName.isEmpty {
                                    EmptyView()
                                } else {
                                    Image(badgeName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 74, height: 82)
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    } else {
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }
            }
            FieldRecordDataView(workouts: $workouts)
        }
    }
}

struct FieldMovementView: View {
    @Binding var workouts: [WorkoutData]
    @State var isInfoOpen: Bool = false
    @State private var slider = 0.0
    private let emptyDataRoute: [CLLocationCoordinate2D] = []
    private let emptyDataCenter: [Double] = [0, 0]
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        InformationButton(message: "설정에서 '정확한 위치'를 허용하면 보다 정확한 데이터를 얻을 수 있어요.")
                        Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Field Movement")
                            .font(.matchDetailTitle)
                    }
                }
            }
            if !workouts.isEmpty {
                HeatmapView(slider: $slider, coordinate: CLLocationCoordinate2D(latitude: workouts[0].center[0], longitude: workouts[0].center[1]), polylineCoordinates: workouts[0].route)
                    .frame(height: 500)
                    .cornerRadius(15.0)
                
                Slider(
                    value: $slider,
                    in: 0...1
                )
            } else {
                HeatmapView(slider: $slider, coordinate: CLLocationCoordinate2D(latitude: emptyDataCenter[0], longitude: emptyDataCenter[1]), polylineCoordinates: emptyDataRoute)
            }
            
        }
        
        Spacer()
            .frame(height: 60)
    }
}

#Preview {
    @StateObject var healthInteractor = HealthInteractor.shared
    return MatchDetailView(workouts: .constant(WorkoutData.exampleWorkouts))
        .environmentObject(ProfileModel(healthInteractor: HealthInteractor()))
        .environmentObject(HealthInteractor())
}

struct FieldRecordDataView: View {
    @Binding var workouts: [WorkoutData]
    var body: some View {
        ZStack {
            LightRectangleView(alpha: 0.4, color: .black, radius: 15)
            
            HStack(alignment: .center, spacing: 50) {
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("뛴 거리")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom, spacing: 0) {
                            if !workouts.isEmpty {
                                Text(workouts[0].distance.formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text(" km")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("스프린트")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom, spacing: 0) {
                            if !workouts.isEmpty {
                                Text(workouts[0].sprint.formatted())
                                    .font(.fieldRecordMeasure)
                            }  else {
                                Text("--")
                            }
                            Text(" Times")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("최소 심박수")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom, spacing: 0) {
                            if !workouts.isEmpty {
                                Text(workouts[0].minHeartRate.formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text(" Bpm")
                                .font(.fieldRecordUnit)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("최고 속도")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom,spacing: 0) {
                            if !workouts.isEmpty {
                                Text(Int(workouts[0].velocity).formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text(" km/h")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("파워")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom,spacing: 0) {
                            if !workouts.isEmpty {
                                Text(workouts[0].power.rounded(at: 1))
                                    .font(.fieldRecordMeasure)
                            }  else {
                                Text("--")
                            }
                            Text(" w")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("최대 심박수")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom, spacing: 0) {
                            if !workouts.isEmpty {
                                Text(workouts[0].maxHeartRate.formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text(" Bpm")
                                .font(.fieldRecordUnit)
                        }
                    }
                }
            }
            .padding(.vertical, 56)
            .padding(.horizontal, 20)
        }
        .kerning(-0.41)
    }
}
