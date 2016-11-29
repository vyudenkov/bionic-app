//
//  GameCompactViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/19/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol StartGameSendMessageDelegate {
    func startGame(game: FMKGame)
}

class StartGameViewController: BaseGameViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var reusableCells: [RadioButtonViewCell] = []
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sendMessageDelegate: StartGameSendMessageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(self.schema?.buttons[0].text, for: UIControlState.normal)
        
        // prepare header text
        lblTitle.text = self.schema?.titles[0].text
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // imitialize radiobutton feature (single image selection)
        var buttons: [CheckRadioButton] = []
        for i in 0..<(schema?.questions.count ?? 0) {
            if let cell = tableView?.dequeueReusableCell(withIdentifier: "Radio Button Cell", for: IndexPath(row: i, section: 0)) as? RadioButtonViewCell {
                cell.question = schema.questions[i]
                let button = cell.imageButton
                //button?.showImage(imageUrl: schema.questions[i].imageUrl)
                buttons.append(button!)
                reusableCells.append(cell)
            }
        }
        
        for button in buttons {
            button.alternateButton = buttons
        }
    }
    
    @IBAction func onClick(_ sender: AnyObject) {
        super.next()
    }
    
    override func doAction(context: FMKGame) {

        sendMessageDelegate?.startGame(game: context)
    }
    
    override func validate () -> Bool {
        return reusableCells.contains(where: { ( cell: RadioButtonViewCell ) -> Bool in return cell.imageButton.isSelected })
    }
    
    override func context () -> FMKGame {
        if let cell = reusableCells.first(where: { ( cell: RadioButtonViewCell ) -> Bool in return cell.imageButton.isSelected }) {
            
            let result = FMKGame(type: self.schema.type, code: self.schema.code, userIdentifier: self.schema.userIdentifier, gameIdentifier: UUID())
            result.categories = self.schema.games;
            result.categories.append(FMKGameInfo((cell.question?.code)!, title: (cell.question?.text)!))
            return result
        }
        
        preconditionFailure("The method must be overriden")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schema?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return reusableCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
