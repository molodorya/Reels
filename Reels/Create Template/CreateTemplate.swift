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
     
    
    
//    private func playRandomVideo(in view: UIView) {
//
//        for video in mediaObjects.compactMap({$0.videoData}) {
//            let a = video.convertToURL()?.relativeString
//
//
//            guard let url = Bundle.main.url(forResource: a, withExtension: ".mp4") else {
//                fatalError("Could not load \(String(describing: a)).mp3")
//            }
//
//            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = view.bounds
//            playerLayer.videoGravity = .resizeAspectFill
//            view.layer.sublayers?.removeAll()
//            view.layer.masksToBounds = true
//            playerLayer.cornerRadius = 25
//            view.layer.addSublayer(playerLayer)
//            player.play()
//        }
//
//
//    }
    
    
    
    
    
    
    //     рабочая версия
    
    
    
    private func playRandomVideo(in view: UIView) {
        let videoDataObjects = mediaObjects.compactMap {$0.videoData}.reversed()
    
         
        
//        let videoURL = video.convertToURL()
//        let player = AVQueuePlayer(items: [AVPlayerItem])
//
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.videoGravity = .resizeAspectFill
//        view.layer.sublayers?.removeAll()
//        view.layer.masksToBounds = true
//        playerLayer.cornerRadius = 25
//        view.layer.addSublayer(playerLayer)
//        player.play()
        
        
        videoDataObjects.forEach { video in

            let videoURL = video.convertToURL()
            let player = AVQueuePlayer(url: videoURL!)

            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.sublayers?.removeAll()
            view.layer.masksToBounds = true
            playerLayer.cornerRadius = 25
            view.layer.addSublayer(playerLayer)
            player.play()

        }
        
        
    }
    
        
    /*
     
     videoDataObjects.forEach { video in
        
         let videoURL = videoDataObjects.convertToURL()
         let player = AVQueuePlayer(url: videoURL!)
         let playerLayer = AVPlayerLayer(player: player)
         playerLayer.frame = view.bounds
         playerLayer.videoGravity = .resizeAspectFill
         view.layer.sublayers?.removeAll()
         view.layer.masksToBounds = true
         playerLayer.cornerRadius = 25
         view.layer.addSublayer(playerLayer)
         player.play()
     }
     
     
     for video in videoDataObjects {
         let videoURL = video.convertToURL()
        
         let player = AVQueuePlayer(url: videoURL!)
         let playerLayer = AVPlayerLayer(player: player)
         
         playerLayer.frame = view.bounds
         playerLayer.videoGravity = .resizeAspectFill
         
         view.layer.sublayers?.removeAll()
         view.layer.masksToBounds = true
         playerLayer.cornerRadius = 25
         
         view.layer.addSublayer(playerLayer)
         
         player.play()
     }
     */


    
    
   
    
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
    
    func merge(arrayVideos: [AVAsset], completion:@escaping (URL?, Error?) -> ()) {
        print(123)
      let mainComposition = AVMutableComposition()
      let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
      compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)

      let soundtrackTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

        var insertTime = CMTime.zero

      for videoAsset in arrayVideos {
        try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
        try! soundtrackTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio)[0], at: insertTime)

        insertTime = CMTimeAdd(insertTime, videoAsset.duration)
      }

      let outputFileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "merge.mp4")

      let fileManager = FileManager()
      try? fileManager.removeItem(at: outputFileURL)

      let exporter = AVAssetExportSession(asset: mainComposition, presetName: AVAssetExportPresetHighestQuality)

      exporter?.outputURL = outputFileURL
      exporter?.outputFileType = AVFileType.mp4
      exporter?.shouldOptimizeForNetworkUse = true

      exporter?.exportAsynchronously {
        if let url = exporter?.outputURL{
            completion(url, nil)
        }
        if let error = exporter?.error {
            completion(nil, error)
        }
      }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let mediaURL = VideoMain.urlsVideoChange,
           let image = mediaURL.videoPreviewThumnail(),
           let imageData = image.jpegData(compressionQuality: 1.0) {
            
            let mediaObject = CoreDataManager.shared.createMediaObect(imageData, videoURL: mediaURL)
            mediaObjects.append(mediaObject)
            
            
            print(mediaObject.videoData?.getAVAsset())
            
//            merge(arrayVideos: AVURLAsset.init(url: mediaURL as URL)) { url, error in
//
//            }
            
          
        }
        
        
        
        
        
        
       
        
        
        
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
//        present(imagePickerController, animated: true)
       
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
        
     
//        let mediaOjbect = mediaObjects[indexPath.row]
//        var videoURL = mediaOjbect.videoData?.getAVAsset()
//        var array = [videoURL!]
//
//        array.append(videoURL!)
//
//        merge(arrayVideos: array, completion: {_,_ in
//
//        })
       
        
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
        let imageData = image.jpegData(compressionQuality: 1.0) {
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


extension Data {
    func getAVAsset() -> AVAsset {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mov"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        let asset = AVAsset(url: fullURL!)
        return asset
    }
}


class TemporaryMediaFile {
    var url: URL?

    init(withData: Data) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).mov"
        let url = directory.appendingPathComponent(fileName)
        do {
            try withData.write(to: url)
            self.url = url
        } catch {
            print("Error creating temporary file: \(error)")
        }
    }

    public var avAsset: AVAsset? {
        if let url = self.url {
            return AVAsset(url: url)
        }

        return nil
    }

    public func deleteFile() {
        if let url = self.url {
            do {
                try FileManager.default.removeItem(at: url)
                self.url = nil
            } catch {
                print("Error deleting temporary file: \(error)")
            }
        }
    }

    deinit {
        self.deleteFile()
    }
}
 
   
