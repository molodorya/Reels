//
//  Extensions.swift
//  Reels
//
//  Created by Nikita Molodorya on 22.10.2022.
//

import UIKit
import AVFoundation
import Foundation


// MARK: - Extensions



// MARK: - Open function

// Повторяет видео после того как оно закончилось
 public func loopVideo(videoPlayer: AVPlayer) {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
      videoPlayer.seek(to: .zero)
      videoPlayer.play()
    }
  }
