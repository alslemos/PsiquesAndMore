import SwiftUI
import GameKit

struct InitialScreenView: View {
    @ObservedObject var matchManager = MatchManager()
    
    @State private var isGameStart: Bool = false
    @State private var isPhonemeDex: Bool = false
    @State private var isAbout: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                if matchManager.isGamePresented {
                    PickLevelView(matchManager: _matchManager)
                } else {
                    ZStack(alignment: .center) {
                        Color(.fundo)
                        
                        VStack {
                           Image("splashIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 50)
                                .padding(.bottom, 80)
                            
                            VStack(spacing: 10) {
                                // botao para jogar
                                Button {
                                    matchManager.startMatchmaking()
                                } label: {
                                    Text("Create session")
                                        .font(.custom("LuckiestGuy-Regular", size: 24))
                                        .foregroundColor(Color(.clique))
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
                                    Text("Instructions")
                                        .font(.custom("LuckiestGuy-Regular", size: 24))
                                        .foregroundColor(Color(.clique))
                                }
                                
                                // botao para Fonedex
                                NavigationLink {
                                    CreditsView().ignoresSafeArea().navigationBarBackButtonHidden(true)
                                        .navigationBarItems(leading: CustomBackButton())
                                    
                                } label: {
                                    Text("Credits")
                                        .font(.custom("LuckiestGuy-Regular", size: 24))
                                        .foregroundColor(Color(.clique))
                                }
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
