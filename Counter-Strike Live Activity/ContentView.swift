//
//  ContentView.swift
//  Counter-Strike Live Activity
//
//  Created by Caden Kriese on 5/10/25.
//

import ActivityKit
import OSLog
import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: requestLiveActivity) {
            Text("Request Live Activity")
        }
    }
}

func requestLiveActivity() {
    // TODO: get data from an API.

    let spirit = Team(
        name: "SPI",
        colorHex: 0x000000,
        vrsRanking: 4,
        favorite: true,
    )
    let falcons = Team(
        name: "FLC",
        colorHex: 0x007F49,
        vrsRanking: 3,
        favorite: false,
    )

    let spiritState = TeamState(side: Side.terrorist, roundsWon: 6, mapsWon: 1)
    let falconsState = TeamState(side: Side.counterTerrorist, roundsWon: 5, mapsWon: 1)

    let playByPlay = "sh1ro 1v2 post-plant."

    let match = MatchAttributes(
        matchTitle: "Group B Upper Bracket Final",
        tournament: "BLAST Rivals",
        matchFormat: MatchFormat.bestOfThree,
        teamA: spirit,
        teamB: falcons,
    )
    let initialState = MatchAttributes.ContentState(
        teamAState: spiritState,
        teamBState: falconsState,
        playByPlay: playByPlay,
        map: "Dust II",
        roundTimeRemaining: 32,
        paused: false,
        pauseReason: nil,
        finished: false,
    )
    // TODO: maybe stale date should be set to the end of round time?
    let content = ActivityContent(state: initialState, staleDate: nil, relevanceScore: 0.0)

    do {
        let activity = try Activity.request(
            attributes: match,
            content: content,
            pushType: nil,
        )

//        Task {
//            for await pushToken in activity.pushTokenUpdates {
//                let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
//
//                Logger().log("New push token: \(pushTokenString)")
//
//                try await sendPushToken(match: match, pushToken: pushTokenString)
//            }
//        }
    } catch {
        print("Error requesting live activity. \(error)")
    }
}

func sendPushToken(match _: MatchAttributes, pushToken _: String) async throws {}

#Preview {
    ContentView()
}
