import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack {
                if self.isActive {
                    if isOnboardingSeen() {
                        InitialScreenView()
                    } else {
                        InstructionsView1()
                    }
                } else {
                    Image("splashIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
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

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
