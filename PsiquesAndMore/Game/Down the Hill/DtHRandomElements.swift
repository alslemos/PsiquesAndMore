//
//  DhtRandomElements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func createObstaclesArray() {
        for _ in 0..<100 {
            // Creatiing enemies array
            let yPositions: [YPosition] = YPosition.allCases
            let randomYPosition = yPositions.randomElement()
            
            guard let yPosition = randomYPosition else { return }
            
            let enemyTime = Double.random(in: 1.5...2.0)
            
            let randomEnemyMovement = EnemyMovement(yPosition: yPosition, time: enemyTime)
            
            enemiesMovements.append(randomEnemyMovement)
            
            // Creating obstacles array
            let obstacleCases: [Obstacle] = Obstacle.allCases
            let randomObstacle = obstacleCases.randomElement()
            
            guard let obstacle = randomObstacle else { return }
            
            obstaclesOrder.append(obstacle)
        }
    }
}
