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
    var workout: WorkoutData?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack {
                    MatchTimeView(workout: workout)
                    Spacer()
                        .frame(height: 48)
                    ErrorView(workout: workout)
                    PlayerAbilityView(workout: workout)
                        .zIndex(-1)
                    Spacer()
                        .frame(height: 100)
                    FieldRecordView(workout: workout)
                    Spacer()
                        .frame(height: 100)
                    FieldMovementView(workout: workout)
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct ErrorView: View {
    var workout: WorkoutData?
    
    var body: some View {
        if let workout = workout {
            if !workout.error {
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
    var workout: WorkoutData?
    
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
                    if let workout = workout {
                        Text(" \(workout.time)")
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
    var workout: WorkoutData?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    
                    Spacer()
                        .frame(minHeight: 30)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 0) {
                            // 현재 빨간색이 이번경기로 보이고, 민트색이 평균으로 보임
                            // 빨강 - 평균, 민트색 - 이번 경기 로 해야함
                            Text("빨간색")
                                .bold()
                                .foregroundStyle(.matchDetailViewTitleColor)
                            Text("은 경기의 평균 능력치입니다.")
                        }
                        .floatingCapsuleStyle()
                        
                        HStack(spacing: 0) {
                            Text("민트색")
                                .bold()
                                .foregroundStyle(.matchDetailViewAverageStatColor)
                            Text("은 이번 경기의 능력치입니다.")
                        }
                        .floatingCapsuleStyle()
                    }
                    HStack {
                        Spacer()
                        if let workout = workout {
                            let recent = DataConverter.toLevels(workout)
                            let average = DataConverter.toLevels(profileModel.averageAbility)
                            
                            ViewControllerContainer(RadarViewController(radarAverageValue: average, radarAtypicalValue: recent, error: workout.error))
                                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                                .padding()
                                .fixedSize()
                                .frame(width: 304, height: 348)
                                .zIndex(-1)
                        } else {
                            let blankRecent = DataConverter.toLevels(WorkoutData.blankExample)
                            let blankAverage = DataConverter.toLevels(WorkoutAverageData.blankAverage)
                            
                            ViewControllerContainer(RadarViewController(radarAverageValue: blankAverage, radarAtypicalValue: blankRecent, error: true))
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
    var workout: WorkoutData?
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
                if let workout = workout {
                    if !workout.error {
                        ForEach(workout.matchBadge.indices, id: \.self) { index in
                            if let badgeName = BadgeImageDictionary[index][workout.matchBadge[index]] {
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
            FieldRecordDataView(workout: workout)
            
            Spacer()
                .frame(minHeight: 30)
            
            if let rates = workout?.heartRates {
                if !rates.isEmpty {
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            VStack(alignment: .leading, spacing: -8) {
                                Text("Heartbeat")
                            }
                            .font(.matchDetailTitle)
                        }
                        Spacer()
                    }

                    HeartRatesView(rates: rates)
                        .frame(height: 200)
                        .padding(.vertical)
                }
            }
        }
    }
}

struct FieldMovementView: View {
    var workout: WorkoutData?
    @State var isInfoOpen: Bool = false
    @State private var slider = 0.0
    private let emptyDataRoute: [CLLocationCoordinate2D] = []
    private let emptyDataCenter: [Double] = [0, 0]
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        InformationButton(message: "슬라이더를 움직여 경기 중 위치를 확인해보세요.")
                        Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Field Movement")
                            .font(.matchDetailTitle)
                    }
                }
            }
            if let workout = workout {
                HeatmapView(slider: $slider, coordinate: CLLocationCoordinate2D(latitude: workout.center[0], longitude: workout.center[1]), polylineCoordinates: workout.route)
                    .frame(height: 500)
                    .cornerRadius(15.0)
                
                Slider(
                    value: $slider,
                    in: 0...1
                )
                .padding(.vertical)
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
    return MatchDetailView(workout: WorkoutData.blankExample)
        .environmentObject(ProfileModel(healthInteractor: HealthInteractor()))
        .environmentObject(HealthInteractor())
}

struct FieldRecordDataView: View {
    var workout: WorkoutData?
    var body: some View {
        ZStack {
            LightRectangleView(alpha: 0.4, color: .black, radius: 15)
            
            HStack(alignment: .center, spacing: 50) {
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("뛴 거리")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom, spacing: 0) {
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.distance.formatted())
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
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.sprint.formatted())
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
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.minHeartRate.formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text("Bpm")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
//                    VStack(alignment: .leading) {
//                        Text("칼로리")
//                            .font(.fieldRecordTitle)
//                        HStack(alignment: .bottom, spacing: 0) {
//                            if let workout = workout {
//                                Text(workout.error ? "--" : workout.calories.formatted())
//                                    .font(.fieldRecordMeasure)
//                            } else {
//                                Text("--")
//                            }
//                            Text(" kcal")
//                                .font(.fieldRecordUnit)
//                        }
//                    }
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("최고 속도")
                            .font(.fieldRecordTitle)
                        HStack(alignment: .bottom,spacing: 0) {
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.velocity.formatted())
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
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.power.rounded(at: 1)).font(.fieldRecordMeasure)
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
                            if let workout = workout {
                                Text(workout.error ? "--" : workout.maxHeartRate.formatted())
                                    .font(.fieldRecordMeasure)
                            } else {
                                Text("--")
                            }
                            Text(" Bpm")
                                .font(.fieldRecordUnit)
                        }
                    }
                    
//                    VStack(alignment: .leading) {
//                        Text("최대 산소 섭취량")
//                            .font(.fieldRecordTitle)
//                        HStack(alignment: .bottom, spacing: 0) {
//                            if let workout = workout {
//                                Text(workout.error ? "--" : workout.vo2Max.formatted())
//                                    .font(.fieldRecordMeasure)
//                            } else {
//                                Text("--")
//                            }
//                            Text(" ml/kg/min")
//                                .font(.fieldRecordUnit)
//                        }
//                    }
                }
            }
            .padding(.vertical, 56)
            .padding(.horizontal, 20)
        }
        .kerning(-0.41)
    }
}
