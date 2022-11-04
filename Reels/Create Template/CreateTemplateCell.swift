//
//  CreateTemplateCell.swift
//  Reels
//
//  Created by Nikita Molodorya on 29.10.2022.
//

import UIKit

class CreateTemplateCell: UICollectionViewCell {

    @IBOutlet weak var displayCell: UIView!
   
    @IBOutlet weak var mediaImageView: UIImageView!
    
    override class func awakeFromNib() {
       
    }
    
 
    public func configureCell(for mediaObject: CDMediaObject) {
      if let imageData = mediaObject.imageData {
        // converts a Data object to a UIImage
        mediaImageView.image = UIImage(data: imageData)
      }
          
      // create a video preview thumbnail
      if let videoURL = mediaObject.videoData?.convertToURL() {
        let image = videoURL.videoPreviewThumnail() ?? UIImage(systemName: "heart")
        mediaImageView.image = image
      }
    }
    
 
}
