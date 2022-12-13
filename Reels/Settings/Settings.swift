//
//  Settings.swift
//  Reels
//
//  Created by Nikita Molodorya on 19.10.2022.
//

import UIKit

class Settings: UIViewController {

    @IBOutlet weak var close: UIBarButtonItem!
    
    let settings = ["Уведомление", "Оформление", "Язык", "Информация", "Данные и память", "Помощь", "Вопросы", "Возможности"]
    
    let customSetting = [("bell.badge.fill", "Уведомления"), ("sun.max.circle", "Оформление")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 70
        
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}


extension Settings: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath)
        
       
        var content = cell.defaultContentConfiguration()
       
        
        switch indexPath.row {
        case 0:
            content.text = "Notifications"
            content.image = UIImage(systemName: "bell.badge.fill")
            cell.accessoryType = .disclosureIndicator
            
        case 1:
            content.text = "Theme"
            content.image = UIImage(systemName: "moonphase.last.quarter")
            cell.accessoryType = .disclosureIndicator
        case 2:
            content.text = "Language"
            content.image = UIImage(systemName: "globe")
            cell.accessoryType = .disclosureIndicator
            
        case 3:
            content.text = "Infomation"
            content.image = UIImage(systemName: "info.circle.fill")
            cell.accessoryType = .disclosureIndicator
            
        case 4:
            content.text = "Help"
            content.image = UIImage(systemName: "character.book.closed.fill")
            cell.accessoryType = .disclosureIndicator
            
        case 5:
            content.text = "Question"
            content.image = UIImage(systemName: "list.bullet.clipboard.fill")
            cell.accessoryType = .disclosureIndicator
            
        case 6:
            content.text = "Capabilities"
            content.image = UIImage(systemName: "bolt.fill")
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
        }
        
        
        cell.contentConfiguration = content
        
        
        return cell
    }

    
}
