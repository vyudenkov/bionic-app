//
//  BaseGameViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/24/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol SaveGameDelegate: class {
    func saveGame(_ game: FMKGame)
}

class BaseGameViewController: BaseViewController {

    var schema: Schema!
    
    var delegate: SaveGameDelegate!
    
    func next() {
        if (validate()) {
            doAction(context: context())
        }
        else
        {
            // show warning to select anything
            self.showWarning()
        }
    }
    
    func doAction(context: FMKGame) {
        self.delegate.saveGame(context)
    }
    
    func validate () -> Bool {
        preconditionFailure("The method must be overriden")
    }
    
    func context () -> FMKGame {
        preconditionFailure("The method must be overriden")
    }
}
