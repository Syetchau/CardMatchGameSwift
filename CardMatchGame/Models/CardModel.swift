//
//  CardModel.swift
//  CardMatchGame
//
//  Created by LiewSyetChau on 11/12/21.
//

import Foundation


class CardModel {
    
    func getCards() -> [Card] {
        
        //Delcare an empty array to store the number that we generated
        var generatedNumber = [Int]()
        
        //Declare an empty array
        var generateCards = [Card]()
        
        //Randomly generate 8 pairs of cards
        while generatedNumber.count < 8 {
            
            //generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumber.contains(randomNumber) == false {
                
                //create two new card object
                let cardOne = Card()
                let cardTwo = Card()
                
                //set their image name
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                //add them to array
                generateCards += [cardOne, cardTwo]
                
                //add this generated number to list
                generatedNumber.append(randomNumber)
                
                print("generating random number \(randomNumber)")
            }
        }
        
        //Randomize the cards within the array
        generateCards.shuffle()
        
        //Return the array
        return generateCards
    }
}
