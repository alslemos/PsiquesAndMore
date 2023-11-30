import SwiftUI
import GameKit

struct InitialScreenView: View {
    @ObservedObject var matchManager = MatchManager()
    
    @State var showInstructions: Bool
    
    @State var errorAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            if matchManager.isGamePresented {
                PickLevelView(matchManager: _matchManager)
            } else {
                ZStack(alignment: .center) {
                    Color(.blueBlackground)
                    
                    VStack {
                        Image(.chaosLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250)
                            .padding(.bottom, 40)
                        
                        VStack(spacing: 10) {
                            Button {
                                matchManager.startMatchmaking()
                            } label: {
                                Text("Create session")
                                    .font(.custom("LuckiestGuy-Regular", size: 24))
                                    .foregroundColor(Color(.colorClickable))
                            }
                            .onAppear {
                                matchManager.authenticatePlayer()
                            }
                            .onChange(of: matchManager.authenticationState) { value in
                                if value == .error {
                                    errorAlert.toggle()
                                }
                            }
                            .alert(AuthenticationState.restricted.rawValue, isPresented: $matchManager.restrictedAlert) {
                                Button {
                                    matchManager.restrictedAlert.toggle()
                                } label: {
                                    Text("OK")
                                }
                            } message: {
                                Text("\nGo to Settings > Screen Time > Content & Privacy Restrictions, then turn on Content & Privacy Restrictions.\n\nTap Content Restrictions, scroll down to Game Center, then set restrictions.")
                            }
                            .alert(AuthenticationState.error.rawValue, isPresented: $errorAlert) {
                                Button {
                                    matchManager.authenticatePlayer()
                                } label: {
                                    Text("Try again")
                                }
                            }
                            .onDisappear {
                                GKAccessPoint.shared.isActive = false
                            }
                            .padding(.bottom)
                            
                            Button {
                                showInstructions = true
                            } label: {
                                Text("Instructions")
                                    .font(.custom("LuckiestGuy-Regular", size: 24))
                                    .foregroundColor(Color(.colorClickable))
                            }
                            .padding(.bottom)
                            
                            NavigationLink {
                                CreditsView().ignoresSafeArea().navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: CustomBackButton())
                                
                            } label: {
                                Text("Credits")
                                    .font(.custom("LuckiestGuy-Regular", size: 24))
                                    .foregroundColor(Color(.colorClickable))
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
}
