//
//  GameTableViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit
import AVFoundation

protocol RespondGameViewControllerDelegate: class {
    func respondGame(_ gameResponse: FMKGame)
}

class GameTableViewCell : UITableViewCell {
        var speechSyntesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var fmkImage: UIImageView!
    
    @IBOutlet weak var btnFuck: FMKRadioButton!
    @IBOutlet weak var btnMarry: FMKRadioButton!
    @IBOutlet weak var btnKill: FMKRadioButton!
    
    @IBOutlet weak var fmkImageStiker: UIImageView!
    
    var data: FMKGameItem? = nil {
        didSet {
            fmkImage.showImage(imageUrl: data!.imageUrl!)
        }
    }
    
    func result() -> FMK? {
        return btnMarry.isSelected ? FMK.Marry : btnKill.isSelected ? FMK.Kill : btnFuck.isSelected ? FMK.Fuck : nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        fmkImage.autoresizingMask = [.flexibleTopMargin ]
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
        
        let speechUtterance = AVSpeechUtterance(string: "fuck")
        speechUtterance.rate = 0.25
        speechUtterance.pitchMultiplier = 0.25
        speechUtterance.volume = 0.75
        speechSyntesizer.speak(speechUtterance)
        
        fmkImageStiker.image = stickerHighlighted
        fmkImageStiker.animationImages = [sticker, stickerHighlighted, sticker, stickerHighlighted, sticker]
        fmkImageStiker.animationRepeatCount = 1
        fmkImageStiker.animationDuration = 0.2
        fmkImageStiker.startAnimating()
    }
}

// View is show on the respondents side
class RespondGameViewController: BaseGameViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {

    private var reusableCells: [GameTableViewCell] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var respondDelegate: RespondGameViewControllerDelegate?

    func onClick(code: String?) {
        let result: FMKGame = FMKGame(type: Categories.GameResponse, code: self.schema.code, userIdentifier: self.schema.userIdentifier, gameIdentifier: self.schema.gameIdentifier!)
        
        for cell in reusableCells {
            if let s = cell.result() {
                result.categories.append(FMKGameItem((cell.data?.code)!, imageUrl: (cell.data?.imageUrl)!, data: s.rawValue))
            }
        }
        self.respondDelegate?.respondGame(result)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0..<self.schema.games.count {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: IndexPath(row: i, section: 0)) as?GameTableViewCell {
                
                cell.data = self.schema.games[i]
                reusableCells.append(cell)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schema.games.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.schema.games.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            return cell
        }
        return reusableCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
