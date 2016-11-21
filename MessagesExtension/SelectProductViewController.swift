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

class SelectProductViewController: BaseQuestionViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {

    private var reusableCells: [SelectProductTableViewCell] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func validate () -> Bool {
        return reusableCells.filter({ (cell: SelectProductTableViewCell) -> Bool in
            if cell.result() != nil {
                return true
            }
            return false
        }).count > 0
    }
    
    override func context () -> ExecutionContext {
        let result: FMKGame = FMKGame(userIdentifier: self.schema.userIdentifier, gameIdentifier: UUID(), title: nil, code: self.schema.code)
        
        for cell in reusableCells {
            if let s = cell.result() {
                result.categories.append(s)
            }
        }
        return result
    }
    
    func onClick(code: String?) {
        
        super.next()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = self.schema.titles[0].text
        lblTitle.sizeToFit()

        tableView.delegate = self
        tableView.dataSource = self
        for i in 0..<schema.fmks.count {
            if let cell = tableView?.dequeueReusableCell(withIdentifier: "Select Product Cell", for: IndexPath(row: i, section: 0)) as? SelectProductTableViewCell {
                
                cell.gameImage = self.schema.fmks[i]
                reusableCells.append(cell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schema.fmks.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == self.schema.fmks.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
            (cell as! ButtonTableViewCell).buttonTitle = self.schema.buttons[0].text
            (cell as! ButtonTableViewCell).delegate = self
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
