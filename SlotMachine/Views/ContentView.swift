//
//  ContentView.swift
//  SlotMachine
//
//  Created by Villva Tharisan Ramasamy on 27/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    let symbols = [
        "gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"
    ]
    
    @State private var highscore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10

    @State private var reels: Array = [0, 1, 2]
    
    @State private var showingInfoView: Bool = false
    
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels [2] && reels[0] == reels [2] {
            playerWins()
            
            if coins > highscore {
                newHighScore()
            }
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highscore = coins
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient:
                    Gradient(
                        colors: [Color("ColorPink"), Color("ColorPurple")]
                    ),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 5) {
                LogoView()
                
                Spacer()
                
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                VStack(alignment: .center, spacing: 0) {
                    ZStack {
                        ReelView()
                        
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        ZStack {
                            ReelView()
                            
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ReelView()
                            
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    Button(action: {
                        self.spinReels()
                        self.checkWinning()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                }
                .layoutPriority(2)
                
                Spacer()
                
                
                HStack(alignment: .center, spacing: 10) {
                    HStack {
                        Button(action: {
                            
                            
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    HStack {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(1)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            
                            
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(.yellow)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            .overlay(
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()), alignment: .topLeading
            )
            .overlay(
                Button(action: {
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()), alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
