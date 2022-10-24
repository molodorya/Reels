//
//  TrendingsAll.swift
//  Reels
//
//  Created by Nikita Molodorya on 14.10.2022.
//

import UIKit
import AVFoundation

class TrendingsAll: UIViewController {
    
    let urls = ["https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2520.mp4?_=3", "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2856.mp4?_=4"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All trends"
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}



 


extension TrendingsAll: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingsAll", for: indexPath) as! TrendingsAllCell
        cell.layer.cornerRadius = 25
        
        
        let videoURL = URL(string: urls[indexPath.row])
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = cell.displayCell.bounds
        cell.displayCell.layer.addSublayer(playerLayer)
        player.volume = 0
      
        loopVideo(videoPlayer: player)
        player.play()
        
        return cell
    }
    
    
    
}
