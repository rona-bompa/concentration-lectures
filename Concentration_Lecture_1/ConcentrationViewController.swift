//
//  ViewController.swift
//  Concentration_Lecture_1
//
//  Created by Rona Bompa on 18.02.2022.
//
import UIKit

class ConcentrationViewController: VCLLoggingViewController {

    override var vclLoggingName: String {
        return "Game"
    }

    private lazy var game = Concentration(numberOfPairOfCards: numberOfPairOfCards)
    private var numberOfPairOfCards: Int {
            return (cardButtons.count + 1) / 2 // if it's readonly, we can skip the "get"
    }

    private lazy var emojiChoices = game.theme.emojis
    private var emoji = [Int:String]()  // Card instead of Int

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    override func viewDidLoad() {
        // Commented only for Lecture 7 to work fine
//        for index in cardButtons.indices {
//            cardButtons[index].backgroundColor = game.theme.cardBackgroundColor
//        }
    }

    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.choseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons Outlet Collection")
        }
    }

    func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = UIColor.white
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.systemBlue // Original: game.theme.cardBackgroundColor
                }
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score: \(game.score)"
        }
    }

     //Lecture 7
    var themeConcentration: [String]? {
        didSet {
            emojiChoices = themeConcentration ?? [""]
            emoji = [:] // empty dictionary [Int:String]
            updateViewFromModel()
        }
    }

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 { // emoji[card] insetead of emoji[card.identifier]
            let randomIndex = emojiChoices.count.arc4random
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.resetGame()
        emojiChoices.removeAll()
        //emojiChoices = game.theme.emojis
        emoji.removeAll() // reset dictonary of identifiers & emojis
        // reset the buttons
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = game.theme.cardBackgroundColor
        }
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))  // self = emojiChoises.count (the upper limit of arc4random func it's itself)
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
