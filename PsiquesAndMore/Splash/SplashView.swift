import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var fundo = Color(red: 33/255, green: 60/255, blue: 85/255)
    
    var body: some View {
        ZStack {
            fundo
            
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
