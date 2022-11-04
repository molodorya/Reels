//
//  ShowVideoEditor.swift
//  Reels
//
//  Created by Nikita Molodorya on 26.10.2022.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos

class VideoMain: UIViewController {
    
    var isPlaying = true
    var isSliderEnd = true
    var playbackTimeCheckerTimer: Timer! = nil
    let playerObserver: Any? = nil
    
    let exportSession: AVAssetExportSession! = nil
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    static var asset: AVAsset!
    
    static var url:NSURL! = nil
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Int!
    
    var videoPlaybackPosition: CGFloat = 0.0
    var cache:NSCache<AnyObject, AnyObject>!
    var rangeSlider: RangeSlider! = nil
    
    @IBOutlet weak var layoutContainer: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var cropButton: UIButton!
    
    @IBOutlet weak var frameContainerView: UIView!
    @IBOutlet weak var imageFrameView: UIView!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startTimeText: UITextField!
    
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var endTimeText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectVideoUrl(UIButton())
        loadViews()
        // Выполните любую дополнительную настройку после загрузки представления, как правило, из пера.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Удаляем любые ресурсы, которые можно воссоздать.
    }
    
    //Загрузка представлений
    func loadViews() {
        //Просмотр всего макета
        layoutContainer.layer.borderWidth = 1.0
        layoutContainer.layer.borderColor = UIColor.white.cgColor
        
        selectButton.layer.cornerRadius = 5.0
        cropButton.layer.cornerRadius   = 5.0
        
        //Скрываем кнопки и вид при загрузке
        cropButton.isHidden         = true
        startView.isHidden          = true
        endView.isHidden            = true
        frameContainerView.isHidden = true
        
        //Стиль для startTime
        startTimeText.layer.cornerRadius = 5.0
        startTimeText.layer.borderWidth  = 1.0
        startTimeText.layer.borderColor  = UIColor.white.cgColor
        
        //Стиль для endTime
        endTimeText.layer.cornerRadius = 5.0
        endTimeText.layer.borderWidth  = 1.0
        endTimeText.layer.borderColor  = UIColor.white.cgColor
        
        imageFrameView.layer.cornerRadius = 5.0
        imageFrameView.layer.borderWidth  = 1.0
        imageFrameView.layer.borderColor  = UIColor.white.cgColor
        imageFrameView.layer.masksToBounds = true
        
        player = AVPlayer()
        
        
        //Выделение NsCahe для временного хранилища
        cache = NSCache()
        
       
    }
    
    //Действие для выбора видео
    @IBAction func selectVideoUrl(_ sender: Any) {
        //Выбор типа видео
        let myImagePickerController        = UIImagePickerController()
        myImagePickerController.sourceType = .photoLibrary
        myImagePickerController.mediaTypes = [(kUTTypeMovie) as String]
        myImagePickerController.delegate   = self
        myImagePickerController.isEditing  = false
        present(myImagePickerController, animated: true, completion: {  })
    }
    
    
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    //Действие для обрезки видео
    @IBAction func cropVideo(_ sender: Any) {
        let start = Float(startTimeText.text!)
        let end   = Float(endTimeText.text!)
        cropVideo(sourceURL1: VideoMain.url, startTime: start!, endTime: end!)
    }
    
}

//Подкласс VideoMainViewController
extension VideoMain: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    //Делегировать метод выбора изображения
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        VideoMain.url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? NSURL
        VideoMain.asset   = AVURLAsset.init(url: VideoMain.url as URL)
        
        thumbTime = VideoMain.asset.duration
        thumbtimeSeconds      = Int(CMTimeGetSeconds(thumbTime))
        
        viewAfterVideoIsPicked()
        
        let item:AVPlayerItem = AVPlayerItem(asset: VideoMain.asset)
        player                = AVPlayer(playerItem: item)
        playerLayer           = AVPlayerLayer(player: player)
        playerLayer.frame     = videoLayer.bounds
        
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        player.actionAtItemEnd   = AVPlayer.ActionAtItemEnd.none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnVideoLayer))
        videoLayer.addGestureRecognizer(tap)
        tapOnVideoLayer(tap: tap)
        
        videoLayer.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func viewAfterVideoIsPicked() {
        //Перемещение игрока, если он уже существует
        if(playerLayer != nil) {
            playerLayer.removeFromSuperlayer()
        }
        
        createImageFrames()
        
        //показать кнопки и просмотреть после выбора видео
        cropButton.isHidden         = false
        startView.isHidden          = false
        endView.isHidden            = false
        frameContainerView.isHidden = false
        
        
        isSliderEnd = true
        startTimeText.text! = "\(0.0)"
        endTimeText.text   = "\(thumbtimeSeconds!)"
        createRangeSlider()
    }
    
    //Нажмите действие в видеоплеере
    @objc func tapOnVideoLayer(tap: UITapGestureRecognizer) {
        if isPlaying
        {
            player.play()
        }
        else
        {
            player.pause()
        }
        isPlaying = !isPlaying
    }
    
    
    
    //MARK: CreatingFrameImages
    func createImageFrames() {
        //создание ассетов
        let assetImgGenerate : AVAssetImageGenerator    = AVAssetImageGenerator(asset: VideoMain.asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter    = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore   = CMTime.zero;
        
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        let thumbTime: CMTime = VideoMain.asset.duration
        let thumbtimeSeconds  = Int(CMTimeGetSeconds(thumbTime))
        let maxLength         = "\(thumbtimeSeconds)" as NSString
        
        let thumbAvg  = thumbtimeSeconds/6
        var startTime = 1
        var startXPosition:CGFloat = 0.0
        
        // цикл на 6 кадров
        for _ in 0...5 {
            
            let imageButton = UIButton()
            let xPositionForEach = CGFloat(imageFrameView.frame.width)/6
            imageButton.frame = CGRect(x: CGFloat(startXPosition), y: CGFloat(0), width: xPositionForEach, height: CGFloat(imageFrameView.frame.height))
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: Int32(maxLength.length))
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                imageButton.setImage(image, for: .normal)
            }
            catch
                _ as NSError
            {
                print("Генерация образа не удалась с ошибкой (error)")
            }
            
            startXPosition = startXPosition + xPositionForEach
            startTime = startTime + thumbAvg
            imageButton.isUserInteractionEnabled = false
            imageFrameView.addSubview(imageButton)
        }
        
    }
    
    //Создаем ползунок диапазона
    func createRangeSlider() {
        //Удаляем ползунок, если он уже есть
        let subViews = frameContainerView.subviews
        for subview in subViews{
            if subview.tag == 1000 {
                subview.removeFromSuperview()
            }
        }
        
        rangeSlider = RangeSlider(frame: frameContainerView.bounds)
        frameContainerView.addSubview(rangeSlider)
        rangeSlider.tag = 1000
        
        //Действие ползунка диапазона
        rangeSlider.addTarget(self, action: #selector(VideoMain.rangeSliderValueChanged(_:)), for: .valueChanged)
        
        let time = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangeSlider.trackHighlightTintColor = UIColor.clear
            self.rangeSlider.curvaceousness = 1.0
        }
        
    }
    
    //MARK: rangeSlider Delegate
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        player.pause()
        
        if(isSliderEnd == true) {
            rangeSlider.minimumValue = 0.0
            rangeSlider.maximumValue = Double(thumbtimeSeconds)
            
            rangeSlider.upperValue = Double(thumbtimeSeconds)
            isSliderEnd = !isSliderEnd
            
        }
        
        startTimeText.text = "\(rangeSlider.lowerValue)"
        endTimeText.text   = "\(rangeSlider.upperValue)"
        
        //print(rangeSlider.lowerLayerSelected)
        if(rangeSlider.lowerLayerSelected) {
            seekVideo(toPos: CGFloat(rangeSlider.lowerValue))
            
        } else {
            seekVideo(toPos: CGFloat(rangeSlider.upperValue))
            
        }
        
        //print(startTime)
    }
    
    
    //MARK: TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength     = 3
        let currentString = startTimeText.text! as NSString
        let newString     = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //Поиск видео при слайде
    func seekVideo(toPos pos: CGFloat) {
        videoPlaybackPosition = pos
        let time: CMTime = CMTimeMakeWithSeconds(Float64(videoPlaybackPosition), preferredTimescale: player.currentTime().timescale)
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        if(pos == CGFloat(thumbtimeSeconds)) {
            player.pause()
        }
    }
    
    //Функция обрезки видео
    func cropVideo(sourceURL1: NSURL, startTime:Float, endTime:Float) {
        let manager                 = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {return}
        
        guard let mediaType = "mp4" as? String else {return}
        guard (sourceURL1 as? NSURL) != nil else {return}
        
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            let length = Float(VideoMain.asset.duration.value) / Float(VideoMain.asset.duration.timescale)
            //print("video length: \(length) seconds")
            
            let start = startTime
            let end = endTime
            //print(documentDirectory)
            var outputURL = documentDirectory.appendingPathComponent("output")
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                //let name = hostent.newName()
                outputURL = outputURL.appendingPathComponent("Reels.mp4")
            } catch let error {
                print(error)
            }
            
            //удаляем существующий файл
            _ = try? manager.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(asset: VideoMain.asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("Добавление в библиотеку отключено \(outputURL)")
                    self.saveToCameraRoll(URL: outputURL as NSURL?)
                    
                  
                    
                   
                case .failed:
                    print("failed \(String(describing: exportSession.error))")
                    
                case .cancelled:
                    print("cancelled \(String(describing: exportSession.error))")
                    
                default: break
                }}}}
    
    // Сохранить видео в библиотеке фотографий
    func saveToCameraRoll(URL: NSURL!) {
        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL as URL)
        }) { saved, error in
            if saved {
                
                DispatchQueue.main.asyncAfter(deadline: .now())  {
                  
                   
                    self.dismiss(animated: true)
                    
                }
            }}}
    
}

