//
//  CreateTemplate.swift
//  Reels
//
//  Created by Nikita Molodorya on 23.10.2022.
//

import UIKit
import AVFoundation
import AVKit
import CoreData

class CreateTemplate: UIViewController {
    
    @IBOutlet weak var trash: UIBarButtonItem!
    
    @IBOutlet weak var like: UIBarButtonItem!
    
    @IBOutlet weak var previewTemplate: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var addMedia: UIButton!
    @IBOutlet weak var addSound: UIButton!
    @IBOutlet weak var done: UIButton!
    
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    
    private var mediaObjects = [CDMediaObject]() {
        didSet { // property observer
            playRandomVideo(in: previewTemplate)
            collectionView.reloadData()
        }
    }
    
    
    // NSPredicate — разрешить фильтрацию или сортировку данных из выборок Core Data
    // NSFetchResultsController — аналогично слушателю Firebase — добавить автоматическую перезагрузку коллекции измененных данных
    private func fetchMediaObjects() {
        mediaObjects = CoreDataManager.shared.fetchMediaObjects()
        
    }
    
    
    private func playRandomVideo(in view: UIView) {
//        let videoDataObjects = mediaObjects.compactMap{$0.videoData}
//     
//        let url = videoDataObjects
//        let player = AVPlayer(url: url)
//        loopVideo(videoPlayer: player)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.videoGravity = .resizeAspectFill
//        view.layer.sublayers?.removeAll()
//        view.layer.masksToBounds = true
//        playerLayer.cornerRadius = 25
//        view.layer.addSublayer(playerLayer)
//        player.play()
//        
//        player.actionAtItemEnd = .advance
        
            

        
        
        
       
        
        
    }
    

        
        

    // рабочая версия
//    private func playRandomVideo(in view: UIView) {
//        let videoDataObjects = mediaObjects.compactMap {$0.videoData}
//
//        if let videoObject = videoDataObjects.randomElement(),
//           let videoURL = videoObject.convertToURL() {
//            let player = AVPlayer(url: videoURL)
//            loopVideo(videoPlayer: player)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = view.bounds
//            playerLayer.videoGravity = .resizeAspectFill
//            view.layer.sublayers?.removeAll()
//            view.layer.masksToBounds = true
//            playerLayer.cornerRadius = 25
//            view.layer.addSublayer(playerLayer)
//            player.play()
//        }
//    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewTemplate.layer.cornerRadius = 15
        addMedia.layer.cornerRadius = 15
        addSound.layer.cornerRadius = 15
        done.layer.cornerRadius = 15

        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchMediaObjects()
        playRandomVideo(in: previewTemplate)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    
    @IBAction func trashAction(_ sender: UIBarButtonItem) {
        AppDelegate().clearDatabase()
        loadView()
        collectionView.reloadData()
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
    
    
    @IBAction func addMediaAction(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    
    
    
   
     
}


extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath) as! CreateTemplateCell
        cell.layer.cornerRadius = 15
        
        let mediaObject = mediaObjects[indexPath.row]
        cell.mediaImageView.contentMode = .scaleAspectFill
        cell.configureCell(for: mediaObject)
        
        return cell
    }
}


 
// MARK: UICollection View Delegate Methods
extension CreateTemplate: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mediaOjbect = mediaObjects[indexPath.row]
    guard let videoURL = mediaOjbect.videoData?.convertToURL() else {
      return
    }
    let playerViewController = AVPlayerViewController()
    let player = AVPlayer(url: videoURL)
    playerViewController.player = player
      
    present(playerViewController, animated: true) {
      // play video automatically
      player.play()
    }
  }
    
}

extension CreateTemplate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
      return
    }
    
    switch mediaType { // "public.movie" , "public.image"
    case "public.image":
      if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
        let imageData = originalImage.jpegData(compressionQuality: 1.0){
        
        // add to Core Data
        let mediaObject = CoreDataManager.shared.createMediaObect(imageData, videoURL: nil)
        
        // add to collection view and reload data
        mediaObjects.append(mediaObject) // 0 => 1
      }
    case "public.movie":
      if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
        let image = mediaURL.videoPreviewThumnail(),
        let imageData = image.jpegData(compressionQuality: 1.0){
        print("mediaURL: \(mediaURL)")
        
        let mediaObject = CoreDataManager.shared.createMediaObect(imageData, videoURL: mediaURL)
        mediaObjects.append(mediaObject)
      }
    default:
      print("unsupported media type")
    }
    
    picker.dismiss(animated: true)
  }
    
}


