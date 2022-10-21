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
    @IBOutlet weak var shareApp: UIView!
    @IBOutlet weak var reviewApp: UIView!
    @IBOutlet weak var contactUs: UIView!
    @IBOutlet weak var help: UIView!
    @IBOutlet weak var cache: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        getPremium.layer.cornerRadius = 15
        shareApp.layer.cornerRadius = 15
        reviewApp.layer.cornerRadius = 15
        contactUs.layer.cornerRadius = 15
        help.layer.cornerRadius = 15
        cache.layer.cornerRadius = 15
        
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
