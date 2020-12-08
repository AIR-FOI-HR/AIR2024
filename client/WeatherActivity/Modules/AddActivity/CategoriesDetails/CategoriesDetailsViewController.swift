//
//  CategoriesDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 05.12.2020..
//

import UIKit

final class CategoryDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: IBOutlets

    @IBOutlet weak var horizontalStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
        
    // MARK: Properties
    
    let categoryService = CategoryService()
    var allCategories = [String]()
    var numberOfPages: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        getAllCategories()
        setCollectionViewLayout()
    }
    
    func getAllCategories() {
        categoryService.getAllCategories(success: { apiResponse in
            self.allCategories = apiResponse.categories
            self.numberOfPages = Int(self.allCategories.count / 6) + 1 // TODO
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
