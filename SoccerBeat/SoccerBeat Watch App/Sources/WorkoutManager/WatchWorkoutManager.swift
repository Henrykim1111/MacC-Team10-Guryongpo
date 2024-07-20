//
//  WatchWorkoutManager.swift
//  SoccerBeat Watch App
//
//  Created by jose Yun on 10/21/23.
//

import Combine
import CoreLocation
import HealthKit
import SwiftUI

final class WorkoutManager: NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private(set) var locationManager = CLLocationManager()
    private(set) var matrics: MatricsIndicator

    init(matrics: MatricsIndicator) {
        self.matrics = matrics
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
    }

    // 헬스킷 세션 기록용 빌더 선언
    private(set) var session: HKWorkoutSession?
    private(set) var builder: HKLiveWorkoutBuilder?
    private(set) var routeBuilder: HKWorkoutRouteBuilder?

    private let typesToShare: Set = [HKQuantityType.workoutType(),
                                     HKSeriesType.workoutRoute(),
                                     HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
                                     HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

    ]

    private let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
        HKQuantityType.quantityType(forIdentifier: .walkingSpeed)!,
        HKQuantityType.quantityType(forIdentifier: .runningPower)!,
        HKSeriesType.workoutType(),
        HKSeriesType.workoutRoute(),
        HKObjectType.activitySummaryType()
    ]

    @Published var workout: HKWorkout?
    // TODO: - 나중에 워치에서 경기 끝나고 바로 찍어볼 수 있게 지도 그리기
    @Published var route: HKWorkoutRoute?

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    @Published var hasLocationAuthorization = false

    // `authorizationStatus` API로는 readType에 대한 확인이 불가함
    var hasHealthAuthorization: Bool {
        for shareType in typesToShare
        where healthStore.authorizationStatus(for: shareType) == .sharingDenied {
            return false
        }
        return true
    }

    // 세션 시작과 종료 시에 뷰 관리 변수
    @Published var showingPrecount = false
    @Published var showingSummaryView = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }

    // MARK: - 데이터 선언 및 초기화
    /// 데이터 기록을 위한 초기 설정
    private let heartRateQuantity = HKUnit(from: "count/min")
    private let meterUnit = HKUnit.meter()

    private func setupWorkoutConfig() {
        // workout configuration 설정
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        // TODO: - .indoor 하면 실내 풋살 가능?
        configuration.locationType = .outdoor

        // 세션, 빌더, 루트 빌더, 로케이션 매니저 초기화
        do {
            session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration
            )
        } catch {
            // session init은 실패할 가능성이 없어요. 저렇게 `.running` 처럼 점을 찍어서 선언하면 말이죠.
            NSLog(error.localizedDescription)
        }
        builder = session?.associatedWorkoutBuilder()
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
        // 델리게이트 선언
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)

    }

    private func startWorkoutSession() {
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (_, _) in
            // The workout has started.
        }
        // 위치 정보 수집
        locationManager.startUpdatingLocation()

        // 헬스킷에서 나이 정보를 통해 적절한 최대심박수 찾기
        matrics.computeProperMaxHeartRate(with: healthStore)
    }

    enum SessionError: Error {
        case failureBuilderEnd
        case failureFinishWorkout
        case failureMakeRoute
    }

    func endWorkoutSession(_ date: Date) async throws {
        do {
            try await builder?.endCollection(at: date)
        } catch {
            throw SessionError.failureBuilderEnd
        }

        guard let workout = try await builder?.finishWorkout() else {
            throw SessionError.failureFinishWorkout
        }
        Task { @MainActor in
            self.workout = workout
        }

        let metadata = self.matrics.getMetadata()

        guard let route = try await routeBuilder?.finishRoute(
            with: workout,
            metadata: metadata
        ) else {
            throw SessionError.failureMakeRoute
        }
        Task { @MainActor in
            self.route = route
        }
    }

    // MARK: - 데이터 수집 및 경기 시작
    func startWorkout() {
        setupWorkoutConfig()
        startWorkoutSession()
    }

    // MARK: - 세션 관리
    @Published var running = false
    
    func togglePause() {
        running ? pause() : resume()
    }
    
    private func pause() {
        session?.pause()
    }
    
    private func resume() {
        session?.resume()
    }
    
    func endWorkout() {
        session?.endCurrentActivity(on: .now)
    }
    
    // 두 부분으로 나누기
    func resetWorkout() {
        builder = nil
        workout = nil
        session = nil
        
        matrics.reset()
    }
    

    private func readRoutes() {
        guard let route else { return }
        let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNil, done, errorOrNil) in

            if let error = errorOrNil {
                return
            }

            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }

            // Do something with this batch of location data.
            // HealthKit에서 얻는 정확성 50m 혹은 그보다 적다고 합니다.
            // 지도에 라인이나 점을 찍기에는 추가적인 작업이 필요하다네요.
            // 여기서 locations를 찍어보면 돼요.

            /* 예시
             for loc in locations {
                 print(loc.coordinate.latitude)
                 print(loc.coordinate.longitude)
             }
             */
        }
        healthStore.execute(query)
    }
}
