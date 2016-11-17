//
//  SelectProductViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

class SelectProductViewController: BaseQuestionViewController, UITableViewDelegate, UITableViewDataSource {

    private var reusableCells: [SelectProductTableViewCell] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onClick() {
        let result: FMKGame = FMKGame(userIdentifier: self.schema.userIdentifier, gameIdentifier: UUID(), title: nil, code: self.schema.code)
        
        for cell in reusableCells {
            if let s = cell.result() {
                result.categories.append(s)
            }
        }
        self.delegate?.doNextStep(result)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = self.schema.titles[0].text
        lblTitle.sizeToFit()
        
        btnNext.layer.cornerRadius = 8
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(self.schema.buttons[0].text, for: UIControlState.normal)

        tableView.delegate = self
        tableView.dataSource = self
        for i in 0..<schema.fmks.count {
            if let cell = tableView?.dequeueReusableCell(withIdentifier: "Select Product Cell", for: IndexPath(row: i, section: 0)) as? SelectProductTableViewCell {
                
                cell.gameImage = self.schema.fmks[i]
                reusableCells.append(cell)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schema.fmks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return reusableCells[indexPath.row]
    }

}
