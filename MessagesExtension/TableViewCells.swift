//
//  TableViewCells.swift
//  bionic-app
//
//  Created by Vitaliy on 11/22/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////////////////////////////////
// Cell with green button
//////////////////////////////////////////////////////////////////////////////
protocol ButtonClickDelegate {
    func onClick(code: String?)
}

class ButtonTableViewCell : UITableViewCell {
    
    var delegate : ButtonClickDelegate?
    var code: String?
    var buttonTitle: String? = nil {
        didSet {
            startButton.setTitle(buttonTitle, for: UIControlState.normal)
        }
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func onClick() {
        delegate?.onClick(code: code)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startButton.layer.cornerRadius = 8
        
        startButton.layer.borderColor = UIColor.red.cgColor
        startButton.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}

//////////////////////////////////////////////////////////////////////////////
// Cell with title text
//////////////////////////////////////////////////////////////////////////////
class TextTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    var labelText: String? = nil {
        didSet {
            self.lblTitle.text = labelText
            self.lblTitle.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
}

//////////////////////////////////////////////////////////////////////////////
// Cell with image
//////////////////////////////////////////////////////////////////////////////
class ImageTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imageResult: UIImageView!
    
    var imageUrl: String? = nil {
        didSet {
            self.imageResult.showImage(imageUrl: imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageResult.contentMode = .scaleAspectFit
        imageResult.layer.cornerRadius = 8
        imageResult.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}

//////////////////////////////////////////////////////////////////////////////
// Cell with image button
//////////////////////////////////////////////////////////////////////////////
class ImageButtonTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imageButton: RadioButton!
    
    var code : String?
    
    var imageUrl: String? = nil {
        didSet {
            self.imageButton.showImage(imageUrl: imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageButton.contentMode = .scaleAspectFit
        imageButton.layer.cornerRadius = 8
        imageButton.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}

//////////////////////////////////////////////////////////////////////////////
// Cell with image
//////////////////////////////////////////////////////////////////////////////
class RadioButtonViewCell : UITableViewCell {
    
    @IBOutlet weak var imageButton: CheckRadioButton!
    @IBOutlet weak var imageText: UIButton!
    @IBAction func textClick() {
        imageButton.toggleButton()
        imageButton.unselectAlternateButtons()
    }
    
    var question: Element? = nil {
        didSet {
            self.imageText.setTitle(question!.text, for: UIControlState.normal)
            self.imageText.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
}


//////////////////////////////////////////////////////////////////////////////
// Cell with FMK
//////////////////////////////////////////////////////////////////////////////
class SelectProductTableViewCell : UITableViewCell {
    
    @IBOutlet weak var fmkImage: UIImageView!
    
    @IBOutlet weak var btnFuck: FMKRadioButton!
    
    @IBOutlet weak var btnMarry: FMKRadioButton!
    
    @IBOutlet weak var btnKill: FMKRadioButton!
    
    var gameImage: Element? = nil {
        didSet {
            fmkImage?.showImage(imageUrl: (gameImage?.imageUrl)!)
        }
    }
    
    func result() -> FMKGameItem? {
        let result : String? = btnMarry.isSelected ? FMKGameItem.Marry : btnKill.isSelected ? FMKGameItem.Kill : btnFuck.isSelected ? FMKGameItem.Fuck : nil
        if let res = result {
            return FMKGameItem((gameImage?.code)!, imageUrl: (gameImage?.imageUrl)!, data: res)
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnFuck.alternateButton = [btnMarry, btnKill]
        btnFuck.normalImage = #imageLiteral(resourceName: "FuckSmile")
        btnFuck.selectedImage = #imageLiteral(resourceName: "FuckSmileSelected")
        
        btnKill.alternateButton = [btnMarry, btnFuck]
        btnKill.normalImage = #imageLiteral(resourceName: "KillSmile")
        btnKill.selectedImage = #imageLiteral(resourceName: "KillSmileSelected")
        
        btnMarry.alternateButton = [btnFuck, btnKill]
        btnMarry.normalImage = #imageLiteral(resourceName: "MarrySmile")
        btnMarry.selectedImage = #imageLiteral(resourceName: "MarrySmileSelected")
        
        fmkImage.autoresizingMask = [.flexibleTopMargin ]
        fmkImage.contentMode = .scaleAspectFit
        fmkImage.clipsToBounds = true
        self.backgroundColor = UIColor.clear
    }
}


//////////////////////////////////////////////////////////////////////////////
// Cell with social validation and FMK
//////////////////////////////////////////////////////////////////////////////
class ProductResultTableViewCell : UITableViewCell {
    
    @IBOutlet weak var fmkImage: UIImageView!
    
    @IBOutlet weak var lblMarryCount: UILabel!
    @IBOutlet weak var lblFuckCount: UILabel!
    @IBOutlet weak var lblKillCount: UILabel!
    
    @IBOutlet weak var btnFuck: FMKRadioButton!
    @IBOutlet weak var btnMarry: FMKRadioButton!
    @IBOutlet weak var btnKill: FMKRadioButton!
    
    var responseCount : Int = 0
    
    var gameItem: FMKGameItem? = nil {
        didSet {
            if let item = gameItem {
                lblMarryCount.text = "Marry: \(item.marryCount())/\(responseCount)"
                lblMarryCount.sizeToFit()
                lblFuckCount.text = "Fuck: \(item.fuckCount())/\(responseCount)"
                lblFuckCount.sizeToFit()
                lblKillCount.text = "Kill: \(item.killCount())/\(responseCount)"
                lblKillCount.sizeToFit()
            }
            fmkImage?.showImage(imageUrl: (gameItem?.imageUrl)!)
        }
    }
    
    func result() -> FMKGameItem? {
        let result : String? = btnMarry.isSelected ? FMKGameItem.Marry : btnKill.isSelected ? FMKGameItem.Kill : btnFuck.isSelected ? FMKGameItem.Fuck : nil
        if let res = result {
            return FMKGameItem((gameItem?.code)!, imageUrl: (gameItem?.imageUrl)!, data: res)
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnFuck.alternateButton = [btnMarry, btnKill]
        btnFuck.normalImage = #imageLiteral(resourceName: "FuckSmile")
        btnFuck.selectedImage = #imageLiteral(resourceName: "FuckSmileSelected")
        
        btnKill.alternateButton = [btnMarry, btnFuck]
        btnKill.normalImage = #imageLiteral(resourceName: "KillSmile")
        btnKill.selectedImage = #imageLiteral(resourceName: "KillSmileSelected")
        
        btnMarry.alternateButton = [btnFuck, btnKill]
        btnMarry.normalImage = #imageLiteral(resourceName: "MarrySmile")
        btnMarry.selectedImage = #imageLiteral(resourceName: "MarrySmileSelected")
        
        fmkImage.autoresizingMask = [.flexibleTopMargin ]
        fmkImage.contentMode = .scaleAspectFit
        fmkImage.clipsToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}


