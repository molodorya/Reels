//
//  CreateTemplate.swift
//  Reels
//
//  Created by Nikita Molodorya on 16.10.2022.
//
import Photos
import UIKit

class CreateTemplate: UIViewController {
    
    
    // MARK: - Навигационное меню
    @IBOutlet weak var close: UIBarButtonItem!
    @IBOutlet weak var like: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    
    // MARK: - Интерфейс
    @IBOutlet weak var previewTemplate: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addMedia: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        
        previewTemplate.layer.cornerRadius = 25
        addMedia.layer.cornerRadius = 25
        two.layer.cornerRadius = 25
        three.layer.cornerRadius = 25

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
   
    
    
    // MARK: - Навигационное меню
    
    var isHaveVideo = true
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Вы действительно хотите выйти?", message: "У вас есть несохраненное видео", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in self.dismiss(animated: true) }))
        self.present(alert, animated: true)
    }
    
    
    // Добавить вибрацию, отклик
    var isVideoLike = false
    @IBAction func likeAction(_ sender: UIBarButtonItem) {
        
        if isVideoLike == true {
            like.image = UIImage.init(systemName: "heart")
            isVideoLike = false
        } else {
            like.image = UIImage.init(systemName: "heart.fill")
            isVideoLike = true
        }
        
    }
    
    
     
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
       
    }
    
   
     
    

}

// MARK: - Настройка CollectionView
extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath) as! TemplateCell
        
        cell.layer.cornerRadius = 25
        
        cell.secounds.text = "\(indexPath.row).6"
        
        return cell
    }
  
}


 
