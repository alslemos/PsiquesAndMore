//
//  GSSetupTimer.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 08/11/23.
//

import Foundation

extension GameScene {
    
    func setupTimer() {
        timerLabel.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.maxY - 64)
        
        timerLabel.fontColor = .white
        timerLabel.numberOfLines = 1
        timerLabel.fontSize = 20
        timerLabel.zPosition = 1
        addChild(timerLabel)
        
//        setupGameTimer()
    }
    
    
    
//    func setupGameTimer(){
//        let timer = Timer.publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//        
//        let subscription = timer
//            .scan(0, { count, _ in
//                return count + 1
//            })
//            .sink { completion in
//                print("data stream completion \(completion)")
//            } receiveValue: { timeStamp in
//                self.timerLabel.text = "\(timeStamp)"
//            }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            
//            subscription.cancel()
//        }
//    }
    
    func timerSubscription() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                if !self.isPaused {
                    return count + 1
                } else {
                    return count
                }
            }
            .sink { count in
                self.timerLabel.text = "\(count)"
                print("counter: \(count)")
                
                if !self.isPaused {
                    if count >= self.gameDuration {
                        print("time's up")
                        self.sendGameOverData {
                            self.notifyGameOver()
                        }
                    }
                }
            }.store(in: &cancellables)
    }
}