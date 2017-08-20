//
//  Player.swift
//  TicTacToeOfThrones
//
//  Created by Nisarg Mehta on 8/18/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

import Foundation

class Player {
    let name:String
    var numberOfTurns:Int?
    var imagesArray = NSMutableArray()
    init(name: String, images: NSMutableArray) {
        self.name = name
        self.numberOfTurns = 0
        self.imagesArray = images
    }
}
