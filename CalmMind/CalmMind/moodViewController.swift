//
//  moodViewController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/20.
//

import UIKit

class moodViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell"
    let moodArray = ["Happy", "Angry", "Sad", "Crazy"]
    let moodImageArray = ["happy-icon", "angry-icon", "sad-icon", "crazy-icon"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width / 2 - 1

        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 30
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! myCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        print(self.moodArray[indexPath.row])
        cell.myLabel.text = self.moodArray[indexPath.row]
        cell.myImage.image = UIImage(named: self.moodImageArray[indexPath.row])
//        cell.myImage.image = self.moodImageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let nib = UINib(nibName: "myCollectionViewCell", bundle: nil)
//        myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let w = myCollectionView.frame.width / 2 - 1
        layout.itemSize = CGSize(width: w, height: 2)
        myCollectionView.collectionViewLayout = layout
        
    }

}
