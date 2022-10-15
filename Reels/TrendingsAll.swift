//
//  TrendingsAll.swift
//  Reels
//
//  Created by Nikita Molodorya on 14.10.2022.
//

import UIKit

class TrendingsAll: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}



 


extension TrendingsAll: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingsAll", for: indexPath)
        
     
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    
    
}
