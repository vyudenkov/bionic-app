//
//  FMKButtons.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol FMKRadioButtonDelegate {
    func click(_ button: FMKRadioButton)
}

class FMKRadioButton: UIButton {
    
    var delegate: FMKRadioButtonDelegate?
    
    var normalImage : UIImage!
    var selectedImage : UIImage!
    
    var alternateButton:Array<FMKRadioButton>?
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:FMKRadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
        delegate?.click(self)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(selectedImage, for: UIControlState.normal)
            } else {
                self.setImage(normalImage, for: UIControlState.normal)
            }
        }
    }
}

