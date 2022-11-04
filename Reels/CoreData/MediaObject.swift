//
//  MediaObject.swift
//  Reels
//
//  Created by Nikita Molodorya on 04.11.2022.
//

import Foundation


// mediaObject instance can either be a video or ab image
struct MediaObject: Codable {
  let imageData: Data?
  let videoURL: URL?
  let caption: String? // UI so user enter text
  let id = UUID().uuidString
  let createDate = Date()
}
