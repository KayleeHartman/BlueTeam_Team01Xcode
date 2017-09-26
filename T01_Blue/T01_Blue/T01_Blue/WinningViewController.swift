//
//  WinningViewController.swift
//  T01_Blue
//
//  Created by HARTMAN KAYLEE N on 9/26/17.
//  Copyright © 2017 Blue Team. All rights reserved.
//

import UIKit
import AVFoundation

class WinningViewController: UIViewController {
    var player: AVAudioPlayer?
    var player1: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        playVictorySong()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func replay(_ sender: UIButton) {
        playHereWeGo()
    }
    
    func playVictorySong() {
        guard let url = Bundle.main.url(forResource: "VictorySong", withExtension: "mp3") else { return }
        
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
    
    func playHereWeGo() {
        guard let url = Bundle.main.url(forResource: "HereWeGo", withExtension: "mp3") else { return }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
