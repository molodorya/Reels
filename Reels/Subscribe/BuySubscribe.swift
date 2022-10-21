//
//  BuySubscribe.swift
//  Reels
//
//  Created by Nikita Molodorya on 21.10.2022.
//

import UIKit
import AVFoundation

class BuySubscribe: UIViewController {
    
    
    @IBOutlet weak var videoView: UIView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoURL = URL(string: "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2520.mp4?_=3")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
  

}
