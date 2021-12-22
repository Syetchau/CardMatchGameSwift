//
//  ViewController.swift
//  CardMatchGame
//
//  Created by LiewSyetChau on 8/12/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let cardModel = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    var timer: Timer?
    var milliseconds: Int = 10 * 1000
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardArray = cardModel.getCards()
        
        // set the view controller as the data source and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(
            timeInterval: 0.001,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    @objc func timerFired() {
        
        //decrement the counter
        milliseconds -= 1
        
        //update the label
        let second: Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", second)
        
        //stop the timer if reach zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //TODO: check if user has cleared all the pairs
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return number of cards
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //configure state of the cell based on the properties of the card that its represent
        //get the card from card array
        let cardCell = cell as? CardCollectionViewCell
        
        //get the card from the array
        let card = cardArray[indexPath.row]
        
        //finish configuring the cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there's any time remaining, dont let the user interact if time <= 0
        if milliseconds <= 0 {
            return 
        }
        
        //get reference to cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //check the status of the card
        let status = cell?.card?.isFlipped
        
        if status == false && cell?.card?.isMatched == false {
            //flip the card up
            cell?.flipUp()
            
            // Play flip sound
            soundPlayer.playSound(effect: .flip)
            
            //check if this is first card flipped or second card flipped
            if firstFlippedCardIndex == nil {
                //this is the first card flipped
                firstFlippedCardIndex = indexPath
            } else {
                //this is the second card flipped
                //run comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game Logic Methods
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        //get the two card object and check indices and see if they match
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //get the two collection view cells that represent cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //its a match
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            //set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //check for last pair
            checkForGameEnd()
            
        } else {
            //it not match
            
            // Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        //reset the firstFlippedCardIndex
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        //check if there's any card that is unmatched
        //assume the user has won
        //loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                // found card that still left unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            // user win
            showAlert(title: "Congratulations!", message: "You've won the game!")
        } else {
            // user lose
            // check still got time left
            if milliseconds <= 0 {
                showAlert(title: "Time's up!", message: "Sorry, better luck next time!")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        //create alert
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        //add btn to user to dismiss it
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
        
        //add ok action to alert
        alert.addAction(okAction)
        
        //show the alert
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}

