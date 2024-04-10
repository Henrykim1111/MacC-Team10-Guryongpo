//
//  ShareView.swift
//  SoccerBeat
//
//  Created by Hyungmin Kim on 11/12/23.
//
//
//import SwiftUI
//
//struct ShareView: View {
//    @EnvironmentObject var profileModel: ProfileModel
//    @EnvironmentObject var healthInteractor: HealthInteractor
//    @State var geoSize = CGSize(width: 0, height: 0)
//    @State var highresImage = UIImage()
//    @State var renderImage: UIImage?
//    
//    var body: some View {
//        VStack {
//            GeometryReader { geo in
//                TargetImageView(allBadges: profileModel.allBadges, cgSize: geo.size, degree: 0)
//                    .onAppear {
//                        self.geoSize = CGSize(width: geo.size.width, height: geo.size.height)
//                    }
//            }
//        }
//        .toolbar {
//            Button {
//                renderImage = TargetImageView(allBadges: profileModel.allBadges, cgSize: self.geoSize)
//                    .asImage(size: self.geoSize)
//                presentShareSheet()
//            } label: {
//                Text("공유하기")
//                    .foregroundStyle(.shareViewTitleTint)
//            }
//        }
//    }
//    func presentShareSheet() {
//        let activityVC = UIActivityViewController(activityItems: [renderImage], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//    }
//}
//
//extension UIScreen {
//    static let screenWidth = UIScreen.main.bounds.size.width
//    static let screenHeight = UIScreen.main.bounds.size.width
//    static let screenSize = UIScreen.main.bounds.size
//}
//
//extension UIView {
//    func asImage(size: CGSize) -> UIImage {
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = 1
//        return UIGraphicsImageRenderer(size: size, format: format).image { context in
//            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
//        }
//    }
//}
//
//extension View {
//    func asImage(size: CGSize) -> UIImage {
//        let controller = UIHostingController(rootView: self)
//        controller.view.bounds = CGRect(origin: .zero, size: size)
//        let image = controller.view.asImage(size: size)
//        return image
//    }
//}
//
//struct TargetImageView: View {
//    let allBadges: [[Bool]]
//    @EnvironmentObject var healthInteractor: HealthInteractor
//    @State var cgSize: CGSize
//    @State var degree: Double = 0
//    private var userName: String {
//        return UserDefaults.standard.string(forKey: "userName") ?? "닉네임"
//    }
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            Image("BackgroundPattern")
//                .frame(maxHeight: UIScreen.screenHeight)
//            Image("FlameEffect")
//                .frame(maxHeight: UIScreen.screenHeight)
//            VStack {
//                Spacer()
//                HStack(alignment: .bottom) {
//                    CardFront(degree: $degree, width: 100, height: 140)
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("# Soccer Beat")
//                            .floatingCapsuleStyle()
//                        
//                        Spacer()
//                            .frame(height: 20)
//                        
//                        Text("SBeat Card")
//                            .font(.shareViewSubTitle)
//                            .foregroundStyle(.shareViewSubTitleTint)
//                        VStack(alignment: .leading, spacing: -10) {
//                            HStack {
//                                Text(userName)
//                                    .highlighter(activity: .heartrate, isDefault: false)
//                                    .foregroundStyle(.shareViewTitleTint)
//                            }
//                        }
//                        .font(.shareViewTitle)
//                    }
//                    .padding(.leading)
//                }
//                .padding(.horizontal)
//                .padding(.top)
//                
//                Spacer()
//                    .frame(height: 30)
//                
//                currentBadge
//                
//                Spacer()
//            }
//            .padding()
//        }
//    }
//    private func floatingBadgeInfo(at sort: Int) -> some View {
//        var message: String {
//            switch sort {
//            case 0:
//                return "뛴 거리에 따라 획득하는 뱃지입니다."
//            case 1:
//                return "스프린트 횟수에 따라 획득하는 뱃지입니다."
//            default: // 2
//                return "최고 속도에 따라 획득하는 뱃지입니다."
//            }
//        }
//        return Text(message)
//            .padding(.horizontal, 8)
//            .floatingCapsuleStyle()
//    }
//}
//
//extension TargetImageView {
//    @ViewBuilder
//    private var currentBadge: some View {
//        VStack(alignment: .leading, spacing: 31) {
//            ForEach(0..<allBadges.count) { sortIndex in
//                VStack(alignment: .leading, spacing: 10) {
//                    floatingBadgeInfo(at: sortIndex)
//                    HStack {
//                        ForEach(0..<allBadges[sortIndex].count, id: \.self) { levelIndex in
//                            let isOpened = allBadges[sortIndex][levelIndex]
//                            
//                            TrophyView(sort: sortIndex, level: levelIndex, isOpened: isOpened)
//                                .frame(width: 74, height: 82)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ShareView()
//        .environmentObject(ProfileModel(healthInteractor: HealthInteractor()))
//}


import SwiftUI
import Photos

struct ShareView: View {
    @EnvironmentObject var profileModel: ProfileModel
    @EnvironmentObject var healthInteractor: HealthInteractor
    @State var degree: Double = 0
    @State private var showingAlert: Bool = false
    
    private var userName: String {
        return UserDefaults.standard.string(forKey: "userName") ?? "닉네임"
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("BackgroundPattern")
                .frame(maxHeight: UIScreen.screenHeight)
            Image("FlameEffect")
                .frame(maxHeight: UIScreen.screenHeight)
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    CardFront(degree: $degree, width: 100, height: 140)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("# Soccer Beat")
                            .floatingCapsuleStyle()
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("SBeat Card")
                            .font(.shareViewSubTitle)
                            .foregroundStyle(.shareViewSubTitleTint)
                        VStack(alignment: .leading, spacing: -10) {
                            HStack {
                                Text(userName)
                                    .highlighter(activity: .heartrate, isDefault: false)
                                    .foregroundStyle(.shareViewTitleTint)
                            }
                        }
                        .font(.shareViewTitle)
                    }
                    .padding(.leading)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                    .frame(height: 30)
                
                currentBadge
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            Button {
                share()
            } label: {
                Text("공유하기")
                    .foregroundStyle(.shareViewTitleTint)
            }
        }
    }
    private func floatingBadgeInfo(at sort: Int) -> some View {
        var message: String {
            switch sort {
            case 0:
                return "뛴 거리에 따라 획득하는 뱃지입니다."
            case 1:
                return "스프린트 횟수에 따라 획득하는 뱃지입니다."
            default: // 2
                return "최고 속도에 따라 획득하는 뱃지입니다."
            }
        }
        return Text(message)
            .padding(.horizontal, 8)
            .floatingCapsuleStyle()
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.width
    static let screenSize = UIScreen.main.bounds.size
}

extension ShareView {
    @ViewBuilder
    private var currentBadge: some View {
        VStack(alignment: .leading, spacing: 31) {
            ForEach(0..<profileModel.allBadges.count) { sortIndex in
                VStack(alignment: .leading, spacing: 10) {
                    floatingBadgeInfo(at: sortIndex)
                    HStack {
                        ForEach(0..<profileModel.allBadges[sortIndex].count, id: \.self) { levelIndex in
                            let isOpened = profileModel.allBadges[sortIndex][levelIndex]
                            
                            TrophyView(sort: sortIndex, level: levelIndex, isOpened: isOpened)
                                .frame(width: 74, height: 82)
                        }
                    }
                }
            }
        }
    }
}

extension ShareView {
    func screenShot() {
        let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
        UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
        
        PHPhotoLibrary.requestAuthorization( { status in
            switch status {
            case .authorized:
                showingAlert = true
            case .denied:
                break
            case .restricted, .notDetermined:
                break
            default:
                break
            }
        })
    }
    
    func share() {
        let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
    }
}

extension UIView {
    var screenShot: UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return capturedImage
    }
}

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.screenShot
    }
}


#Preview {
    ShareView()
        .environmentObject(ProfileModel(healthInteractor: HealthInteractor()))
}
