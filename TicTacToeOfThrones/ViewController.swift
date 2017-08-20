//
//  ViewController.swift
//  TicTacToeOfThrones
//
//  Created by Nisarg Mehta on 8/18/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tileImageView: [UIImageView]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var gameBoard: UIView!
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    var theGame: GameModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for oneImageView in self.tileImageView {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            oneImageView.isUserInteractionEnabled = true
            oneImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        // start the game
        self.theGame = GameModel.sharedInstance
        self.theGame?.startGame()
        
        self.updateGameStatusLabel(forEvent: "turn")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGameStatusLabel(forEvent: String) {
        let current = self.theGame?.whoIsTheCurrentPlayer()
        switch forEvent {
        case "turn":
            self.gameStatusLabel.text = "\(current!.name) turn"
            break
        case "winner":
            self.gameStatusLabel.text = "\(current!.name) wins!"
            break
        case "draw":
            self.gameStatusLabel.text = "game draw!"
            break
        default:
            break
        }
    }
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        // reset game
        self.theGame?.startGame()
        // reset UI
        for oneImageView in self.tileImageView {
            oneImageView.image = nil
        }
        self.updateGameStatusLabel(forEvent: "turn")
    }
    
    func askForGameStatus() {
        // switch turns and update UI
        let theStatus = self.theGame?.getGameStatus()
        switch (theStatus!) {
        case gameStatus.gameDraw:
            self.updateGameStatusLabel(forEvent: "draw")
            break
        case gameStatus.gameOngoing:
            self.theGame?.switchPlayerTurn()
            self.updateGameStatusLabel(forEvent: "turn")
            break
        case gameStatus.playerOneWinner,
             gameStatus.playerTwoWinner:
            self.updateGameStatusLabel(forEvent: "winner")
            break;
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if self.theGame?.currentGameState != gameState.gameStateActive {
            // show some feedback
            return
        }
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        var status: positionStatus
        if self.theGame?.isPlayerOnesTurn == true {
            status = positionStatus.playerOne
        } else {
            status = positionStatus.playerTwo
        }
        if self.theGame?.updateBoardStatus(position: tappedImage.tag, status: status) == true {
            let current = self.theGame?.whoIsTheCurrentPlayer()
            current?.numberOfTurns! += 1
            let randomNum:UInt32 = arc4random_uniform(UInt32((current?.imagesArray.count)! - 1))
            let imageName = current?.imagesArray.object(at: Int(randomNum)) as! String
            current?.imagesArray.removeObject(at: Int(randomNum))
            tappedImage.image = UIImage(named: imageName)
            // check game status
            self.askForGameStatus()
        }
    }
}

