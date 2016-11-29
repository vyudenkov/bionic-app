//
//  FulfilmentViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/21/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class FulfilmentSection {
    
    var cells : [UITableViewCell] = []
    
    init (_ cell: UITableViewCell) {
        cells.append(cell)
    }
}

class FulfilmentViewController: BaseGameViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {

    var sections : [FulfilmentSection] = []
    
    // Text and image
    private var reusableStaticCells: [UITableViewCell] = []
    private var reusableCells: [RadioButtonViewCell] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func validate () -> Bool {
        return reusableCells.contains(where: { ( cell: RadioButtonViewCell ) -> Bool in return cell.imageButton.isSelected })
    }
    
    override func context () -> FMKGame {
        if let cell = reusableCells.first(where: { ( cell: RadioButtonViewCell ) -> Bool in return cell.imageButton.isSelected }) {
            
            let categories = [ FMKGameInfo((cell.question?.code)!, title: (cell.question?.text)!)]
            let result = FMKGame(type: self.schema.type, code: self.schema.code, userIdentifier: self.schema.userIdentifier, gameIdentifier: self.schema.gameIdentifier!)
            result.categories = categories
            return result;
        }
        
        preconditionFailure("The method must be overriden")
    }
    
    func onClick(code: String?) {
        super.next()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = self.schema.titles[0].text!
        self.lblTitle.sizeToFit()
        
        self.sections = []
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var currentSection : FulfilmentSection? = nil
        
        var buttons : [CheckRadioButton] = []
        
        for i in 1..<self.schema.categories.count {
            let category = self.schema.categories[i]
            let indexPath = IndexPath(row: (i - 1), section: 0)
            if category.type == Category.Title, let element = category as? Element {
                if element.imageUrl == nil {
                    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Text Cell", for: indexPath) as? TextTableViewCell {
                        cell.labelText = element.text
                        
                        currentSection = FulfilmentSection(cell)
                        self.sections.append(currentSection!)
                    }
                } else {
                    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Image Cell", for: indexPath) as? ImageTableViewCell {
                        cell.imageUrl = element.imageUrl
                        currentSection?.cells.append(cell)
                    }
                }
            } else if category.type == Category.Question, let element = category as? Element {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Radio Button Cell", for: indexPath) as? RadioButtonViewCell {
                    cell.question = element
                    buttons.append(cell.imageButton!)
                    if self.reusableCells.count == 0 {
                        currentSection = FulfilmentSection(cell)
                        self.sections.append(currentSection!)
                    } else {
                        currentSection?.cells.append(cell)
                    }
                    self.reusableCells.append(cell)
                }
            } else if category.type == Category.Button, let element = category as? Element {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as? ButtonTableViewCell {
                    cell.buttonTitle = element.text
                    cell.delegate = self
                    self.sections.append(FulfilmentSection(cell))
                }
            }
        }
        
        for button in buttons {
            button.alternateButton = buttons
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let section = indexPath.section
        return self.sections[section].cells[index]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
