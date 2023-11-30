//
//  YourTurnView.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import SwiftUI

struct YourTurnView: View {
    let myTurn: Bool
    
    @State var fontSize: CGFloat = 10
    @State var didTap: Bool = false
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            Text("It's \(myTurn ? "your" : "their") turn!")
                .font(.custom("LuckiestGuy-Regular", size: fontSize))
                .foregroundColor(Color(.colorClickable))
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(Animation.bouncy(duration: 1).repeatForever(autoreverses: true)) {
                fontSize += 80
            }
        }
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("YourTurn"), object: nil)
            didTap = true
        }
        .onReceive(timer) { _ in
            if !didTap {
                NotificationCenter.default.post(name: NSNotification.Name("YourTurn"), object: nil)
            }
        }
    }
}

#Preview {
    YourTurnView(myTurn: false)
}
