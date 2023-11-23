import SwiftUI
import GameKit

struct InitialScreenView: View {
    @ObservedObject var matchManager = MatchManager()
    
    @State private var isGameStart: Bool = false
    @State private var isPhonemeDex: Bool = false
    @State private var isAbout: Bool = false
    
    
    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                if matchManager.isGamePresented {
                    PickLevelView(matchManager: _matchManager)
                } else {
                    ZStack(alignment: .center) {
                        fundo
                        
                        VStack(spacing: 10) {
                           
                            VStack {
                               Text("CHAOS ")
                            }

                            .font(.custom("LuckiestGuy-Regular", size: 32)) //LuckiestGuy-Regular
                            .foregroundColor(clique)
                            .padding(.bottom, 80)
                            
                            
                            // botao para jogar
                            Button {
                                matchManager.startMatchmaking()
                            } label: {
                                Text("Create session")
                                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                                    .foregroundColor(clique)
                            }
                            .onAppear {
                                if matchManager.authenticationState != .authenticated {
                                    matchManager.authenticatePlayer()
                                }
                                
                                UserDefaults.standard.set(true, forKey: "completedOnboarding")
                            }
                            .onDisappear {
                                GKAccessPoint.shared.isActive = false
                            }
                            
                            // ainda tem esse bag
                            NavigationLink {
                               InstructionsView1().ignoresSafeArea().navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: CustomBackButton())
                            } label: {
                                // ZStack {
                                    Text("Instructions")
                                        .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                                        .foregroundColor(clique)
                                // }
                            }
                         
                           
                            
                            // botao para Fonedex
                            NavigationLink {
                                CreditsView().ignoresSafeArea().navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: CustomBackButton())
                                
                            } label: {
                                // ZStack {
                                    Text("Credits")
                                        .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                                        .foregroundColor(clique)
                                // }
                            }
                          
                         
                        }
                        .padding()
                        .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .statusBarHidden(true)
        .ignoresSafeArea()
    }
}
