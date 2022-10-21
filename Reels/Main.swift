//
//  ViewController.swift
//  Reels
//
//  Created by Nikita Molodorya on 12.10.2022.
//

import UIKit
import AVFoundation

class Main: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
     
            
        
        collectionView.delegate = self
        collectionView.dataSource = self
      
    }


}


class TrendingsCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var displayCell: UIView!
    @IBOutlet weak var nameVideo: UILabel!
    
    override class func awakeFromNib() {
        
    }
}


extension Main: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendings", for: indexPath) as! TrendingsCollectionCell
        
        cell.nameVideo.text = "Video №\(indexPath.row)"
        cell.layer.cornerRadius = 25
        
       // Повторяет видео после того как оно закончилось
        func loopVideo(videoPlayer: AVPlayer) {
          NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
          }
        }
        
        switch indexPath.row {
            
            case 0:
            let videoURL = URL(string: "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2520.mp4?_=3")
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = cell.displayCell.bounds
            cell.displayCell.layer.addSublayer(playerLayer)
            player.volume = 0
          
            loopVideo(videoPlayer: player)
            player.play()
            
            case 1:
            let videoURL = URL(string: "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2856.mp4?_=4")
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)

            playerLayer.frame = cell.displayCell.bounds
            cell.displayCell.layer.addSublayer(playerLayer)
            player.volume = 0
            
            loopVideo(videoPlayer: player)
            player.play()
        default:
            break
        }
       
        
        
      
        
        return cell
    }
    
    
}


