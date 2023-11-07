import SwiftUI

struct SplashView: View {
    @StateObject var matchManager = MatchManager()
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                FirstView(matchManager: matchManager)
            } else {
                Rectangle()
                    .background(Color.black)
                Image("splashIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
        
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
