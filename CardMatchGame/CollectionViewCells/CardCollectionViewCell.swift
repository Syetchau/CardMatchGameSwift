//
//  CardCollectionViewCell.swift
//  CardMatchGame
//
//  Created by LiewSyetChau on 11/12/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(card: Card) {
        
        //keep track of the card this cell represent
        self.card = card
        
        //set frontImageView to image that represent the card
        frontImageView.image = UIImage(named: card.imageName)
        
        //reset the state of the cell by checking the flipped status of the card and then showing front or back imageView accordingly
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        //reset the state of the cell by checking flipping status of card
        if card.isFlipped == true {
            //show the front image
            flipUp(speed: 0)
        } else {
            //show the back image
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        //flip up animation
        UIView.transition(
            from: backImageView,
            to: frontImageView,
            duration: speed,
            options: [.showHideTransitionViews,.transitionFlipFromLeft],
            completion: nil
        )
        
        //set the status of card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        //add handler delayed something, similar to android
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + delay) {
                //flip down animation
                UIView.transition(
                    from: self.frontImageView,
                    to: self.backImageView,
                    duration: speed,
                    options: [.showHideTransitionViews,.transitionFlipFromLeft],
                    completion: nil
                )
            }
        //set the status of card
        card?.isFlipped = false
    }
    
    func remove() {
        //make the image view invisible
        backImageView.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0.5,
            options: .curveEaseOut,
            animations:{
                self.frontImageView.alpha = 0
            },
            completion: nil
        )
    }
}
