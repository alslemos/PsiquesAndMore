//
//  GameViewController.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import UIKit
import GameController

class GameViewController: UIViewController {
    // Virtual Onscreen Controller
    private var _virtualController: Any?
    @available(iOS 15.0, *)
    public var virtualController: GCVirtualController? {
        get { return self._virtualController as? GCVirtualController }
        set { self._virtualController = newValue }
    }
}
