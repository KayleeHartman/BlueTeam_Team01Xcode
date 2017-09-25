//
//  GameViewController.swift
//  T01_Blue
//
//  Created by Haines D Todd on 9/22/17.
//  Copyright © 2017 Blue Team. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    let DEBUG = true
    
    let model = Model.init(numCardsWidth: 3, numCardsHeight: 4, numTries: 6)
    
    //row 0 of cards
    @IBOutlet weak var card_0_0: UIImageView!
    @IBOutlet weak var card_1_0: UIImageView!
    @IBOutlet weak var card_2_0: UIImageView!
    
    //row 1 of cards
    @IBOutlet weak var card_0_1: UIImageView!
    @IBOutlet weak var card_1_1: UIImageView!
    @IBOutlet weak var card_2_1: UIImageView!
    
    //row 2 of cards
    @IBOutlet weak var card_0_2: UIImageView!
    @IBOutlet weak var card_1_2: UIImageView!
    @IBOutlet weak var card_2_2: UIImageView!
    
    //row 3 of cards
    @IBOutlet weak var card_0_3: UIImageView!
    @IBOutlet weak var card_1_3: UIImageView!
    @IBOutlet weak var card_2_3: UIImageView!
    
    @IBOutlet var cardTapGestureRecognizer: UITapGestureRecognizer!
    
    //an array of all the cards used
    var cards: [[(id: String, image: UIImageView)]] = []
    
    var health: [[(id: String, image: UIImageView)]] = []
    
    //this even will fire anytime a card is tapped
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        if let image = sender.view as? UIImageView {
            if DEBUG {print(image.restorationIdentifier!)}
            
            for r in stride(from: 0, through: model.getNumCardsHeight()-1, by: 1 ) {
                for c in stride(from: 0, through: model.getNumCardsWidth()-1, by: 1) {
                    if image === cards[r][c].image {

                        let state = model.selectCard(xCoord: c, yCoord: r)
                        if DEBUG {print(state)}
                        
                        var temp = true //a temporary variable to satisfy the compiler, it does nothing
                        switch state {
                        case Model.CardSelectReturnValue.firstCardSelected:
                            //do some stuff play sound, call an animation do whatever
                            temp = !temp
                        
                        case Model.CardSelectReturnValue.firstCardDeselected:
                            //do some more stuff
                            temp = !temp
                        
                        case Model.CardSelectReturnValue.matchFound:
                            //do some celebratory stuff
                            temp = !temp
                            
                           match()
                        case Model.CardSelectReturnValue.matchNotFound:
                            //update the health bar images to remove one, check model.getRemainingTries or model.isDead to check the models state
                            temp = !temp
                            
                            noMatch()
                        default: //the card was unselectable or an error was returned by selectCard
                            temp = !temp
                           
                        }
                        updateShownCards() //update the images to show any cards that need to be shown
                    }
                    
                    
                }
            }
        
        }
    }
    
    func updateShownCards() {
        let map = model.getCardMap()
        
        for r in stride(from: 0, through: model.getNumCardsHeight()-1, by: 1 ) {
            for c in stride(from: 0, through: model.getNumCardsWidth()-1, by: 1) {
              switch map[r][c] {
                case 0: cards[r][c].image.image = UIImage(named: "CardBack.jpg")
                case 1: cards[r][c].image.image = UIImage(named: "CoinCard.jpg")
                case 2: cards[r][c].image.image = UIImage(named: "FeatherCard.jpg")
                case 3: cards[r][c].image.image = UIImage(named: "FireFlowCard.jpg")
                case 4: cards[r][c].image.image = UIImage(named: "MushroomCard.jpg")
                case 5: cards[r][c].image.image = UIImage(named: "StarCard.jpg")
                case 6: cards[r][c].image.image = UIImage(named: "YoshiEggCard.jpg")
                default: cards[r][c].image.image = UIImage(named: "CardBack.jpg")
              }
            }
        }
    }
    
    func match() {
        let test = model.getNumMatches()
        
        if test == 6 {
            // segue
        }
        else {
            playMarioCoin()
        }
    }
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    @IBOutlet weak var heart6: UIImageView!
    
    func noMatch() {
        let test = model.getRemainingTries()
        if test == 0 {
            //segue
        }
        else {
            switch test {
            case 1:
                heart2.isHidden = true
            case 2:
                heart3.isHidden = true
            case 3:
                heart4.isHidden = true
            case 4:
                heart5.isHidden = true
            case 5:
                heart6.isHidden = true
            default:
                heart1.isHidden = false
                heart2.isHidden = false
                heart3.isHidden = false
                heart4.isHidden = false
                heart5.isHidden = false
                heart6.isHidden = false
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playGameMusic()
        
        cards.append([])
        cards[0].append((id: card_0_0.restorationIdentifier!, image: card_0_0))
        cards[0].append((id: card_1_0.restorationIdentifier!, image: card_1_0))
        cards[0].append((id: card_2_0.restorationIdentifier!, image: card_2_0))
        
        cards.append([])
        cards[1].append((id: card_0_1.restorationIdentifier!, image: card_0_1))
        cards[1].append((id: card_1_1.restorationIdentifier!, image: card_1_1))
        cards[1].append((id: card_2_1.restorationIdentifier!, image: card_2_1))
    
        cards.append([])
        cards[2].append((id: card_0_2.restorationIdentifier!, image: card_0_2))
        cards[2].append((id: card_1_2.restorationIdentifier!, image: card_1_2))
        cards[2].append((id: card_2_2.restorationIdentifier!, image: card_2_2))
        
        cards.append([])
        cards[3].append((id: card_0_3.restorationIdentifier!, image: card_0_3))
        cards[3].append((id: card_1_3.restorationIdentifier!, image: card_1_3))
        cards[3].append((id: card_2_3.restorationIdentifier!, image: card_2_3))
        
        //add a tap gesture recognizer to all UIImageViews representing the cards
        for cardArray in cards {
            for cardTuple in cardArray {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
                cardTuple.image.isUserInteractionEnabled = true
                cardTuple.image.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playGameMusic() {
        guard let url = Bundle.main.url(forResource: "GamePlaySong", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMarioCoin() {
        guard let url = Bundle.main.url(forResource: "MarioCoin", withExtension: "WAV") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
