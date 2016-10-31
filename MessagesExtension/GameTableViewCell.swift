//
//  GameTableViewCell.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit

class GameTableViewCell : UITableViewCell {
    
    @IBOutlet weak var fmkImage: UIImageView!

    @IBOutlet weak var btnFuck: FMKRadioButton!
   
    @IBOutlet weak var btnMarry: FMKRadioButton!
    
    @IBOutlet weak var btnKill: FMKRadioButton!
    
    @IBOutlet weak var fmkImageStiker: UIImageView!
    
    
    var gameImage: GameImage? = nil {
        didSet {
            gameImage?.showInView(imageView: fmkImage)
        }
    }
    
    func result() -> GameImageResponse {
        let result : FMK? = btnMarry.isSelected ? FMK.Marry : btnKill.isSelected ? FMK.Kill : btnFuck.isSelected ? FMK.Fuck : nil
        return GameImageResponse(image: gameImage!, response: result)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //let nib = Bundle.main.loadNibNamed("FMKButtons", owner: self, options: nil)
        //fmkResult = nib?[0] as! FMKButtons
        btnFuck.delegate = self
        btnFuck.alternateButton = [btnMarry, btnKill]
        btnFuck.normalImage = #imageLiteral(resourceName: "FuckSmile")
        btnFuck.selectedImage = #imageLiteral(resourceName: "FuckSmileSelected")
        
        btnKill.delegate = self
        btnKill.alternateButton = [btnMarry, btnFuck]
        btnKill.normalImage = #imageLiteral(resourceName: "KillSmile")
        btnKill.selectedImage = #imageLiteral(resourceName: "KillSmileSelected")
        
        btnMarry.delegate = self
        btnMarry.alternateButton = [btnFuck, btnKill]
        btnMarry.normalImage = #imageLiteral(resourceName: "MarrySmile")
        btnMarry.selectedImage = #imageLiteral(resourceName: "MarrySmileSelected")
        
        //fmkImage.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleHeight ]
        fmkImage.autoresizingMask = [.flexibleTopMargin ]
        //fmkImage.frame = CGRect(x: 0, y: 0, width: 330, height: 330)
        fmkImage.contentMode = .scaleAspectFit
        fmkImage.clipsToBounds = true
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

extension GameTableViewCell: FMKRadioButtonDelegate {

    func click(_ button: FMKRadioButton) {
        
        let sticker = button == btnFuck ? #imageLiteral(resourceName: "Fuck") : (button == btnMarry ? #imageLiteral(resourceName: "Marry") : #imageLiteral(resourceName: "Kill"))
        let stickerHighlighted = button == btnFuck ? #imageLiteral(resourceName: "FuckSelected") : (button == btnMarry ? #imageLiteral(resourceName: "MarrySelected") : #imageLiteral(resourceName: "KillSelected"))
        
        fmkImageStiker.image = stickerHighlighted
        fmkImageStiker.animationImages = [sticker, stickerHighlighted, sticker, stickerHighlighted, sticker]
        fmkImageStiker.animationRepeatCount = 1
        fmkImageStiker.animationDuration = 0.2
        fmkImageStiker.startAnimating()
    }
}
