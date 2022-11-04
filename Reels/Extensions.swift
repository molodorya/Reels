//
//  Extensions.swift
//  Reels
//
//  Created by Nikita Molodorya on 22.10.2022.
//

import UIKit
import AVFoundation
import Foundation
import CoreData

// MARK: - Extensions



// MARK: - Open function

// Повторяет видео после того как оно закончилось
 public func loopVideo(videoPlayer: AVPlayer) {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
      videoPlayer.seek(to: .zero)
      videoPlayer.play()
    }
  }




extension Data {
  
  // use case example:
  // let url = mediaObject.videoData.convertToURL()
  // let url = mediaObject.self.convertToURL()
  public func convertToURL() -> URL? {
    
    // create a temporary URL
    // NSTemporaryDirectory() - stores temporary files, those files get deleted as needed by the operating system
    // documents directory is for permanent storage
    // caches directory is temporary storage
    
    // in Core Data the video is saved as Data
    // when playing back the video we need to have a URL pointing to the video location on disk
    // AVPlayer need a URL pointing to a location on disk
    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
    do {
      try self.write(to: tempURL, options: [.atomic])
      return tempURL
    } catch {
      print("failed to write (save) video data to temporary file with error: \(error)")
    }
    return nil
  }
}


extension URL {
  
  public func videoPreviewThumnail() -> UIImage? {
    // create an  AVAsset instance
    // e.g. let image = mediaObject.videoURL.videoPreviewThumnail()
    let asset = AVAsset(url: self) // self is the URL instance
    
    // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
    let assetGenerator = AVAssetImageGenerator(asset: asset)
    
    // we wan to maintain the aspect ratio of the video
    assetGenerator.appliesPreferredTrackTransform = true
    
    // create a time stamp of needed location in the video
    // we will use a CMTime to generate the given time stamp
    // CMTime is part of Core Media
    let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
    // retrive the first second of the video
    
    var image: UIImage?
    
    do {
      let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
      image = UIImage(cgImage: cgImage)
      
      // UIView
      // Layer
      
      // lower level API don't know about UIKit, AVKit \
      // change the color of a UIView border
      // e.g someView.layer.borderColor = UIColor.green.cgColor
    } catch {
      print("failed to generate image: \(error)")
    }
    return image
  }
}



