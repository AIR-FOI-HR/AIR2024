//
//  CategoriesDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 05.12.2020..
//

import UIKit
import CHIPageControl


final class CategoriesDetailsViewController: AddActivityStepViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    // MARK: IBOutlets

    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    
    // MARK: Properties
    
    let categoryService = CategoryService()
    var allCategories = [Category]()
    var recentCategories = [Category]()
    var searchAllCategories = [Category]()
    var selectedCategory = ""
    var isRecentCategoriesSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setAllCategories()
        setCollectionViewLayout()
        setRecentCategories()
        
        guard
            let flowNavigator = flowNavigator,
            let activityDetails = flowNavigator.editingActivity
        else { return }
        
        if flowNavigator.isEditing {
            selectedCategory = activityDetails.name
        }
    }
    
    func updateHorizontalStackView() {
        horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution  = UIStackView.Distribution.fillEqually
        horizontalStackView.alignment = UIStackView.Alignment.center
        horizontalStackView.spacing = 5.0
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if recentCategories.isEmpty {
            addNoRecentCategoriesLabel()
        }
        else {
            addRecentCategoriesItems()
        }
    }
    
    // MARK: - IBActions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showNextStep(
            from: .categoriesDetails,
            data: StepData(
                stepInfo: .categoriesDetails,
                data: CategoryDetails(
                    selectedCategory: selectedCategory)
            )
        )
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showPreviousStep()
    }
    
    
    
    func addRecentCategoriesItems() {
        var index = 0
        for category in recentCategories {
            let categoryName = category.categoryName.rawValue
                
            let verticalStackView = UIStackView()
            verticalStackView.axis = NSLayoutConstraint.Axis.vertical
            verticalStackView.accessibilityIdentifier = categoryName
            verticalStackView.spacing = 10.0
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stackViewPressed(_:)))
            
            let textLabel = UILabel()
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor.black
            textLabel.font = textLabel.font.withSize(13)
            textLabel.text  = categoryName
            
            let categoryImage = UIImage(named: categoryName.lowercased())
            let imageView = UIImageView(image: categoryImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 84.0).isActive = true
            
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.tag = index
                        
            verticalStackView.addArrangedSubview(imageView)
            verticalStackView.addArrangedSubview(textLabel)
            horizontalStackView.addArrangedSubview(verticalStackView)
            
            index += 1
        }
    }
    
    @objc func stackViewPressed(_ sender: UITapGestureRecognizer) {
        guard let selectedIndex = sender.view?.tag else {
            fatalError("Couldn't get index of pressed stackView")
        }
        let selectedView = horizontalStackView.arrangedSubviews[selectedIndex]
        guard let selectedCategoryIdentifier = selectedView.accessibilityIdentifier else {
            fatalError("Accessibility identifier for selected image doesn't exist.")
        }
        guard let visibleCells = collectionView.visibleCells as? [CategoriesCollectionViewCell] else {
            fatalError("Couldn't get visible cells in collection view.")
        }
        isRecentCategoriesSelected = true
        deselectAllRecentCategories()
        selectedView.layer.borderWidth = 1.2
        selectedView.layer.borderColor = UIColor.LightBlueColor.cgColor
        selectedView.layer.cornerRadius = 10
        for cell in visibleCells {
            if cell.categoryName.text == selectedCategory {
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
            }
        }
        selectedCategory = selectedCategoryIdentifier
    }
    
    func deselectAllRecentCategories() {
        for stackView in horizontalStackView.arrangedSubviews {
            stackView.layer.borderWidth = 0
            stackView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func addNoRecentCategoriesLabel() {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        textLabel.font = textLabel.font.withSize(16)
        textLabel.text  = "You don't have any recent categories"
        horizontalStackView.addArrangedSubview(textLabel)
    }
    
    func setRecentCategories() {
        if let sessionToken = SessionManager.shared.getToken() {
            categoryService.getRecentCategories(token: sessionToken, success: { apiResponse in
                if(!apiResponse.categories.isEmpty) {
                    self.recentCategories = apiResponse.categories
                }
                self.updateHorizontalStackView()
            }, failure: { error in
                print(error.localizedDescription)
                self.presentAlert(title: "Oops!", message: "Something went wrong with getting your recent categories!")
            })
        }
    }
    
    func setAllCategories() {
        categoryService.getAllCategories(success: { apiResponse in
            self.allCategories = apiResponse.categories
            self.searchAllCategories = self.allCategories
            let nbCategories = Double(self.allCategories.count)
            self.pageControl.numberOfPages = Int(ceil(nbCategories / 6.0))
            self.updateCollectionView()
        }, failure: { error in
            print(error.localizedDescription)
            self.presentAlert(title: "Oops!", message: "Something went wrong with getting categories!")
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell else {
            fatalError("Couldn't get selected cell in collection view.")
        }
        guard let categoryName = cell.categoryName.text else {
            fatalError("Label for selected category in collection view is empty.")
        }
        isRecentCategoriesSelected = false
        deselectAllRecentCategories()
        updateCollectionView()
        selectedCategory = categoryName
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
            fatalError()
        }
        let categoryName = allCategories[indexPath.item].categoryName.rawValue
        cell.categoryName.text = categoryName
        let categoryImage = UIImage(named: categoryName.lowercased())
        cell.categoryImage.image = categoryImage
        
        if selectedCategory == cell.categoryName.text && !isRecentCategoriesSelected {
            cell.layer.borderColor = UIColor.LightBlueColor.cgColor
            cell.layer.borderWidth = 1.2
            cell.layer.cornerRadius = 10
            cell.isSelected = true
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newPageNumber = Int(ceil(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.set(progress: newPageNumber, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        allCategories.removeAll()
        for category in searchAllCategories {
            let categoryName = category.categoryName.rawValue
            if (categoryName.lowercased().contains(searchText.lowercased())) {
                allCategories.append(category)
            }
        }
        if (searchText.isEmpty) {
            allCategories = searchAllCategories
        }
        updateCollectionView()
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40) / 3 - (collectionView.layoutMargins.left + collectionView.layoutMargins.right) / 2
        let height = collectionView.bounds.size.height / 2 - (collectionView.layoutMargins.top + collectionView.layoutMargins.bottom) / 2
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.collectionViewLayout = layout
    }
    
}

