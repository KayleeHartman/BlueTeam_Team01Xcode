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
    var player1: AVAudioPlayer?
    
    let DEBUG = true
    
    //create and instance of the model that will keep track of the cards, number of missed pairs, etc
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
    
    var timerCounter = 0
    
    //this even will fire anytime a card is tapped
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        if let image = sender.view as? UIImageView {
            if DEBUG {print(image.restorationIdentifier!)}
            
            for r in stride(from: 0, through: model.getNumCardsHeight()-1, by: 1 ) {
                for c in stride(from: 0, through: model.getNumCardsWidth()-1, by: 1) {
                    if image === cards[r][c].image {

                        let state = model.selectCard(xCoord: c, yCoord: r)
                        if DEBUG {print(state)}
                        
                        var temp: Bool = true //an unused variable that is toggled when default is called in the switch statement
                        switch state {
                        case Model.CardSelectReturnValue.matchFound:
                            //do some celebratory stuff
                            match()
                        case Model.CardSelectReturnValue.matchNotFound:
                            noMatch()
                            
                            //spawn a timer that will hide the two cards that the user selected after they are shown for a short amount of time
                            timerCounter = 0 //the timer function will fire before as soon as the timer interval has
                                             //elapsed so a counter keeps track of when we want the timer function to actually do things
                            let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
                            timer.fire()
                            if DEBUG {print("timer started")}
   
                        default: //the card was unselectable or an error was returned by selectCard
                           temp = !temp
                        }
                        updateShownCards() //update the images to show any cards that need to be shown
                    }
                }
            }
        
        }
    }
    
    @objc func timerFunc(timer: Timer) {
        
        if timerCounter > 1 {
            timerCounter = 0
            timer.invalidate()
        }
        else if timerCounter == 1 {
            if DEBUG {print("timer event executed")}
            model.resetMismatchedCards()
            updateShownCards()
            self.view.setNeedsDisplay()
        }
        timerCounter += 1
    }
    
    //this function checks the model to see which cards need to be shown/hidden and updates the UI
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
        self.view.setNeedsDisplay()
    }
    
    //this function is called when the user successfully matches a pair of cards
    func match() {
        let matches = model.getNumMatches()
        
        if matches == 6 {
            stopGameMusic()
            performSegue(withIdentifier: "win", sender: self)
        }
        else {
            playMarioCoin()
            playGameMusic()
        }
    }
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    @IBOutlet weak var heart6: UIImageView!
    
    //this function is called when the user does not successfully match a pair of cards
    func noMatch() {
        let test = model.getRemainingTries()
        if test == 0 {
            stopGameMusic()
            performSegue(withIdentifier: "loser", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loser" {
            let controller = segue.destination as! GameOverViewController
        }
        else if segue.identifier == "win" {
            let controller = segue.destination as! WinningViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    /*==========
     Various functions to play music at certain stages of the game
     ============*/
    
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
            
            player1 = try AVAudioPlayer(contentsOf: url)
            guard let player1 = player1 else { return }
            
            player1.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopGameMusic() {
        player?.stop()
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
