//
//  GameResultViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/12/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func doClick()
}


class NextButtonTableViewCell : UITableViewCell {
    
    var delegate: ButtonCellDelegate!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func onClick() {
        delegate?.doClick()
    }

    var buttonText: String? = nil {
        didSet {
            self.btnNext.setTitle(buttonText, for: UIControlState.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnNext.contentMode = .scaleAspectFit
        btnNext.layer.cornerRadius = 8
        btnNext.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}

class ImageResultTableViewCell : UITableViewCell {
    
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

class TitleTableViewCell : UITableViewCell {
    
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

class Section {
    
    var title: String
    
    var images : [String] = []
    
    init (title: String)
    {
        self.title = title
    }
}

class GameResultViewController: BaseQuestionViewController, ButtonCellDelegate, UITableViewDelegate, UITableViewDataSource {

    var sections : [Section] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func doClick() {
        let result = Result(userIdentifier: self.schema.userIdentifier, code: self.schema.code)
        self.delegate?.doNextStep(result)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = []
        var currentSection : Section? = nil
        for item in self.schema.titles {
            if let text = item.text {
                if currentSection != nil && (currentSection?.images.count)! > 0 {
                    sections.append(currentSection!)
                }
                currentSection = Section(title: text)
            } else {
                currentSection?.images.append(item.imageUrl!)
            }
        }
        if currentSection != nil && (currentSection?.images.count)! > 0 {
            sections.append(currentSection!)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == sections.count {
            return 1
        } else {
            return sections[section].images.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let section = indexPath.section
        
        if section == sections.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as? NextButtonTableViewCell {
                cell.delegate = self
                cell.buttonText = self.schema.buttons[0].text
                return cell
            }
        } else {
            let section = sections[section]
            if index == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell", for: indexPath) as? TitleTableViewCell
                cell?.labelText = section.title
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Image Result Cell", for: indexPath) as? ImageResultTableViewCell
                cell?.imageUrl = section.images[index - 1]
                return cell!
            }
        }

        fatalError("invalid category")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
