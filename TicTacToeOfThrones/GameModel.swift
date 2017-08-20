//
//  GameModel.swift
//  TicTacToeOfThrones
//
//  Created by Nisarg Mehta on 8/18/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

import Foundation

enum positionStatus {
    case empty
    case playerOne
    case playerTwo
}

enum gameStatus {
    case gameOngoing
    case playerOneWinner
    case playerTwoWinner
    case gameDraw
}

class GameModel {
    static let sharedInstance = GameModel()
    private init() {}
    
    let winningCombos:[(one: Int, two: Int, three: Int)] = [(one:0,two:1,three:2),(one:3,two:4,three:5),(one:6,two:7,three:8),(one:0,two:3,three:6),(one:1,two:4,three:7),(one:2,two:5,three:8),(one:0,two:4,three:8),(one:2,two:4,three:6)]
    
    var boardStatus = NSMutableArray()
    private let playerOne = Player (name: "Team jon", images: [])
    private let playerTwo = Player (name: "White walker", images: [])
    
    var isPlayerOnesTurn: Bool = true
    
    func switchPlayerTurn() {
        self.isPlayerOnesTurn = !self.isPlayerOnesTurn
    }
    
    func whoIsTheCurrentPlayer() -> Player {
        if self.isPlayerOnesTurn == true {
            return playerOne
        } else {
            return playerTwo
        }
    }
    
    func startGame() {
        self.isPlayerOnesTurn = true
        self.boardStatus = [positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty,positionStatus.empty]
        self.playerOne.imagesArray = ["arya","dany","jonSnow","olenna","tyrion"]
        self.playerTwo.imagesArray = ["ramsey","baelish","redLady","nightKing"]
    }
    
    func updateBoardStatus(position:Int, status:positionStatus) -> Bool {
        if self.boardStatus.count-1 < position {
            return false
        }
        // update the board only if that position was empty
        if self.boardStatus.object(at: position) as! positionStatus == positionStatus.empty {
            self.boardStatus.replaceObject(at: position, with: status)
            return true
        }
        return false
    }
    
    func getGameStatus() -> gameStatus {
        // winning combos: 0,1,2 | 3,4,5 | 6,7,8 | 0,3,6 | 1,4,7 | 2,5,8 | 0,4,8 | 2,4,6
        if self.playerOne.numberOfTurns + self.playerTwo.numberOfTurns < 5 {
            return gameStatus.gameOngoing
        }
        for combo in self.winningCombos {
            let result = self.isThereAWinner(one: combo.one, two: combo.two, three: combo.three)
            if result != positionStatus.empty {
                if result == positionStatus.playerOne {
                    return gameStatus.playerOneWinner
                } else {
                    return gameStatus.playerTwoWinner
                }
            }
        }
        if self.playerOne.numberOfTurns + self.playerTwo.numberOfTurns == 9 {
            return gameStatus.gameDraw
        } else {
            return gameStatus.gameOngoing
        }
    }
    
    func isThereAWinner(one: Int, two: Int, three: Int) -> positionStatus {
        if self.boardStatus.object(at: one) as! positionStatus == self.boardStatus.object(at: two) as! positionStatus && self.boardStatus.object(at: one) as! positionStatus == self.boardStatus.object(at: three) as! positionStatus && self.boardStatus.object(at: one) as! positionStatus != positionStatus.empty {
            return self.boardStatus.object(at: one) as! positionStatus
        }
        return positionStatus.empty
    }
}
