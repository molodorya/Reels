//
//  CreateTemplateMusic.swift
//  Reels
//
//  Created by Nikita Molodorya on 10.12.2022.
//

import UIKit

class CreateTemplateMusic: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add music"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.rowHeight = 80
        
    }
    
    
    @IBAction func leftButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateMusic", for: indexPath)

        

        return cell
    }
    
 
}


class CreateMusicCell: UITableViewCell {
    
    
    @IBOutlet weak var imageMusic: UIImageView!
    @IBOutlet weak var nameMusic: UILabel!
    @IBOutlet weak var artistMusic: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        imageMusic.layer.cornerRadius = 5
    }
}
