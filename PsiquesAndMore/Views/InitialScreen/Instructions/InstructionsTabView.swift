//
//  InstructionsTabView.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 24/11/23.
//

import SwiftUI

struct InstructionsTabView: View {
    @State var selectedTab: Int = 0
    
    @Binding var showInstructions: Bool
    
    var body: some View {
        ZStack {
            Color(.blueBlackground)
            
            VStack {
                HStack {
                    if selectedTab != 0 {
                        Button {
                            selectedTab -= 1
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(.colorClickable))
                        }
                        .padding(.leading)
                    } else {
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .opacity(0)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    Button {
                        showInstructions = false
                        
                        if !isOnboardingSeen() {
                            UserDefaults.standard.set(true, forKey: "completedOnboarding")
                        }
                    } label: {
                        Text("SKIP")
                            .font(.custom("LuckiestGuy-Regular", size: 24))
                            .foregroundColor(Color(.colorClickable))
                    }
                    .padding(.trailing)
                }
                .padding()
                
                ZStack {
                    TabView(selection: $selectedTab) {
                        InstructionsView1().tag(0)
                        InstructionsView2().tag(1)
                        InstructionsView3().tag(2)
                    }
                    .tabViewStyle(.page)
                    
                    Button {
                        if selectedTab == 2 {
                            showInstructions = false
                            
                            if !isOnboardingSeen() {
                                UserDefaults.standard.set(true, forKey: "completedOnboarding")
                            }
                        } else {
                            selectedTab += 1
                        }
                    } label: {
                        Text(selectedTab == 2 ? "ENJOY" : "NEXT")
                    }
                    .font(.custom("LuckiestGuy-Regular", size: 32))
                    .foregroundColor(Color(.colorClickable))
                    .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180))
                }
                .padding(.bottom, 60)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InstructionsTabView(showInstructions: .constant(true))
}
