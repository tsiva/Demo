//
//  ViewController.swift
//  ImageDownloadDisplay
//
//  Created by Siva Kumar Reddy Thimmareddy on 10/09/19.
//  Copyright © 2019 Siva Kumar Reddy Thimmareddy. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "imageCell"
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UserHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserHeaderView")


        getjson()
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let usersImages:[User] = users {
            return usersImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let usersImages:[User] = users {
            return usersImages[section].items.count
        }
        return 0
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCell
        cell.backgroundColor = .clear
        let usersImages:[User] = users!
            let items = usersImages[indexPath.section].items
        
        let url = URL(string: items[indexPath.row])
        cell.userImage.kf.setImage(with: url)

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 50)

    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserHeaderView", for: indexPath)  as! UserHeaderView
//        let usersImages:[User] = users!
//        let user = usersImages[indexPath.section]
//
//        let url = URL(string: user.image)
////        headerView.profilePic.kf.setImage(with: url)
//
////        headerView.userName.text = user.name
//        return headerView
//
//    }

     func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
        // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "\(UserHeaderView.self)",
                    for: indexPath) as? UserHeaderView
                else {
                    fatalError("Invalid view type")
            }
            
//            let searchTerm = searches[indexPath.section].searchTerm
//            headerView.label.text = searchTerm
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let usersImages:[User] = users {
            let items = usersImages[indexPath.section].items.count
            if items % 2 == 0 {
                print("\(items) is even number")
                return CGSize(width: (UIScreen.main.bounds.width/2)-6 , height: (UIScreen.main.bounds.width/2))

            } else {
                print("\(items) is odd number")
                if indexPath.row == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                else {
                return CGSize(width: (UIScreen.main.bounds.width/2)-6 , height: (UIScreen.main.bounds.width/2))
                }

            }
        }

        
        return CGSize(width: (UIScreen.main.bounds.width/2) - 15
            , height: (UIScreen.main.bounds.width/2))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func getjson() {
        let urlPath = "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10"
        let url = URL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            print("Task completed")
            
            guard data != nil && error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print(jsonResult)
                    let  userData = try? JSONDecoder().decode(UserImages.self, from: data!)
                    self.users = userData?.data.users
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    
                }
            } catch let parseError as NSError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }

}

