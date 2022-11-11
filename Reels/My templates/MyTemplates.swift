//
//  MyTemplates.swift
//  Reels
//
//  Created by Nikita Molodorya on 24.10.2022.
//

import UIKit
import AVFoundation

class MyTemplates: UIViewController {
    
    let urls = Main.likeTemplates.first
    
    
    // Нужно брать из сохраненных данных (а еще лучше загружать в CoreData любимые видео)

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My templates"

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    


}

// Возможно cell.contentView.cornerRadius исправит проблему

extension MyTemplates: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
//        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myTemplateCell", for: indexPath) as! MyTemplatesCell
        cell.layer.cornerRadius = 25
        
//        let videoURL = URL(string: urls[indexPath.row])
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspectFill
//        playerLayer.frame = cell.displayCell.bounds
//        cell.displayCell.layer.addSublayer(playerLayer)
//        player.volume = 0
//
//        loopVideo(videoPlayer: player)
//        player.play()
       
        
        return cell
    }
    
    
}
