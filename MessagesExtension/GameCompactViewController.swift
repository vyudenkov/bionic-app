//
//  GameCompactViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/19/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol GameCompactSendMessageDelegate {
    func startGame(_ controller: GameCompactViewController, game: FMKGame)
}

class GameCompactViewCell : UITableViewCell {
    
    @IBOutlet weak var imageButton: CheckRadioButton!
    @IBOutlet weak var imageText: UIButton!
    @IBAction func textClick() {
        imageButton.toggleButton()
        imageButton.unselectAlternateButtons()
    }

    var question: Element? = nil {
        didSet {
            self.imageText.setTitle(question!.text, for: UIControlState.normal)
            self.imageText.sizeToFit()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

class GameCompactViewController: BaseQuestionViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var reusableCells: [GameCompactViewCell] = []
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selection : [FMKGameItem]!
    
    var sendMessageDelegate: GameCompactSendMessageDelegate?
    
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
            if let cell = tableView?.dequeueReusableCell(withIdentifier: "gameCompactViewCell", for: IndexPath(row: i, section: 0)) as? GameCompactViewCell {
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
    
    override func doAction(context: ExecutionContext) {

        sendMessageDelegate?.startGame(self, game: context as! FMKGame)
    }
    
    override func validate () -> Bool {
        return reusableCells.contains(where: { ( cell: GameCompactViewCell ) -> Bool in return cell.imageButton.isSelected })
    }
    
    override func context () -> ExecutionContext {
        if let cell = reusableCells.first(where: { ( cell: GameCompactViewCell ) -> Bool in return cell.imageButton.isSelected }) {
            
            let title = cell.question?.text
            let result = FMKGame(userIdentifier: self.schema.userIdentifier, gameIdentifier: UUID(), title: title!, code: (cell.question?.code)!)
            result.categories = self.selection;
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
