//
//  BadgeImages.swift
//  SoccerBeat
//
//  Created by Hyungmin Kim on 11/20/23.
//

import Foundation

let BadgeImageDictionary: [[Int: String]] = [[
    -1: "",
     0: "Distance_Unlocked_1",
     1: "Distance_Unlocked_2",
     2: "Distance_Unlocked_3",
     3: "Distance_Unlocked_4"
], [
    -1: "",
     0: "Sprint_Unlocked_1",
     1: "Sprint_Unlocked_2",
     2: "Sprint_Unlocked_3",
     3: "Sprint_Unlocked_4"
], [
    -1: "",
     0: "Velocity_Unlocked_1",
     1: "Velocity_Unlocked_2",
     2: "Velocity_Unlocked_3",
     3: "Velocity_Unlocked_4"
]
]

let ShortenedBadgeImageDictionary: [[Int: String]] = [[
    -1: "",
     0: "Distance_Shortened_1",
     1: "Distance_Shortened_2",
     2: "Distance_Shortened_3",
     3: "Distance_Shortened_4"
], [
    -1: "",
     0: "Sprint_Shortened_1",
     1: "Sprint_Shortened_2",
     2: "Sprint_Shortened_3",
     3: "Sprint_Shortened_4"
], [
    -1: "",
     0: "Velocity_Shortened_1",
     1: "Velocity_Shortened_2",
     2: "Velocity_Shortened_3",
     3: "Velocity_Shortened_4"
]
]

let badgeUnlockedImages: [[String]] = [
    ["Distance_Unlocked_1", "Distance_Unlocked_2", "Distance_Unlocked_3", "Distance_Unlocked_4"],
    ["Sprint_Unlocked_1", "Sprint_Unlocked_2", "Sprint_Unlocked_3", "Sprint_Unlocked_4"],
    ["Velocity_Unlocked_1", "Velocity_Unlocked_2", "Velocity_Unlocked_3", "Velocity_Unlocked_4"]
]

let badgeLockedImages: [[String]] = [
    ["Distance_Locked_1", "Distance_Locked_2", "Distance_Locked_3", "Distance_Locked_4"],
    ["Sprint_Locked_1", "Sprint_Locked_2", "Sprint_Locked_3", "Sprint_Locked_4"],
    ["Velocity_Locked_1", "Velocity_Locked_2", "Velocity_Locked_3", "Velocity_Locked_4"]
]

let badgeInfo: [[String]] = [
    ["Distance\nOver 1 km", "Distance\nOver 2 km", "Distance\nOver 3 km", "Distance\nOver 4 km"],
    ["Sprint\nOver 1 time", "Sprint\nOver 3 times", "Sprint\nOver 5 times", "Sprint\nOver 7 times"],
    ["Max Speed\nOver 10 km/h", "Max Speed\nOver 15 km/h", "Max Speed\nOver 20 km/h", "Max Speed\nOver 25 km/h"]
]
