//
//  Settings.swift
//  Reels
//
//  Created by Nikita Molodorya on 19.10.2022.
//

import UIKit

class Settings: UIViewController {

    @IBOutlet weak var close: UIBarButtonItem!
    
    @IBOutlet weak var getPremium: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        getPremium.layer.cornerRadius = 15
        
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
