//
//  ProfileViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 21.01.2021..
//

import UIKit
import WidgetKit
import SkeletonView

enum ProfileNavigation: String {
    case login = "profileToLogin"
}

enum ProfileAlertMessages: String {
    case editTitle = "That's it!"
    case editMessage = "Successfully updated your profile info."
    
    case editErrorTitle = "Hmm.. error"
    case editErrrorMessage = "There seems to be a problem with updating your info, try again."
    
    case firstTimeTitle = "First time key deleted!"
    case firstTimeMessage = "Now you can see initial screens once again."
    
    case deletedMailTitle = "Remembered email deleted!"
    case deletedMailMessage = "Now there won't be an email address waiting for you at login."
}

final class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak private var mainView: UIView!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var logoutButton: UIButton!
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var firstNameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: IBOutlets - Edit profile
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var usernameTextField: UITextField!
    
    //MARK: IBOutlets - StackViews
    @IBOutlet weak private var profileStackView: UIStackView!
    @IBOutlet weak private var editProfileStackVIew: UIStackView!
    
    //MARK: - Properties
    
    var selectedAvatar: Int?
    var userDefaultAvatar: Int? = 0
    let textFieldAppearance = TextFieldAppearance()
    let userService = UserService()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        showProfileStack()
        fetchUserProfileData()
    }
    
    //MARK: - Custom functions
    
    func fetchUserProfileData() {
        showSkeleton()
        userService.getUserProfileData(success: { userData in
            self.setUpLabels(user: userData)
            self.setUpTextFields(user: userData)
            self.userDefaultAvatar = userData.avatarId
            self.mainView.hideSkeleton()
        }, failure: { error in
            print(error)
        })
    }
    
    func setUpLabels(user: User) {
        avatarImageView.image = UIImage(named: user.avatarName)
        firstNameLabel.text = user.firstName + " " + user.lastName
        usernameLabel.text = user.username
        emailLabel.text = user.mail
    }
    
    func setUpTextFields(user: User) {
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        usernameTextField.text = user.username
    }
    
    func showProfileStack() {
        profileStackView.isHidden = false
        editProfileStackVIew.isHidden = true
    }
    
    func showEditProfileStack() {
        profileStackView.isHidden = true
        editProfileStackVIew.isHidden = false
    }
    
    func showSkeleton() {
        let gradient = SkeletonGradient(baseColor: .skeletonDefault)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        mainView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
    
    //MARK: - IBActions
    
    @IBAction func editPressed(_ sender: Any) {
        showEditProfileStack()
    }
    
    @IBAction func setUpInitialScreensPressed(_ sender: UIButton) {
        self.presentAlertMessage(title: ProfileAlertMessages.firstTimeTitle.rawValue, message: ProfileAlertMessages.firstTimeMessage.rawValue, length: 1.2)
        UserDefaultsManager.shared.deleteUserDefault(key: .firstTime)
    }
    
    @IBAction func deleteLastEnteredMailPressed(_ sender: UIButton) {
        self.presentAlertMessage(title: ProfileAlertMessages.deletedMailTitle.rawValue, message: ProfileAlertMessages.deletedMailMessage.rawValue, length: 1.2)
        SessionManager.shared.deleteFromKeychain(key: .lastEnteredMail)
    }
    
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        if selectedAvatar == nil {
            selectedAvatar = userDefaultAvatar
        }
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let username = usernameTextField.text, let avatarId = selectedAvatar, let sessionToken = SessionManager.shared.getStringFromKeychain(key: .sessionToken) else { return }
        let userUpdateData = UserUpdate(firstName: firstName, lastName: lastName, username: username, avatarId: avatarId, sessionToken: sessionToken)
        
        userService.updateUserProfileData(userData: userUpdateData, success: { response in
            if response {
                self.fetchUserProfileData()
                self.showProfileStack()
                self.presentAlertMessage(title: ProfileAlertMessages.editTitle.rawValue, message: ProfileAlertMessages.editMessage.rawValue, length: 0.8)
            } else {
                self.presentAlertMessage(title: ProfileAlertMessages.editErrorTitle.rawValue, message: ProfileAlertMessages.editErrrorMessage.rawValue, length: 0.8)
            }
        }, failure: { error in
            print(error)
        })
    }
    
    @IBAction func cancelXPressed(_ sender: UIButton) {
        showProfileStack()
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        SessionManager.shared.deleteFromKeychain(key: .sessionToken)
        WidgetCenter.shared.reloadAllTimelines()
        navigate(to: .login)
    }
    
    @IBAction func profileTextFieldDidBeginEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func profileTextFieldDidEndEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
    //MARK: - CollectionVIew handling
    
    var avatarNames: [AvatarCell] {
        [.init(imageName: .avatar1), .init(imageName: .avatar2), .init(imageName: .avatar3), .init(imageName: .avatar4), .init(imageName: .avatar5), .init(imageName: .avatar6), .init(imageName: .avatar7), .init(imageName: .avatar8), .init(imageName: .avatar9), .init(imageName: .avatar10)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Avatars.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCollectionViewCell else { fatalError() }
        
        var avatarImages = [UIImage]()
        for name in avatarNames {
            if let avatarImage = name.image {
                avatarImages.append(avatarImage)
            }
        }
        cell.profileAvatarImageView.image = avatarImages[indexPath.item]
        
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
            cell.layer.cornerRadius = 5
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
}

private extension ProfileViewController {
    func navigate(to path: ProfileNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
