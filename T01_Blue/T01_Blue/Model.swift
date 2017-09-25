//
//  Model.swift
//  T01_Blue
//
//  Created by Haines Todd (haines.todd@okstate.edu) on 9/22/17.
//  Copyright © 2017 Blue Team. All rights reserved.
//  Description - the model class for the matching game project
import UIKit

class Model {
    
    private let DEBUG = true
    
    private var numCardsWidth: Int = -1
    private var numCardsHeight: Int = -1
    private var numTries: Int = -1
    private var numMatches: Int = 0
    private var numCards: Int = -1
    
    private var initialNumTries: Int = -1
    
    private var firstCardSelected = false
    private var selectedCards: (first:  (value: Int, coord: (r: Int, c: Int)),
        second: (value: Int, coord: (r: Int, c: Int))) = ((0,(-1,-1)),(0,(-1,-1)))
    
    private var cards: [[Int]] = []
    private var shownCards: [[Int]] = [] //a masking matrix to hide the values of the cards that aren't currently shown
    
    enum CardSelectReturnValue {
        case firstCardSelected
        case matchFound
        case matchNotFound
        case firstCardDeselected
        case unselectable
        case error
    }
    
    //constructor
    init (numCardsWidth: Int, numCardsHeight: Int, numTries: Int){
        self.numCardsWidth = numCardsWidth
        self.numCardsHeight = numCardsHeight
        self.numCards = numCardsWidth * numCardsHeight
        self.numTries = numTries
        self.initialNumTries = numTries
        
        //initialize all values in the card array to zeros
        cards = Array(repeating: Array(repeating: 0, count: self.numCardsWidth), count: self.numCardsHeight)
        shownCards = Array(repeating: Array(repeating: 0, count: self.numCardsWidth), count: self.numCardsHeight)
        self.reset()
        
        
    }
    
    public func reset() {
        
        numTries = initialNumTries
        numMatches = 0
        firstCardSelected = false
        var counter = 2
        
        //set all values in cards to be pairs of equal integers starting with 1
        for var r in 0..<cards.count {
            for var c in 0..<cards[r].count {
                cards[r][c] = counter/2
                counter = counter + 1
            }
        }
        
        //randomize the placement of each card
        for var y in 0..<cards.count {
            for var x in 0..<cards[y].count {
                let rand = (c: Int(arc4random_uniform(UInt32(numCardsWidth-1))),
                            r: Int(arc4random_uniform(UInt32(numCardsHeight-1))))
                
                let temp = cards[rand.r][rand.c]
                cards[rand.r][rand.c] = cards[y][x]
                cards[y][x] = temp
            }
        }
        
        if DEBUG {
            print("new card arrangement")
            printCardValues()
        }
    }
    
    public func selectCard (xCoord column: Int, yCoord row: Int) -> CardSelectReturnValue {
        
        //return that the card is unselectable by default
        var toReturn: Model.CardSelectReturnValue = CardSelectReturnValue.unselectable
        
        if column < 0 || row < 0 || column > (numCardsWidth-1) || row > (numCardsHeight-1) {
            return CardSelectReturnValue.error
        }
        
        if !firstCardSelected && shownCards[row][column] != 1 { //the first card is being selected
            firstCardSelected = true
            selectedCards.first.value = cards[row][column]
            shownCards[row][column] = 1
            selectedCards.first.coord.r = row
            selectedCards.first.coord.c = column
            toReturn = CardSelectReturnValue.firstCardSelected
        }
        else if firstCardSelected { //the second card is being selected
            firstCardSelected = false
            if selectedCards.first.coord.r == row && selectedCards.first.coord.c == column { //if the same card has been selected again
                shownCards[row][column] = 0
                selectedCards.first.value = 0
                selectedCards.first.coord.r = -1
                selectedCards.first.coord.c = -1
                toReturn = CardSelectReturnValue.firstCardDeselected
            }
            else { //a different card has been selected this time
                selectedCards.second.value = cards[row][column]
                if selectedCards.first.value == selectedCards.second.value { //a match was found
                    shownCards[row][column] = 1
                    numMatches = numMatches + 1
                    toReturn = CardSelectReturnValue.matchFound
                }
                else { //the two cards selected did not match
                    numTries = numTries - 1
                    shownCards[row][column] = 0
                    shownCards[selectedCards.first.coord.r][selectedCards.first.coord.c] = 0
                    toReturn = CardSelectReturnValue.matchNotFound
                    
                }
            }
        }
        
        return toReturn
    }
    
    public func isDead() -> Bool {
        if numTries < 0 {
            return true
        }
        else {return false}
    }
    
    public func getNumMatches() -> Int {
        return numMatches
    }
    
    public func getNumMissedTries() -> Int {
        return initialNumTries - numTries
    }
    
    public func getRemainingTries() -> Int {
        return numTries
    }
    
    public func getCardValue (xCoord column: Int, yCoord row: Int) -> Int {
        
        if column < 0 || row < 0 || column > (numCardsWidth-1) || row > (numCardsHeight-1) {
            return -1
        }
        if cards[row][column] == -1 {
            return -1
        }
        return cards[row][column]
    }
    
    public func getCardMap() -> [[Int]] {
        
        //create a copy of cards and return it
        var tempCards: [[Int]] = []
        for var r in 0..<cards.count {
            var arr: [Int] = []
            tempCards.append(arr)
            for var c in 0..<cards[r].count {
                tempCards[r].append(cards[r][c]*shownCards[r][c])
            }
        }
        return tempCards
    }
    
    
    public func printCardValues() {
        for var row in cards {
            for var card in row {
                print(String(format: "%3d,",card), terminator: "")
            }
            print()
        }
    }
    
    public func getNumCardsWidth() -> Int {
        return numCardsWidth
    }
    
    public func getNumCardsHeight() -> Int {
        return numCardsHeight
    }
}
