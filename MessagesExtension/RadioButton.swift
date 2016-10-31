//
//  RadioButton.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/10/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class RadioButton: UIButton {

    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                if self != aButton {
                    aButton.isSelected = false
                }
            }
        }else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                
                self.layer.borderWidth = 5.0
            } else {
                self.layer.borderWidth = 0.0
            }
        }
    }
    
}

class RoundRadioButton: RadioButton {
    
    override func awakeFromNib() {
        
        let sizeSide = min(self.frame.width, self.frame.height)
        
        self.frame = CGRect.init(x: 0, y: 0, width: sizeSide, height: sizeSide)
        self.layer.cornerRadius = sizeSide/2.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
}
