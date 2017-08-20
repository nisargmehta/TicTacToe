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
        
        self.updateGameStatusLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGameStatusLabel() {
        let current = self.theGame?.whoIsTheCurrentPlayer()
        self.gameStatusLabel.text = "\(current!.name) turn"
    }
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        // reset game
        self.theGame?.startGame()
        // reset UI
        for oneImageView in self.tileImageView {
            oneImageView.image = nil
        }
        self.updateGameStatusLabel()
    }
    
    func askForGameStatus() {
        // switch turns and update UI
        self.theGame?.switchPlayerTurn()
        self.updateGameStatusLabel()
        let theStatus = self.theGame?.getGameStatus()
        switch (theStatus!) {
        case gameStatus.gameDraw:
            self.gameStatusLabel.text = "Game draw"
            break
        case gameStatus.gameOngoing:
            break
        case gameStatus.playerOneWinner:
            self.gameStatusLabel.text = "Team jon wins!!"
            break
        case gameStatus.playerTwoWinner:
            self.gameStatusLabel.text = "player two wins"
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        var status: positionStatus
        if self.theGame?.isPlayerOnesTurn == true {
            status = positionStatus.playerOne
        } else {
            status = positionStatus.playerTwo
        }
        if self.theGame?.updateBoardStatus(position: tappedImage.tag, status: status) == true {
            let current = self.theGame?.whoIsTheCurrentPlayer()
            current?.numberOfTurns += 1
            let imageName = current?.imagesArray.object(at: 0) as! String
            current?.imagesArray.removeObject(at: 0)
            tappedImage.image = UIImage(named: imageName)
            
            // check game status
            self.askForGameStatus()
        }
    }
}

