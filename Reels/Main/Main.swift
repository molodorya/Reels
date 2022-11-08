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
    
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    
   let urls = ["https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2520.mp4?_=3", "https://www.iphones.ru/wp-content/uploads/2022/10/IMG_2856.mp4?_=4"]
    
    
    // Пользоваться делегатами надо, а не статиком
   static var selectedUrl = ""
   

    override func viewDidLoad() {
        super.viewDidLoad()
     
        collectionViewOne.delegate = self
        collectionViewOne.dataSource = self
        
        collectionViewTwo.delegate = self
        collectionViewTwo.dataSource = self
      
    }


}





extension Main: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case collectionViewOne:
            return urls.count
        case collectionViewTwo:
            return urls.count
        default:
            break
        }
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Main.selectedUrl = urls[indexPath.row]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       // А нужно ли использовать асинхронный поток?
        
        switch collectionView {
        case collectionViewOne:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendings", for: indexPath) as! TrendingsCollectionCell
            
            DispatchQueue.main.async {
                let videoURL = URL(string: self.urls[indexPath.row])
                let player = AVPlayer(url: videoURL!)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.frame = cell.displayCell.bounds
                cell.displayCell.layer.addSublayer(playerLayer)
                player.volume = 0
              
                loopVideo(videoPlayer: player)
                player.play()
                print(1)
            }
            
            cell.layer.cornerRadius = 25
            cell.displayCell.backgroundColor = .systemGray6
            
            return cell
            
        case collectionViewTwo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "motivation", for: indexPath) as! MotivationCollectionCell
            cell.layer.cornerRadius = 25
            cell.backgroundColor = .systemGray6
            
            DispatchQueue.main.async {
                let videoURL = URL(string: self.urls[indexPath.row])
                let player = AVPlayer(url: videoURL!)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.frame = cell.displayCell.bounds
                cell.displayCell.layer.addSublayer(playerLayer)
                player.volume = 0
              
                loopVideo(videoPlayer: player)
                player.play()
                print(2)
            }
            
            return cell
            
        default:
            break
        }
        
        
        return UICollectionViewCell()

    }
    
    
}



