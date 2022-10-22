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
    
   let urls = ["https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2520.mp4?_=3", "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2856.mp4?_=4"]
    
    
    // Пользоваться делегатами надо, а не статиком
   static var selectedUrl = ""
   

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
        return urls.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Main.selectedUrl = urls[indexPath.row]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendings", for: indexPath) as! TrendingsCollectionCell
        
        cell.nameVideo.text = "Video №\(indexPath.row)"
        cell.layer.cornerRadius = 25
 
        cell.displayCell.backgroundColor = .systemGray6
        
      
        
        
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



