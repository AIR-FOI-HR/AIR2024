//
//  RegistrationCompletionViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 28.11.2020..
//

import UIKit

enum RegistrationCompletionNavigation: String {
    case home = "CompletionToHome"
}

enum Avatars: String, CaseIterable {
    case avatar1 = "avatar1"
    case avatar2 = "avatar2"
    case avatar3 = "avatar3"
    case avatar4 = "avatar4"
    case avatar5 = "avatar5"
    case avatar6 = "avatar6"
    case avatar7 = "avatar7"
    case avatar8 = "avatar8"
    case avatar9 = "avatar9"
    case avatar10 = "avatar10"
}

//MARK: - AvatarCell class

class AvatarCell {
    var avatar: Avatars
    var image: UIImage? { UIImage(named: avatar.rawValue) }
    
    init(imageName: Avatars) {
        self.avatar = imageName
    }
}

final class RegistrationCompletionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    let textFieldAppearance = TextFieldAppearance()
    let registrationService = RegistrationService()
    var userInformation: UserInformation?
    var userPreferences: UserPreferences?
    var selectedAvatar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: IBActions
    
    //    @IBAction func avatarPresed(_ sender: UIButton) {
    //        if(selectedAvatar != 0){
    //            let currentAvatar = self.view.viewWithTag(sender.tag)
    //            sender.selectedButtonAvatar(currentAvatar as! UIButton)
    //
    //            let previousAvatar = self.view.viewWithTag(selectedAvatar)
    //            sender.deselectedButtonAvatar(previousAvatar as! UIButton)
    //
    //            selectedAvatar = sender.tag
    //        } else {
    //            let currentAvatar = self.view.viewWithTag(sender.tag)
    //            sender.selectedButtonAvatar(currentAvatar as! UIButton)
    //
    //            selectedAvatar = Int(sender.tag)
    //        }
    //    }
    
    //MARK: - CollectionVIew handling
    
    var avatarNames: [AvatarCell] {
        [.init(imageName: .avatar1), .init(imageName: .avatar2), .init(imageName: .avatar3), .init(imageName: .avatar4), .init(imageName: .avatar5), .init(imageName: .avatar6), .init(imageName: .avatar7), .init(imageName: .avatar8), .init(imageName: .avatar9), .init(imageName: .avatar10)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Avatars.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AvatarCollectionViewCell else { fatalError() }
        
        var avatarImages = [UIImage]()
        for name in avatarNames {
            if let avatarImage = name.image {
                avatarImages.append(avatarImage)
            }
        }
        cell.avatarImageView.image = avatarImages[indexPath.item]
        
        return cell
    }
    
    //MARK: - CollectionVIew: SelectedItems
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if selectedAvatar == indexPath.item + 1 {
            cell.layer.borderWidth = 0
            selectedAvatar = 0
        } else {
            cell.isSelected = true
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
            selectedAvatar = indexPath.item + 1
        }
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.isSelected = false
        selectedAvatar = 0
        cell.layer.borderWidth = 0
    }
    
    //MARK: - IBActions
    
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        if selectedAvatar == 0 {
            selectedAvatar = 1
        }
        guard let username = usernameTextField.text else { return }
        self.userPreferences = UserPreferences(username: username, avatarId: selectedAvatar)
        let registrationData = RegistrationData(first: userInformation, second: userPreferences)
        guard let firstScreenData = registrationData.first, let secondScreenData = registrationData.second else {
            return
        }
        
        let registrationUser = RegistrationUser(firstName: firstScreenData.firstName, lastName: firstScreenData.lastName, email: firstScreenData.email, password: firstScreenData.password, username: secondScreenData.username, avatarId: secondScreenData.avatarId)
        
        registrationService.register(userData: registrationUser, success: { registrationResponse in
            UserDefaultsManager.shared.saveUserDefault(value: registrationResponse.userName, key: .userName)
            UserDefaultsManager.shared.saveUserDefault(value: registrationResponse.userAvatar, key: .userAvatar)
            SessionManager.shared.saveToken(registrationResponse.sessionToken)
            self.navigate(to: .home)
        }, failure: {error in
            debugPrint(error)
            self.presentAlert(title: "Oops!", message: "Error occured in registration process!")
            return
        })
    }
    
    @IBAction func registrationCompletionTextFieldDidBeginEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationCompletionTextFieldDidEndEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}

private extension RegistrationCompletionViewController {
    func navigate(to path: RegistrationCompletionNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
