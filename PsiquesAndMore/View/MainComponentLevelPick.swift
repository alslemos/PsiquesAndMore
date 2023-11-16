//
//  MainComponentLevelPick.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 14/11/23.
//

import Foundation
import SwiftUI

struct MainComponentLevelPick: View {
    
    private let figmaWidth: CGFloat = 203
    private let figmaHeight: CGFloat = 98
    
    var realHeight: CGFloat
    var realWidth: CGFloat
    
    @Binding var card: GameCardModel
    
    var body: some View {
        HStack(spacing: getProportionalValueWidth(6)) {
            if let imageName = card.demoImage {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: getProportionalValueWidth(69), height: getProportionalValueHeight(98))
//                    .cornerRadius(getProportionalValueWidth(10), corners: [.bottomLeft, .topLeft])
            }
            else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: getProportionalValueWidth(69), height: getProportionalValueHeight(98))
//                    .cornerRadius(getProportionalValueWidth(10), corners: [.bottomLeft, .topLeft])
            }
            
            
            VStack(alignment: .leading, spacing: getProportionalValueHeight(8)){
                Text(card.title) // titulo do jogo
                    .bold()
                    .font(Font.custom("Luckiest Guy", size: 20))
                    .foregroundColor(Color(red: 0.99, green: 0.66, blue: 0.4))
                    .lineLimit(1)
//                    .frame(width: getProportionalValueWidth(123), alignment: .leading)
                    
                VStack(alignment: .leading, spacing: 0) {
                    Text(card.amountOfPlayers.rawValue)
                        .font(.body)
                        .frame(width: getProportionalValueWidth(123), alignment: .leading)
                        .lineLimit(1)
                    HStack {
                        Text(String("uashuahs"))
                            .font(.body)
                            .frame(width: getProportionalValueWidth(90), alignment: .leading)
                            .lineLimit(1)
                    }
                }
            }
            
            
        }
        .background(
            Color.white
        )
        .cornerRadius(getProportionalValueWidth(10))
    }
    
    func getProportionalValueWidth(_ value: CGFloat) -> CGFloat {
        value * realWidth / figmaWidth
    }
    
    func getProportionalValueHeight(_ value: CGFloat) -> CGFloat {
        value * realHeight / figmaHeight
    }
}

//struct CardViewV2_Previews: PreviewProvider {
//    static var previews: some View {
//        CardViewV2(realHeight: 98, realWidth: 203, card: .constant(GameCardModel.sampleData.first!))
//    }
//}
