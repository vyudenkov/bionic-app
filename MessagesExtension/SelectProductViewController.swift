//
//  SelectProductViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class SelectProductViewController: BaseSchemaViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    override func context () -> Result {
        let result = Result(userIdentifier: self.schema.userIdentifier, code: self.schema.code)
        
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
