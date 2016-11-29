
//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Vitaliy on 10/10/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit
import Messages


extension MSMessage {
    
    func isMyMessage(conversation: MSConversation) -> Bool {
        return self.senderParticipantIdentifier == conversation.localParticipantIdentifier
    }
}

class MessagesViewController: MSMessagesAppViewController {

    let serverUrl = "http://192.168.8.238:1337"
    
    var currentResult: Result? = nil

    var currentContext: Categories? = nil
    
    var gameIdentifier: UUID? = nil
    
    var selection: [FMKGameItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    fileprivate func showControler(controller: UIViewController) {
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(controller.view)
        
        let c1 = controller.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        c1.identifier = "leftAnchor"
        c1.isActive = true
        
        let c2 = controller.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        c2.identifier = "rightAnchor"
        c2.isActive = true
        
        if self.presentationStyle == MSMessagesAppPresentationStyle.compact {
            let c3 = controller.view.topAnchor.constraint(equalTo: view.topAnchor)
            c3.identifier = "myTopAnchor compact"
            c3.isActive = true
            
            let c4 = controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            c4.identifier = "myBottomAnchor compact"
            c4.isActive = true
        }
        else {
            let c3 = controller.view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 86)
            c3.identifier = "myTopAnchor expanded"
            c3.isActive = true
            
            let c4 = controller.view.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 60)
            c4.identifier = "myBottomAnchor expanded"
            c4.isActive = true
        }
        
        controller.didMove(toParentViewController: self)
        
    }
    
    override func willBecomeActive(with conversation: MSConversation){

        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("didResignActive")
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
        print("didReceive")
        print("local:")
        print(conversation.localParticipantIdentifier)
        print("remote:")
        print(conversation.remoteParticipantIdentifiers)
        
        print("message:")
        print(message.url!)
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        print("didStartSending")
        print(conversation.remoteParticipantIdentifiers)
        
        let game = FMKGame(message: message, isOriginal: false)
        if let exist = game {
            exist.userIdentifier = conversation.localParticipantIdentifier
            exist.respondents = conversation.remoteParticipantIdentifiers.map { $0.uuidString }
            saveGame(exist)
        }
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
        print("didCancelSending")
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
        

    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        presentViewController(for: conversation, with: presentationStyle)
    }
}

// Send game to server - new game or game response
extension MessagesViewController : SaveGameDelegate {
    
    func saveGame(_ game: FMKGame, process: @escaping (Dictionary<String, Any>) -> Void) {
        
        let requestURL = URL(string: "\(serverUrl)/game")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = game.toJson()
        
        print("=== Request Game (POST): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        process(json)
                    } catch {
                        print("!!!Error")
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
    
    // Method is called ONLY for selected game in history
    func loadGame(_ gameId: UUID) {
        
        let requestURL = URL(string: "\(Settings.serverPath)/game/\(gameId.uuidString)")
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
    }

    // Save game to server
    func saveGame(_ game: FMKGame) {
        
        // response from recepients
        if game.type == Categories.GameStart {
            saveGame(game, process: { _ in print("!!!Game sent") })
        } else if game.type == Categories.GameResponse {
            saveGame(game, process: { _ in print("!!!Game response sent") })
        } else if game.type == Categories.GameEnd {
            requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
        } else {
            saveGame(game, process: process)
        }
    }
}

// Navigation
extension MessagesViewController : SaveResponseControllerDelegate {
    
    func process(model: Categories) {
        self.currentContext = model
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MainInterface", bundle: nil)
        
        if let model = model as? Schema {
            
            var controller: UIViewController? = nil
            if model.type == Categories.QuestionList {
                controller = storyboard.instantiateViewController(withIdentifier: "questionsListView")
            } else if model.type == Categories.Info {
                controller = storyboard.instantiateViewController(withIdentifier: "staticCollectionView")
            } else if model.type == Categories.QuestionButtons && model.questions.count == 3 {
                controller = storyboard.instantiateViewController(withIdentifier: "threeQuestionsView")
            } else if model.type == Categories.QuestionButtons && model.questions.count == 2 {
                controller = storyboard.instantiateViewController(withIdentifier: "twoQuestionView")
            } else if model.type == Categories.YesNo {
                controller = storyboard.instantiateViewController(withIdentifier: "staticYesNoView")
            } else if model.type == Categories.MiddleInfo {
                controller = storyboard.instantiateViewController(withIdentifier: "middleInfoView")
            } else if model.type == Categories.TwoQuestion {
                controller = storyboard.instantiateViewController(withIdentifier: "twoQuestionsView")
            } else if model.type == Categories.GameSelection {
                controller = storyboard.instantiateViewController(withIdentifier: "selectProductView")
            } else if model.type == Categories.GameSelectionResult {
                controller = storyboard.instantiateViewController(withIdentifier: "gameResultView")
            } else if model.type == Categories.GameStart {
                controller = storyboard.instantiateViewController(withIdentifier: "startGameView")
                (controller as! StartGameViewController).sendMessageDelegate = self
            } else if model.type == Categories.GameResponse {
                controller = storyboard.instantiateViewController(withIdentifier: "respondGameView")
            } else if model.type == Categories.GameProductResult {
                controller = storyboard.instantiateViewController(withIdentifier: "productResultView")
            } else if model.type == Categories.GameFulfilment {
                controller = storyboard.instantiateViewController(withIdentifier: "fulfilmentView")
            } else if model.type == Categories.GameEnd {
                controller = storyboard.instantiateViewController(withIdentifier: "gameEndView")
            }
            
            if let c = controller as? BaseSchemaViewController {
                c.delegate = self
                c.schema = model
                showControler(controller: c)
            } else if let c = controller as? BaseGameViewController {
                c.delegate = self
                c.schema = model
                showControler(controller: c)
            } else {
                print("Visualization type: \(model.type)")
                fatalError("Undefined case for question controller")
            }
        } 
    }
    
    func process(json: Dictionary<String, Any>) {
        
        if let userIdentifierString = json["userIdentifier"] as? String, let userIdentifier = UUID(uuidString: userIdentifierString) {
            
            if let type = json["type"] as? String {
                
                let model = ModelBuilder.create(userIdentifier: userIdentifier, type: type, json: json)
                if let model = model as? Schema {
                    
                    DispatchQueue.main.async {
                        if model.isFullScreen && self.presentationStyle == .compact {
                            self.requestPresentationStyle(.expanded)
                            self.process(model: model)
                        } else if !model.isFullScreen && self.presentationStyle == .expanded {
                            self.requestPresentationStyle(.compact)
                            self.currentContext = model
                        } else {
                            self.process(model: model)
                        }
                    }
                }
            }
        }
    }
    
    func sendResponse(_ data: Data, process: @escaping (Dictionary<String, Any>) -> Void) {

        let requestURL = URL(string: "\(serverUrl)/workflow")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        print("=== Request (POST): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        process(json)
                    } catch {
                        print("!!!Error")
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
    
    internal func saveSchema(_ response: Result) {
        print("Next step: ")
        self.currentResult = response
        
        let json = response.toJson(prettyPrinted: false)
        sendResponse(json!, process: process)
    }
    
    func showNextStep(_ userIdentifier: UUID) {
        
        let c = currentResult ?? Result(userIdentifier: userIdentifier, code: "")
        saveSchema(c)
    }
    
    func showCurrentStep(_ userIdentifier: UUID, presentationStyle: MSMessagesAppPresentationStyle) {
        if let model = currentContext {
            
            if model.isFullScreen && presentationStyle == .expanded {
                print ("========= Show current step FULL: \(model.code)")
                process(model: model)
            } else if !model.isFullScreen && presentationStyle == .compact {
                print ("========= Show current step COMPACT: \(model.code)")
                process(model: model)
            } else {
                print ("========= Show main page")
                showMainPage(userIdentifier: userIdentifier, isBack: true)
                self.gameIdentifier = nil
                self.currentContext = nil
            }
        } else {
            print ("========= Show main page")
            showMainPage(userIdentifier: userIdentifier)
            self.gameIdentifier = nil
            self.currentContext = nil
        }
    }
}


// Game
extension MessagesViewController {

    // opens game for recepient
    func showGame(with: FMKGame) {
        let storyboard: UIStoryboard = UIStoryboard(name: "MainInterface", bundle: nil)
        
        let controller: RespondGameViewController = storyboard.instantiateViewController(withIdentifier: "gameView") as! RespondGameViewController
        
        let schema = Schema(type: with.type, code: with.code, isFullScreen: true, userIdentifier: with.userIdentifier, gameIdentifier: with.gameIdentifier)
        schema.categories = with.categories
        controller.delegate = self
        controller.respondDelegate = self
        controller.schema = schema
        
        showControler(controller: controller)
    }
    
    
    fileprivate func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        // TODO: fix issue with the same apple id
        let userId = conversation.localParticipantIdentifier
        let remote = conversation.remoteParticipantIdentifiers
        print("local: \(userId); remote: \(remote)")
        
        // Determine the controller to present.
        if presentationStyle == .compact {

            showCurrentStep(userId, presentationStyle: presentationStyle)
        }
        else {
            // Url assigned to message means that it is a game with respondents
            let game = FMKGame(message: conversation.selectedMessage, isOriginal: true)
            
            if let exist = game {
                showGame(with: exist)
            } else if let id = self.gameIdentifier {
                loadGame(id)
            } else {
                showCurrentStep(userId, presentationStyle: presentationStyle)
            }
        }
    }
}


extension MessagesViewController: ShowHistoryDelegate {
    
    // Ratings are assigned by respondent
    func showHistory(userIdentifier: UUID, item: HistoryItem?) {
        
        if let history = item {
            self.gameIdentifier = history.gameIdentifier
            if self.presentationStyle == .compact {
                self.requestPresentationStyle(.expanded)
            } else {
                print("Requested history" + (history.gameIdentifier.uuidString))
                self.loadGame(history.gameIdentifier)
            }
        }
        else {
            showNextStep(userIdentifier)
        }
    }
    
    
    func showMainPage(userIdentifier: UUID, isBack: Bool = false) {
        let storyboard: UIStoryboard = UIStoryboard(name: "MainInterface", bundle: nil)
        
        let controller: MainPageViewController = storyboard.instantiateViewController(withIdentifier: "mainPageView") as! MainPageViewController
        
        controller.delegate = self
        controller.userIdentifier = userIdentifier
        controller.buttonTitle = isBack ? "Continue" : "Select Products"
        controller.fullScreen = self.presentationStyle == .expanded
        showControler(controller: controller)
    }
}


// Send selection (Game) to respondents
extension MessagesViewController: StartGameSendMessageDelegate {
   
    fileprivate func composeMessage(with game: FMKGame, caption: String, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        components.queryItems = game.queryItems
        
        let layout = MSMessageTemplateLayout()
        layout.image = game.render()
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
   
    func startGame(game: FMKGame) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        let messageCaption = NSLocalizedString((game.gameInfo?.title!)!, comment: "")
        
        let message = composeMessage(with: game, caption: messageCaption, session: conversation.selectedMessage?.session)
        
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
    }
}

// Send response to the Game
extension MessagesViewController : RespondGameViewControllerDelegate {
    
    fileprivate func composeMessage(with game: FMKGame, caption: String, message: MSMessage? = nil) -> MSMessage {
        if let exist = FMKGame(message: message, isOriginal: true) {
            
            var queryItems = exist.queryItems
            let response = URLQueryItem(name: "response", value: game.toJsonString()?.toBase64())
            queryItems.append(response)
            
            var components = URLComponents()
            components.queryItems = queryItems
            
            let layout = MSMessageTemplateLayout()
            layout.image = exist.render()
            layout.caption = caption
            
            let message = MSMessage(session: message?.session ?? MSSession())
            message.url = components.url!
            message.layout = layout
            
            return message
        }
        else {
            return composeMessage(with: game, caption: caption, session: nil)
        }
    }
    
    // Ratings are assigned by respondent
    func respondGame(_ gameResponse: FMKGame) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        gameResponse.userIdentifier = conversation.localParticipantIdentifier
        
        let messageCaption = NSLocalizedString("I've rated: $\(conversation.localParticipantIdentifier.uuidString)", comment: "")
        
        let message = composeMessage(with: gameResponse, caption: messageCaption, message: conversation.selectedMessage)
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
    }
}



