//
//  YourTurnView.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import SwiftUI

struct YouWinView: View {
    @State var fontSize: CGFloat = 10
    @State var didTap: Bool = false
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            Text("You win!")
                .font(.custom("LuckiestGuy-Regular", size: fontSize))
                .foregroundColor(Color(.colorClickable))
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(Animation.bouncy(duration: 1).repeatForever(autoreverses: true)) {
                fontSize += 80
            }
        }
    }
}

#Preview {
    YouWinView()
}

