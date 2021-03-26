//
//  moodViewController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/20.
//

import UIKit

class moodViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backButton: UIButton!
    let reuseIdentifier = "cell"
    let moodArray = ["Happy", "Sad", "Neutral"]
    let moodImageArray = ["happy-icon", "sad-icon", "neutral-icon"]
    var currentMoodIndex = 0
    var backButtonHidden = true
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width - 60

        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! myCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.moodArray[indexPath.row]
        cell.myImage.image = UIImage(named: self.moodImageArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") as! BaseTabBarController
        mainTabBarController.currentMoodIndex = indexPath.row
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func backAction(sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") as! BaseTabBarController
//        mainTabBarController.currentMoodIndex = currentMoodIndex
//        mainTabBarController.modalPresentationStyle = .fullScreen
//        self.present(mainTabBarController, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let nib = UINib(nibName: "myCollectionViewCell", bundle: nil)
//        myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollectionViewCell")
        
        backButton.isHidden = backButtonHidden
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let w = myCollectionView.frame.width / 3 - 1
        layout.itemSize = CGSize(width: w, height: w-2)
        myCollectionView.collectionViewLayout = layout
        
    }

}
