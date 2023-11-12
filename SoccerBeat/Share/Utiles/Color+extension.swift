//
//  Color+extension.swift
//  SoccerBeat Watch App
//
//  Created by Gucci on 10/22/23.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    
    // MARK: - Color init
    
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    // MARK: - Sprint Progress
    
    static var gaugeBackground: Self { Self(hex: 0xD9D9D9, alpha: 0.3) }
    static var precountTint: Self { Self(hex: 0x0EB7FF, alpha: 0.95) }
    
    static var pauseTint: Self { Self(hex: 0x1CBBFF)}
    static var stopTint: Self { Self(hex: 0x4C67F4)}
    
    // MARK: - HeartRate Tint
    
    static var zone1Tint: Self { .init(hex: 0xFFE603) }
    static var zone2Tint: Self { .init(hex: 0x03B3FF) }
    static var zone3Tint: Self { .init(hex: 0x03FFC3) }
    static var zone4Tint: Self { .init(hex: 0xFF00B8) }
    static var zone5Tint: Self { .init(hex: 0xFF4003) }
    
    static var zone3MiddleTint: Self { .init(hex: 0x03BBF9, alpha: 0.4109) }
    
    static var zone1StartTint: Self { .init(hex: 0xFFE603, alpha: 0.35) }
    static var zone2StartTint: Self { .init(hex: 0x03B3FF, alpha: 0.35) }
    static var zone3StartTint: Self { .init(hex: 0x03B3FF, alpha: 0.35) }
    static var zone4StartTint: Self { .init(hex: 0xFF00B8, alpha: 0.35) }
    static var zone5StartTint: Self { .init(hex: 0xFF4003, alpha: 0.35) }
    
    // MARK: - GameProgressView
    
    static var ongoingText: Self { .init(hex: 0xDFDFDF) }
    static var ongoingNumber: Self { .white }
    static var inactiveZone: Self { .init(hex: 0x757575)}
    static var currentZoneStroke: Self { .init(hex: 0xB1B1B1) }
    static var currentZoneText: Self { .init(hex: 0xCACACA) }
    
    // MARK: - SummaryView
    
    static var columnTitle: Self { .init(hex: 0x474747) }
    static var columnContent: Self { .init(hex: 0x242424) }
    static var columnFoot: Self { .init(hex: 0xAEB4BF) }

    // MARK: - SplitControlsView
    
    static var circleBackground: Self { .init(hex: 0xD9D9D9, alpha: 0.2) }
}

extension ShapeStyle where Self == LinearGradient {
    
    // MARK: - PreCountView
    
    static var precountGradient: Self {
        return .linearGradient(colors: [.precountTint, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // MARK: - SummaryView
    
    static var summaryGradient: Self {
        return .linearGradient(colors: [.white, .zone2Tint],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // MARK: - HeartRate BPM
    
    static var zone1Bpm: Self {
        .linearGradient(colors: [.zone1Tint, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var zone2Bpm: Self {
        .linearGradient(colors: [.zone2Tint, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var zone3Bpm: Self {
        .linearGradient(colors: [.zone3Tint, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var zone4Bpm: Self {
        .linearGradient(colors: [.zone4Tint, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var zone5Bpm: Self {
        .linearGradient(colors: [.zone5Tint, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // MARK: - HeartRate Current Zone Bar
    
    static var zone1CurrentZoneBar: Self {
        LinearGradient(stops: [
            .init(color: .zone1StartTint, location: 0.2),
            .init(color: .zone1Tint, location: 0.9)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    static var zone2CurrentZoneBar: Self {
        LinearGradient(stops: [
            .init(color: .zone2StartTint, location: 0.2),
            .init(color: .zone2Tint, location: 0.9)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    static var zone3CurrentZoneBar: Self {
        LinearGradient(stops: [
            .init(color: .zone3StartTint, location: 0.2),
            .init(color: .zone3MiddleTint, location: 0.25),
            .init(color: .zone3Tint, location: 0.95)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    static var zone4CurrentZoneBar: Self {
        LinearGradient(stops: [
            .init(color: .zone4StartTint, location: 0.2),
            .init(color: .zone4Tint, location: 0.9)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    static var zone5CurrentZoneBar: Self {
        LinearGradient(stops: [
            .init(color: .zone5StartTint, location: 0.2),
            .init(color: .zone5Tint, location: 0.9)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    // MARK: - Stop State
    
    static var stopCurrentZoneBar: Self {
        let start = Color(hex: 0x000000, alpha: 0.35)
        let end = Color(hex: 0x838383)
        return LinearGradient(stops: [
            .init(color: start, location: 0.2),
            .init(color: end, location: 0.9)
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    static var stopBpm: Self {
        let start = Color(hex: 0x333333)
        return .linearGradient(colors: [start, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // MARK: - MatchTotalView
    
    static var matchTotalTitle: Self {
        let start = Color(hex: 0xFF00B8)
        return .linearGradient(colors: [start, .white],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static var matchTotalSectionHeader: Self {
        let start = Color(hex: 0xFFFFFF)
        let end = Color(hex: 0xFFFFFF).opacity(0.5)
        return .linearGradient(colors: [start, end],
                               startPoint: .leading, endPoint: .trailing)
    }
    
    // MARK: - GameProgressView
    static var playTimeNumber: Self {
        let start = Color(hex: 0x333333)
        let end = Color(hex: 0xFFFFFF)
        return .linearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
