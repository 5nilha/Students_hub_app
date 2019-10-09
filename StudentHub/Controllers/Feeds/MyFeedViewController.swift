//
//  MyFeedViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/9/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import ImagePicker

class MyFeedViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate {
    
    

    @IBOutlet weak var wordsCountLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var feedMessageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    lazy var imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        

        self.feedMessageView.roundCorner(radius: 10)
        self.feedMessageView.setBorder(width: 2, color: #colorLiteral(red: 0, green: 0.4631429315, blue: 0.7913406491, alpha: 1))
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            self.wordsCountLabel.text = "\(text.count)"
        }
        else {
            self.wordsCountLabel.text = "\(0)"
        }
    }
    
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        self.imagePickerController.delegate = self
        imagePickerController.imageLimit = 6
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: -> Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFeedCell", for: indexPath) as! MyFeedCell
        cell.feedImage.image = images[indexPath.row]
        return cell
    }
    
    //MARK: -> ImagePicker Methods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        self.waitView(message: "") { [unowned self] (waitSpinner) in
            self.images = images
            self.imagePickerController.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
            waitSpinner.hideView()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

class MyFeedCell: UICollectionViewCell {
    @IBOutlet weak var feedImage: UIImageView!
    
}
