//
//  Concentration.swift
//  Concentration_Lecture_1
//
//  Created by Rona Bompa on 18.02.2022.
//

import Foundation
import UIKit

struct Concentration {

    var themes = [
        Theme(emojis: ["🎻","🎹","🎷", "🎺", "🎸", "🪕", "🪘" ,"🎤","🎼","🪗"], name: "Music", cardBackgroundColor: UIColor.orange),
        Theme(emojis: ["🏀","⚽️","🥎", "🏐", "🏓", "🎱", "🏉" ,"🏸","🥊","🏹"], name: "Sports", cardBackgroundColor: UIColor.blue),
        Theme(emojis: ["🍎","🫐","🍉", "🍇", "🍍", "🥝", "🥥" ,"🍒","🍋","🍊"], name: "Fruits", cardBackgroundColor: UIColor.yellow),
        Theme(emojis: ["🧄","🌶","🍅", "🥒", "🥬", "🥦", "🥕" ,"🫒","🥔","🧅"], name: "Vegetables", cardBackgroundColor: UIColor.green),
        Theme(emojis: ["👘","👠","👢", "👔", "👞", "👒", "🪡" ,"🧵","👗","👛"], name: "Fashion", cardBackgroundColor: UIColor.red),
        Theme(emojis: ["🦁","🐰","🐨", "🐔", "🦊", "🐻", "🐒" ,"🐴","🐢","🐬"], name: "Animals", cardBackgroundColor: UIColor.brown)
    ]

//    var themes = [
//        Theme(emojis: "🎻🎹🎷🎺🎸🪕🪘🎤🎼🪗", name: "Music", cardBackgroundColor: UIColor.orange),
//        Theme(emojis: "🏀⚽️🥎🏐🏓🎱🏉🏸🥊🏹", name: "Sports", cardBackgroundColor: UIColor.blue),
//        Theme(emojis: "🍎🫐🍉🍇🍍🥝🥥🍒🍋🍊", name: "Fruits", cardBackgroundColor: UIColor.yellow),
//        Theme(emojis: "🧄🌶🍅🥒🥬🥦🥕🫒🥔🧅", name: "Vegetables", cardBackgroundColor: UIColor.green),
//        Theme(emojis: "👘👠👢👔👞👒🪡🧵👗👛", name: "Fashion", cardBackgroundColor: UIColor.red),
//        Theme(emojis: "🦁🐰🐨🐔🦊🐻🐒🐴🐢🐬", name: "Animals", cardBackgroundColor: UIColor.brown)
//    ]

    var theme: Theme
    private(set) var cards = [Card]()

    var flipCount = 0
    var score = 0

    // "vector de frecventa"
    var historyOfCardChoises = [Int:Int]() // Int1 = card identifier, Int2 = 0 - seen once, 1 - seen again, > 1 - seen again & again

    // computed property
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly // added a oneAndOnly extension
//            var foundIndex: Int?
//            for index in cards.indices { // searching through all the faceUp cards
//                if cards[index].isFaceUp {
//                    if foundIndex == nil { // there is 1 faceUp card
//                        foundIndex = index
//                    } else { // there are 2 or 0 faceUp cards, so we return nil
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue) // faceUp = false for all cards except the one and only
            }
        }
    }

    init(numberOfPairOfCards: Int) {
        assert(numberOfPairOfCards > 0, "Concentration.init(\(numberOfPairOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
        self.theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
    }

    // game logic
    mutating func choseCard(at currIndex: Int) {
        assert(cards.indices.contains(currIndex), "Concentration.chooseCard(at: \(currIndex)): chosen index not in the cards")
        flipCount += 1

        // gonna igonre all the matched cards
        if !cards[currIndex].isMatched {

            // case A) 1 card is already face up
            if let prevIndex = indexOfOneAndOnlyFaceUpCard, prevIndex != currIndex {
                // check if the chosen card matches with the card that is already face up
                if cards[prevIndex].identifier == cards[currIndex].identifier {
                    cards[prevIndex].isMatched = true
                    cards[currIndex].isMatched = true
                    score += 2
                } else {
                    // if the emoji was not seen (is nil), we add it to the dictionary
                    if(historyOfCardChoises[cards[currIndex].identifier] == nil){
                        historyOfCardChoises[cards[currIndex].identifier] = 0
                    } else {
                    // if not nil, then we mark it as seen again
                        historyOfCardChoises[cards[currIndex].identifier]! += 1
                        score -= 1
                    }
                    // if the previous was seen, penalty -1
                    if let history = historyOfCardChoises[cards[prevIndex].identifier], history > 1 {
                        score -= 1
                    }
                }
                cards[currIndex].isFaceUp = true
                // did it in the indexOfOneAndOnlyFaceUp computed property
//                indexOfOneAndOnlyFaceUpCard = nil

            } else {
                // did it in the indexOfOneAndOnlyFaceUp computed property (case B & C)
//                 case B) 2 cards are face up (matching or not matching)
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false //all the cards face down
//                }
//                 case C) 0 face up cards
//                cards[currIndex].isFaceUp = true // the one picked -> face up

                indexOfOneAndOnlyFaceUpCard = currIndex

                // if this card is new, then add it to the dictionary:
                if historyOfCardChoises[cards[currIndex].identifier] == nil {
                    historyOfCardChoises[cards[currIndex].identifier] = 0
                } else {
                // if not, mark as seen again
                    historyOfCardChoises[cards[currIndex].identifier]! += 1
                }
            }
        }
    }

    mutating func resetGame() {
        flipCount = 0
        score = 0

        historyOfCardChoises.removeAll()
        indexOfOneAndOnlyFaceUpCard = nil

        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()

       self.theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
