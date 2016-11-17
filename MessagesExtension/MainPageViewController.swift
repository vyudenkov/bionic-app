//
//  MainPageViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/15/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol ShowHistoryDelegate {
    func showHistory(userIdentifier: UUID, item: HistoryItem?)
}

class TryAgainTableViewCell : UITableViewCell {
    
    var delegate : ShowHistoryDelegate?
    var userIdentifier: UUID!
    var buttonTitle: String!
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func onClick() {
        delegate?.showHistory(userIdentifier: self.userIdentifier, item: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startButton.layer.cornerRadius = 8
        startButton.layer.borderColor = UIColor.red.cgColor
        startButton.layer.masksToBounds = true
        startButton.setTitle(buttonTitle, for: UIControlState.normal)
        
        self.backgroundColor = UIColor.clear
    }
}

class HistoryItemTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imagesList: UICollectionView!
    
    var delegate : ShowHistoryDelegate?
    
    var historyItem: HistoryItem? = nil {
        didSet {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
}

class MainPageViewController: UIViewController, ShowHistoryDelegate, UITableViewDelegate, UITableViewDataSource {
    
    internal func showHistory(userIdentifier: UUID, item: HistoryItem?) {
        delegate?.showHistory(userIdentifier: userIdentifier, item: item)
    }

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ShowHistoryDelegate!
    
    var historyItems : [HistoryItem] = []
 
    var userIdentifier : UUID!
    
    var buttonTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        var cell : UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Try Again Cell", for: indexPath)
            (cell as! TryAgainTableViewCell).delegate = self
            (cell as! TryAgainTableViewCell).userIdentifier = self.userIdentifier
            (cell as! TryAgainTableViewCell).buttonTitle = self.buttonTitle
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "History Cell", for: indexPath)
            (cell as! HistoryItemTableViewCell).delegate = self
            (cell as! HistoryItemTableViewCell).historyItem = self.historyItems[index - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func process(json: Dictionary<String, Any>) {
       if let items = json["items"] as? [Dictionary<String, Any>] {
           for item in items {
               let gameIdentifier = UUID(uuidString: (item["gameIdentifier"] as? String)!)!
               let title = item["title"] as! String
               let percentDone = item["percentDone"] as? Double ?? 0
            
               let history = HistoryItem(gameIdentifier: gameIdentifier, title: title, percentDone: percentDone)
               history.gameItems = (item["gameItems"] as? [String])!
               historyItems.append(history)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        
        let requestURL = URL(string: "\(Settings.serverPath)/history/\(self.userIdentifier.uuidString)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        print("=== Request History (GET): " + (requestURL?.absoluteString)!)
        
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
    }
}
