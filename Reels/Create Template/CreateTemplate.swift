//
//  CreateTemplate.swift
//  Reels
//
//  Created by Nikita Molodorya on 16.10.2022.
//
import Photos
import UIKit

class CreateTemplate: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    // MARK: - Навигационное меню
    @IBOutlet weak var close: UIBarButtonItem!
    @IBOutlet weak var like: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    
    // MARK: - Интерфейс
    @IBOutlet weak var previewTemplate: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addMedia: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         downloadVideoAndShow()
        
        previewTemplate.layer.cornerRadius = 25
        addMedia.layer.cornerRadius = 25
        two.layer.cornerRadius = 25
        three.layer.cornerRadius = 25

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func downloadVideoAndShow() {
        let videoURL = URL(string: Main.selectedUrl)
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = previewTemplate.bounds
        playerLayer.cornerRadius = 25
        previewTemplate.layer.addSublayer(playerLayer)
//        player.volume = 1
       
        
        loopVideo(videoPlayer: player)
        player.play()
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
    
    
    
    @IBAction func addMediaAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.previewImage.image = image
        }
    }
    
    
   
     
    

}

// MARK: - Настройка CollectionView
extension CreateTemplate: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               var imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary;
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
           }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
           
           
            print(image)
            previewImage.image = image
            
            
            dismiss(animated:true, completion: nil)
        }
         
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createTemplate", for: indexPath) as! TemplateCell
        
        cell.layer.cornerRadius = 25
        
        cell.secounds.text = "\(indexPath.row).6"
        
        return cell
    }
  
}


 


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}


extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
