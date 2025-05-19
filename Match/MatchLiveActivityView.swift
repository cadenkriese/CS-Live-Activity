//
//  MatchLiveActivityView.swift
//  MatchExtension
//
//  Created by Caden Kriese on 5/13/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct MatchLiveActivityView: View {
    let matchTitle: String
    let tournament: String
    let matchFormat: MatchFormat
    let teamA: Team
    let teamB: Team

    let contentState: MatchAttributes.ContentState

    var body: some View {
        ZStack {
            // TODO: Write a function to manage this gradient in a way that preserves contrast.
            LinearGradient(
                gradient: Gradient(
                    colors: [teamA.color, teamB.color],
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing,
            )

            VStack {
                Text("\(tournament) • \(matchTitle)")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .font(.caption2)
                    .opacity(0.8)
                HStack(spacing: 4) {
                    TeamDisplayView(team: teamA)
                    MapsWonView(mapsWon: contentState.teamAState.mapsWon, matchFormat: matchFormat)
                    Text("\(contentState.teamAState.roundsWon)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        .contentTransition(.numericText())
                    TeamSideView(side: contentState.teamAState.side)

                    Spacer()
                    GameDetailView(contentState: contentState)
                    Spacer()

                    TeamSideView(side: contentState.teamBState.side)
                    Text("\(contentState.teamBState.roundsWon)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        .contentTransition(.numericText())
                    MapsWonView(mapsWon: contentState.teamBState.mapsWon, matchFormat: matchFormat)
                    TeamDisplayView(team: teamB)
                }
                if !contentState.finished {
                    HStack(alignment: .top, spacing: 5) {
                        VStack(alignment: .leading) {
                            Spacer()
                            Image("HLTV Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                        Spacer()
                        Text(contentState.playByPlay)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.trailing)
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 2, height: 30)
                            .foregroundStyle(teamB.color)
                            .shadow(color: Color(.sRGBLinear, white: 1, opacity: 0.8), radius: 1)
                    }
                }
            }.padding(.all, 14)
        }
    }
}

struct TeamDisplayView: View {
    let team: Team

    var body: some View {
        VStack {
            Image("\(team.name) Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            HStack(spacing: 3) {
                Text("\(team.vrsRanking)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.systemGray3))
                    .opacity(0.55)
                Text(team.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .opacity(0.9)
            }
        }
    }
}

struct MapsWonView: View {
    let mapsWon: Int
    let matchFormat: MatchFormat

    var body: some View {
        if matchFormat != MatchFormat.bestOfOne {
            VStack(spacing: 3) {
                ForEach(
                    1 ... matchFormat.rawValue, // Raw value of the enum corresponds to the number of map wins required to win a match.
                    id: \.self,
                ) { mapNumber in
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 4, height: 14)
                        .foregroundStyle(.white)
                        .opacity(mapsWon >= mapNumber ? 1 : 0.5)
                }
                Spacer()
            }
        }
    }
}

struct TeamSideView: View {
    let side: Side?

    var body: some View {
        if side != nil {
            if side == .counterTerrorist {
                Image("Defusal Kit")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .colorInvert()
                    .opacity(0.65)
                    .padding(.bottom, 23)
            } else if side == .terrorist {
                Image("C4")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .colorInvert()
                    .opacity(0.65)
                    .padding(.bottom, 23)
            }
        }
    }
}

struct GameDetailView: View {
    let contentState: MatchAttributes.ContentState

    var body: some View {
        VStack {
            Spacer()
            if contentState.finished {
                // TODO: final state should change score to display maps i.e. 2-1
                Text("Final")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            } else if contentState.paused {
                switch contentState.pauseReason! {
                case .tactical:
                    Text("Tactical Timeout") // TODO: say who is taking the timeout and add timer.
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                case .technical:
                    Text("Technical Timeout")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                case .halftime:
                    Text("Halftime")
                        .font(.title3)
                        .foregroundStyle(Color(.systemGray2))
                        .opacity(0.8)
                        .fontWeight(.bold)
                case .waitingForNextMap:
                    Text("Waiting for Next Map") // TODO: say which map and add timer if possible.
                        .font(.caption)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
            } else {
                Text(formattedTime(from: contentState.roundTimeRemaining))
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .contentTransition(.numericText(countsDown: true))
            }
            Spacer()
            Text(contentState.map)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .opacity(0.8)
        }
    }
}

func formattedTime(from timeInterval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .dropTrailing
    return formatter.string(from: timeInterval) ?? "0:00"
}

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
            teamAState: TeamState(
                side: Side.terrorist,
                roundsWon: 6,
                mapsWon: 1,
            ),
            teamBState: TeamState(
                side: Side.counterTerrorist,
                roundsWon: 5,
                mapsWon: 1,
            ),
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
            teamAState: TeamState(
                side: Side.counterTerrorist,
                roundsWon: 7,
                mapsWon: 1,
            ),
            teamBState: TeamState(
                side: Side.terrorist,
                roundsWon: 5,
                mapsWon: 1,
            ),
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
