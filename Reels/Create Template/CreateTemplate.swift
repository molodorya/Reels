//
//  CreateTemplate.swift
//  Reels
//
//  Created by Nikita Molodorya on 23.10.2022.
//

import UIKit
import AVFoundation

class CreateTemplate: UIViewController {
    
    
   
  
    @IBOutlet weak var trash: UIBarButtonItem!
    
    @IBOutlet weak var like: UIBarButtonItem!
    
    @IBOutlet weak var previewTemplate: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewTemplate.layer.cornerRadius = 25
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { Timer in
//            self.collectionView.reloadData()
//            print(123234)
//        }
       
    }
    
    
    @IBAction func trashAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "keyVideoUrl")
        collectionView.reloadData()
        print("trash")
    }
    
    var isVideoLike = false
    @IBAction func likeAction(_ sender: UIBarButtonItem) {
        self.collectionView.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        if isVideoLike == true {
            like.image = UIImage.init(systemName: "heart")
            isVideoLike = false
        } else {
            like.image = UIImage.init(systemName: "heart.fill")
            isVideoLike = true
        }
    }
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
      
         let activity = UIActivityViewController(
           activityItems: ["Название видео..."],
           applicationActivities: nil
         )
         activity.popoverPresentationController?.barButtonItem = sender

         
         present(activity, animated: true, completion: nil)
    }
    
  
    var counting = 0
}


extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        counting = indexPath.row
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoMain") as! VideoMain
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath) as! CreateTemplateCell
        cell.layer.cornerRadius = 25
        
        /*
         Решение проблемы с индексом и добавлением разных видео в ячейки скорее всего решается через CoreData то есть Добавление видео в память CoreData -
         */
        
        
        
        if let url = UserDefaults.standard.url(forKey: "keyVideoUrl") {
         
            let player = AVPlayer(playerItem: AVPlayerItem(url: url))
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = cell.displayCell.bounds
            cell.displayCell.layer.addSublayer(playerLayer)
            player.volume = 0
            
            loopVideo(videoPlayer: player)
            player.play()
        }
        
     
        
//        if VideoMain.asset != nil {
//            switch indexPath.row {
//            case 0:
//                let player = AVPlayer(playerItem: AVPlayerItem(url: VideoMain.url as URL))
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.videoGravity = .resizeAspectFill
//                playerLayer.frame = cell.displayCell.bounds
//                cell.displayCell.layer.addSublayer(playerLayer)
//                player.volume = 0
//
//                loopVideo(videoPlayer: player)
//                player.play()
//
//            case 1:
//                break
//
//            default:
//                break
//            }
//        }
        
       
          
           
           
 

       
       
 
        return cell
        
      
    }
    
    
}


 
