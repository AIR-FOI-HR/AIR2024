//
//  CategoriesDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 05.12.2020..
//

import UIKit

final class CategoryDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: IBOutlets

    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
        
    // MARK: Properties
    
    let categoryService = CategoryService()
    var allCategories = [String]()
    var recentCategories = [String]()
    var numberOfPages: Int = 0
    var emptyResponse: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        getAllCategories()
        setCollectionViewLayout()
        setRecentCategories()
    }
    
    func updateHorizontalStackView() {
        // TODO: add images for each category
            
        horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution  = UIStackView.Distribution.fillEqually
        horizontalStackView.alignment = UIStackView.Alignment.center
        horizontalStackView.spacing   = 10.0
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if !emptyResponse {
            createLabelsForRecentCategories()
        }
        else {
            createLabelForNoRecentCategories()
        }
    }
    
    func createLabelsForRecentCategories() {
        for category in recentCategories {
            let textLabel = UILabel()
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor.systemGray
            textLabel.font = textLabel.font.withSize(13)
            textLabel.text  = category
            horizontalStackView.addArrangedSubview(textLabel)
        }
    }
    
    func createLabelForNoRecentCategories() {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.systemGray
        textLabel.font = textLabel.font.withSize(16)
        textLabel.text  = "You don't have any recent categories"
        horizontalStackView.addArrangedSubview(textLabel)
    }
    
    func setRecentCategories() {
        let email = "test3@gmail.com"
        // TODO: get logged user's mail (not hardcoded)
        categoryService.getRecentCategories(userEmail: email, success: { apiResponse in
            if(apiResponse.empty) {
                self.emptyResponse = true
            }
            else {
                self.recentCategories = apiResponse.categories!
                self.emptyResponse = false
            }
            
            self.updateHorizontalStackView()
        }, failure: { error in
            print(error.localizedDescription)
            self.presentAlert(title: "Oops!", message: "Something went wrong with getting your recent categories!")
        })
    }
    
    func getAllCategories() {
        categoryService.getAllCategories(success: { apiResponse in
            self.allCategories = apiResponse.categories!
            self.numberOfPages = Int(self.allCategories.count / 6)
            // TODO: fix bug with page control not recognizing last page and not setting propiate number of pages
            self.updateCollectionView()
        }, failure: { error in
            print(error.localizedDescription)
            self.presentAlert(title: "Oops!", message: "Something went wrong with getting categories!")
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryName.text = allCategories[indexPath.item]
        // TODO: add images for each category
        return cell
    }
    
    func updateCollectionView() {
//        DispatchQueue.main.async {
        self.collectionView.reloadData()
//        }
    }
    
    func setCollectionViewLayout() {
        pageControl.hidesForSinglePage = true
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = collectionView.bounds.width / 3 - (collectionView.layoutMargins.left + collectionView.layoutMargins.right) / 2
        let height = collectionView.bounds.size.height / 2 - (collectionView.layoutMargins.top + collectionView.layoutMargins.bottom) / 2
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView!.collectionViewLayout = layout
    }
    
}
