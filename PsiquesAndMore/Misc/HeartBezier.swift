//
//  HeartBezier.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import UIKit

func createHeartBezierPath1() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: -0.7, y:0))
    path.addLine(to: CGPoint(x: -0.3, y:0.09))
    path.addLine(to: CGPoint(x: -0.3, y:0.04))
    // meio
    path.addLine(to: CGPoint(x: 0.3, y:0.04))
    path.addLine(to: CGPoint(x: 0.3, y:0.09))
    path.addLine(to: CGPoint(x: 0.7, y:0))
    // agora voltando
    path.addLine(to: CGPoint(x: 0.3, y: -0.09))
    path.addLine(to: CGPoint(x: 0.3, y: -0.04))
    
    path.addLine(to: CGPoint(x: -0.3, y: -0.04))
    path.addLine(to: CGPoint(x: -0.3, y: -0.09))
    
    path.addLine(to: CGPoint(x: -0.7, y: 0))
    
    path.close()
    
    return path
}

func createHeartBezierPath2() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y:0.02))
    path.addLine(to: CGPoint(x: 0.01, y:0.01))
    path.addLine(to: CGPoint(x: 0.005, y:0.01))
    /// MEIO
    path.addLine(to: CGPoint(x: 0.005, y: -0.01))
    //
    path.addLine(to: CGPoint(x: 0.01, y: -0.01))
    path.addLine(to: CGPoint(x: 0, y: -0.02))
    // voltando
    path.addLine(to: CGPoint(x: -0.01, y: -0.01))
    path.addLine(to: CGPoint(x: -0.005, y: -0.01))
    
    path.addLine(to: CGPoint(x: -0.005, y: 0.01))
    path.addLine(to: CGPoint(x: -0.01, y: 0.01))
    path.addLine(to: CGPoint(x: 0, y: 0.02))
    
    path.close()
    return path
}
