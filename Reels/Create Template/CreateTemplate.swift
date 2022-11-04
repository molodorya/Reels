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
        
 
      
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if VideoMain.asset != nil {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: VideoMain.asset))
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = previewTemplate.bounds
            playerLayer.cornerRadius = 25
            previewTemplate.layer.addSublayer(playerLayer)
            //        player.volume = 1
            
            
            loopVideo(videoPlayer: player)
            player.play()
            collectionView.reloadData()
        }
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
    
    
    static var urls = [""]
     
}


extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoMain") as! VideoMain
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath) as! CreateTemplateCell
        cell.layer.cornerRadius = 25
        
      
        
        
        
        if VideoMain.asset != nil {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: VideoMain.asset))
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = cell.displayCell.bounds
            cell.displayCell.layer.addSublayer(playerLayer)
            player.volume = 0
            
            loopVideo(videoPlayer: player)
            player.play()
            
            
        }
        
        
        
        
        
        return cell
        
      
    }
    
    
}


 
