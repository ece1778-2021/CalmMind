//
//  MusicLibraryViewController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/5.
//

import UIKit

protocol ChangeSongDelegate {
    func changeSong(songName: String)
}

class MusicLibraryViewController: UIViewController {
    
    @IBOutlet var mytableView: UITableView!
    var songList = ["song1", "song2", "song3"]
    var bpmList = ["80", "70", "60"]
    var delegate: ChangeSongDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
        mytableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
        mytableView.delegate = self
        mytableView.dataSource = self
        
    }

}

extension MusicLibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.changeSong(songName: songList[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

extension MusicLibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // ???
//        cell.imageview =
        cell.songnameLabel.text = "Music " + songList[indexPath.row]
        cell.songnameLabel?.font = UIFont(name: "Helvetica", size: 18)
        cell.bpmLabel.text = bpmList[indexPath.row] + " BPM"
        cell.bpmLabel?.font = UIFont(name: "Helvetica", size: 16)
        return cell
        
    }
}
