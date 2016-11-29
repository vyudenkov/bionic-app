//
//  GameResultViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/12/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class Section {
    
    var title: String
    
    var images : [String] = []
    
    init (title: String)
    {
        self.title = title
    }
    
    init (title: String, images: [String])
    {
        self.title = title
        self.images = images
    }
}

class GameResultViewController: BaseSchemaViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {

    var sections : [Section] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func onClick(code: String?) {
        self.delegate?.saveSchema(Result(userIdentifier: self.schema.userIdentifier, code: self.schema.code))
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as? ButtonTableViewCell {
                cell.delegate = self
                cell.buttonTitle = self.schema.buttons[0].text
                return cell
            }
        } else {
            let section = sections[section]
            if index == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Text Cell", for: indexPath) as? TextTableViewCell
                cell?.labelText = section.title
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell", for: indexPath) as? ImageTableViewCell
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
