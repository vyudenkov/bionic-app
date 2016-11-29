//
//  ProductResultViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/22/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit


class ProductResultViewController: BaseGameViewController, ButtonClickDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var gameResults : [FMKGameItem] = []
    
    private var reusableCells: [ProductResultTableViewCell] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func validate () -> Bool {
        return reusableCells.filter({ (cell: ProductResultTableViewCell) -> Bool in
            if cell.result() != nil {
                return true
            }
            return false
        }).count > 0
    }
    
    override func context () -> FMKGame {
        let result: FMKGame = FMKGame(type: self.schema.type, code: self.schema.code, userIdentifier: self.schema.userIdentifier, gameIdentifier: self.schema.gameIdentifier)
        
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
        
        self.lblTitle.text = self.schema.titles[0].text
        self.lblTitle.sizeToFit()
        
        let count = self.schema.respondents.count
        self.gameResults = self.schema.getMarryKill()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0..<self.gameResults.count {
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Product Result Cell", for: IndexPath(row: i, section: 0)) as? ProductResultTableViewCell {
                cell.responseCount = count
                cell.gameItem = self.gameResults[i]
                
                self.reusableCells.append(cell)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameResults.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == self.gameResults.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
            (cell as! ButtonTableViewCell).buttonTitle = self.schema.buttons[0].text
            (cell as! ButtonTableViewCell).delegate = self
            return cell
        }
        return reusableCells[index]
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*func process(json: Dictionary<String, Any>) {
        
        self.schema = Schema.fromJson(json: json)
        self.gameResults = self.schema.getMarryKill()
        
        let count = self.gameResults.count
        
        DispatchQueue.main.async {
            
            self.lblTitle.text = self.schema.titles[0].text
            self.lblTitle.sizeToFit()
            
            
            for i in 0..<self.gameResults.count {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Product Result Cell", for: IndexPath(row: i, section: 0)) as? ProductResultTableViewCell {
                    cell.responseCount = count
                    cell.gameItem = self.gameResults[i]
             
                    self.reusableCells.append(cell)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        
        let requestURL = URL(string: "\(Settings.serverPath)/game/\(self.gameIdentifier.uuidString)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        print("=== Request Game (GET): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        self.process(json: json)
                    } catch {
                        print("Error")
                    }
                } else {
                    print("!!!Incorrect status code: \(httpResponse.statusCode) - " + httpResponse.statusCode.description)
                }
            } else {
                print("!!!Response is null: " + error.debugDescription)
            }
        })
        task.resume()
    }*/
}
