import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color(.blueBlackground)
            
            if self.isActive {
                InitialScreenView(showInstructions: !isOnboardingSeen())
            } else {
                Image(.chaosLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .ignoresSafeArea()
    }
}

func isOnboardingSeen() -> Bool {
    return UserDefaults.standard.bool(forKey: "completedOnboarding")
}

#Preview {
    SplashView(isActive: false)
}
