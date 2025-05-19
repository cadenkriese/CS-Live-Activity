//
//  MatchAttributes.swift
//  Counter-Strike Live Activity
//
//  Created by Caden Kriese on 5/13/25.
//

import ActivityKit
import Foundation
import SwiftUICore

struct MatchAttributes: ActivityAttributes {
    let matchTitle: String
    let tournament: String
    let matchFormat: MatchFormat
    let teamA: Team
    let teamB: Team

    struct ContentState: Codable & Hashable {
        let teamAState: TeamState
        let teamBState: TeamState
        let playByPlay: String
        let map: String
        let roundTimeRemaining: TimeInterval
        let paused: Bool
        let pauseReason: PauseReason?
        let finished: Bool
    }
}

enum MatchFormat: Int, Codable & Hashable {
    case bestOfOne = 1 // Map wins required to win the series.
    case bestOfThree = 2
    case bestOfFive = 3
}

struct Team: Codable & Hashable {
    let name: String
    let colorHex: UInt
    let vrsRanking: Int
    let favorite: Bool
}

extension Team {
    var color: Color {
        Color(
            red: Double((colorHex >> 16) & 0xFF) / 255,
            green: Double((colorHex >> 8) & 0xFF) / 255,
            blue: Double(colorHex & 0xFF) / 255,
            opacity: 1,
        )
    }
}

struct TeamState: Codable & Hashable {
    let side: Side?
    let roundsWon: Int
    let mapsWon: Int
}

enum Side: Codable & Hashable {
    case terrorist, counterTerrorist
}

enum PauseReason: Codable & Hashable {
    case tactical, technical, halftime, waitingForNextMap
}
