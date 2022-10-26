//
//  TestConstraints.swift
//  Reels
//
//  Created by Nikita Molodorya on 24.10.2022.
//

import UIKit

class TestConstraints: UIViewController {
    
    let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(customView)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        customView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        customView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
      
    }
    


}
