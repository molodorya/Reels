//
//  CreateTemplate.swift
//  Reels
//
//  Created by Nikita Molodorya on 23.10.2022.
//

import UIKit

class CreateTemplate: UIViewController {
    
    @IBOutlet weak var like: UIBarButtonItem!
    
    @IBOutlet weak var previewTemplate: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewTemplate.layer.cornerRadius = 25
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
       
    }
    
    var isVideoLike = false
    @IBAction func likeAction(_ sender: UIBarButtonItem) {
        
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
    
    
    
}


extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath)
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    
}


 
