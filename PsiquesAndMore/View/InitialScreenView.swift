import SwiftUI
import GameKit

struct InitialScreenView: View {
    @ObservedObject var matchManager = MatchManager()
    
    @State private var isGameStart: Bool = false
    @State private var isPhonemeDex: Bool = false
    @State private var isAbout: Bool = false
    
    @State var showInstructions: Bool
    
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
                                .frame(width: 250)
                                .padding(.bottom, 40)
                            
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
                                }
                                .onDisappear {
                                    GKAccessPoint.shared.isActive = false
                                }
                                .padding(.bottom)
                                
                                // ainda tem esse bag
                                Button {
                                    showInstructions = true
                                } label: {
                                    Text("Instructions")
                                        .font(.custom("LuckiestGuy-Regular", size: 24))
                                        .foregroundColor(Color(.clique))
                                }
                                .padding(.bottom)
                                
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
                        
                        if showInstructions {
                            InstructionsTabView(showInstructions: $showInstructions)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .statusBarHidden(true)
        .ignoresSafeArea()
    }
}
