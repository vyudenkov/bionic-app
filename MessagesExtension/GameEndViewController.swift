//
//  GameEndViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/27/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class GameEndViewController: BaseGameViewController {

    @IBOutlet weak var lblImageText: UILabel!
    @IBOutlet weak var centerImage: UIImageView!
    @IBAction func onClick() {
        self.delegate.saveGame(FMKGame(type: self.schema.type, code: self.schema.code, userIdentifier: self.schema.userIdentifier, gameIdentifier: self.schema.gameIdentifier!))
    }
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(self.schema.buttons[0].text, for: UIControlState.normal)
        
        // prepare header text
        lblTitle.text = self.schema.titles[0].text
        
        if self.schema.titles.count > 1 {
            let question = self.schema.titles[1]
            lblImageText.text = question.text
            lblImageText.sizeToFit()
            centerImage.showImage(imageUrl: question.imageUrl!)
        }

    }
}
