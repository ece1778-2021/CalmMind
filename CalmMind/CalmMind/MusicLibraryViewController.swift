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
    var songList = [String]()
    var bpmList = [String]()
    var delegate: ChangeSongDelegate?
    var backColor = UIColor()
    var hexList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
        mytableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
        mytableView.delegate = self
        mytableView.dataSource = self
        
        view.backgroundColor = backColor
        mytableView.backgroundColor = backColor
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
        cell.backgroundColor = backColor
        cell.contentView.backgroundColor = backColor
        cell.imageview.image = UIImage(named: hexList[indexPath.row])
        cell.songnameLabel.text = songList[indexPath.row]
        cell.songnameLabel?.font = UIFont(name: "Helvetica", size: 18)
        cell.bpmLabel.text = " " + bpmList[indexPath.row] + " BPM "
        cell.bpmLabel?.font = UIFont(name: "Helvetica", size: 16)
        return cell
        
    }
}
