//
//  MatchLiveActivity.swift
//  Match
//
//  Created by Caden Kriese on 5/13/25.
//

import ActivityKit
import Foundation
import SwiftUI
import WidgetKit

struct MatchLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchAttributes.self) { context in
            MatchLiveActivityView(
                matchTitle: context.attributes.matchTitle,
                tournament: context.attributes.tournament,
                matchFormat: context.attributes.matchFormat,
                teamA: context.attributes.teamA,
                teamB: context.attributes.teamB,
                contentState: context.state,
            )
        } dynamicIsland: { context in
            DynamicIsland {
                // TODO Implement expanded view.
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Image("\(context.attributes.teamA.name) Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                    Text("\(context.state.teamAState.roundsWon)")
                        .fontWeight(.bold)
                }
            } compactTrailing: {
                HStack(spacing: 4) {
                    Text("\(context.state.teamBState.roundsWon)")
                        .fontWeight(.bold)
                    Image("\(context.attributes.teamB.name) Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                    // TODO logos that are more tall than wide are not concentric with the Dynamic Island.
                }
            } minimal: {
                ZStack {
                    ZStack {
                        Circle()
                            .fill(context.attributes.teamA.color.mix(with: .gray, by: 0.5))
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(context.attributes.teamA.color.mix(with: .black, by: 0.2))
                            .frame(width: 18, height: 18)
                        Image("\(context.attributes.teamA.name) Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }.padding(.trailing, 9)
                    ZStack {
                        Circle()
                            .fill(context.attributes.teamB.color.mix(with: .gray, by: 0.5))
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(context.attributes.teamB.color.mix(with: .black, by: 0.2))
                            .frame(width: 18, height: 18)
                        Image("\(context.attributes.teamB.name) Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }.padding(.leading, 9)
                }
            }
//            .widgetURL(URL(string: "http://www.apple.com")) TODO link to match page in app.
            .keylineTint(context.attributes.teamA.color)
        }
    }
}

// Previews

private extension MatchAttributes {
    static var preview: MatchAttributes {
        MatchAttributes(
            matchTitle: "Group B Upper Bracket Final",
            tournament: "BLAST Rivals",
            matchFormat: MatchFormat.bestOfThree,
            teamA: Team(name: "SPI",
                        colorHex: 0x000000,
                        vrsRanking: 4,
                        favorite: true),
            teamB: Team(name: "FLC",
                        colorHex: 0x007F49,
                        vrsRanking: 3,
                        favorite: false),
        )
    }
}

private extension MatchAttributes.ContentState {
    static var round12: MatchAttributes.ContentState {
        MatchAttributes.ContentState(
            teamAState: TeamState(side: Side.terrorist, roundsWon: 6, mapsWon: 1),
            teamBState: TeamState(side: Side.counterTerrorist, roundsWon: 5, mapsWon: 1),
            playByPlay: "sh1ro 1v2 post-plant.",
            map: "Dust II",
            roundTimeRemaining: 32,
            paused: false,
            pauseReason: nil,
            finished: false,
        )
    }

    static var halftime: MatchAttributes.ContentState {
        MatchAttributes.ContentState(
            teamAState: TeamState(side: Side.terrorist, roundsWon: 7, mapsWon: 1),
            teamBState: TeamState(side: Side.counterTerrorist, roundsWon: 5, mapsWon: 1),
            playByPlay: "Spirit defend 4v5 B site post-plant.",
            map: "Dust II",
            roundTimeRemaining: 0,
            paused: true,
            pauseReason: PauseReason.halftime,
            finished: false,
        )
    }
}

#Preview("Lock Screen", as: .content, using: MatchAttributes.preview) {
    MatchLiveActivity()
} contentStates: {
    MatchAttributes.ContentState.round12
    MatchAttributes.ContentState.halftime
}

#Preview("Compact", as: .dynamicIsland(.compact), using: MatchAttributes.preview) {
    MatchLiveActivity()
} contentStates: {
    MatchAttributes.ContentState.round12
    MatchAttributes.ContentState.halftime
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: MatchAttributes.preview) {
    MatchLiveActivity()
} contentStates: {
    MatchAttributes.ContentState.round12
    MatchAttributes.ContentState.halftime
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: MatchAttributes.preview) {
    MatchLiveActivity()
} contentStates: {
    MatchAttributes.ContentState.round12
    MatchAttributes.ContentState.halftime
}
