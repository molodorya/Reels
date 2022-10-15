//
//  ViewController.swift
//  Reels
//
//  Created by Nikita Molodorya on 12.10.2022.
//

import UIKit

class Main: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
      
    }


}


class TrendingsCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameVideo: UILabel!
    
    override class func awakeFromNib() {
        
    }
}


extension Main: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendings", for: indexPath) as! TrendingsCollectionCell
        
        cell.nameVideo.text = "Video №\(indexPath.row)"
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    
}

