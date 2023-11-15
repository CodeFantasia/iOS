
import UIKit
import RxSwift
import Firebase
import FirebaseAuth
import FirebaseStorage
//import Kingfisher

class UserDataManageController: UIViewController {
    
    let data: UserProfile?
    var blockIds: [String] = []
    var followingIds: [String] = []
    var followerIds: [String] = []
    
    init(data: UserProfile?) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 데이터가있는지 판별
    func setUp() {
            if let userProfile = data {
                nicknameTextView.text = userProfile.nickname
                selfIntroductionTextView.text = userProfile.selfIntroduction
                portfolioTextView.text = userProfile.portfolioURL
                selectedTechStack = userProfile.techStack
                techStackTextView.text = selectedTechStack.joined(separator: ", ")
                techStackTextView.layoutIfNeeded()
                selectedInterestField = userProfile.areasOfInterest
                interestTextView.text = selectedInterestField.joined(separator: ", ")
                interestTextView.layoutIfNeeded()
                self.blockIds = userProfile.blockIDs ?? []
                self.followerIds = userProfile.followers ?? []
                self.followingIds = userProfile.following ?? []
            }
        }
    // MARK: - Properties
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.font = UIFont.title
        label.textColor = .black
        return label
    }()
    
    private var selectedTechStack = [String]()
    private var selectedInterestField = [String]()
    
    private let scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.isScrollEnabled = true
        scrollview.showsVerticalScrollIndicator = true
        return scrollview
    }()
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var nicknameView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*닉네임 (영어, 한글 3~12자 입력)", firstSectionLength: 4, textview: nicknameTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var techStackView: UIView = {
        let (view, dropdownButton) = Utilities().dropdownInputFormView(withLabel: "*기술스택 (1개 이상 선택)", firstSectionLength: 5, textview: techStackTextView, textviewHeight: nil)
        dropdownButton.addTarget(self, action: #selector(handleTechStackButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var interestFieldView: UIView = {
        let (view, dropdownButton) = Utilities().dropdownInputFormView(withLabel: "*관심분야 (1개 이상 선택)", firstSectionLength: 5, textview: interestTextView, textviewHeight: nil)
        dropdownButton.addTarget(self, action: #selector(handleInterestFieldButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var portfolioUrlView: UIView = {
        let view = Utilities().inputFormView(withLabel: "포트폴리오 링크", firstSectionLength: 0, textview: portfolioTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var selfIntroductionView: UIView = {
        let view = Utilities().inputFormView(withLabel: "자기소개", firstSectionLength: 0, textview: selfIntroductionTextView, textviewHeight: 100)
        return view
    }()
    
    private lazy var nicknameTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "닉네임을 입력해주세요.")
        return textview
    }()
    
    private let techStackTextView: UITextView = {
        let textview = TextView()
        textview.isEditable = false
        textview.isSelectable = false
        return textview
    }()
    
    private let interestTextView: UITextView = {
        let textview = TextView()
        textview.isEditable = false
        textview.isSelectable = false
        return textview
    }()
    
    private let portfolioTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "포트폴리오 링크를 입력해주세요.")
        return textview
    }()
    
    private let selfIntroductionTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "자기 소개를 입력해주세요.")
        return textview
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.black
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.titleLabel?.font = UIFont.buttonTitle
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
    
    private let withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.titleLabel?.font = UIFont.buttonTitle
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleWithdrawButton), for: .touchUpInside)
        return button
    }()
    
    private let techstackTableview: DropDownTableView = {
        let tableview = DropDownTableView()
        let techstack = TechStack().technologies
        tableview.createDropdownTableView(withList: techstack)
        return tableview
    }()
    
    private let interestTableview: DropDownTableView = {
        let tableview = DropDownTableView()
        let allAreasOfInterest = AreasOfInterest().areasOfInterest
        tableview.createDropdownTableView(withList: allAreasOfInterest)
        return tableview
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureUI()
        configureDropdownUI()
        //        self.hideKeyboard()
    }
    
    // MARK: - Selectors
    
    @objc func handleDoneButton() {
        
        guard let nickname = nicknameTextView.text else { return }
        if !validateUserProfile(nickname: nickname) {
            return
        }
        
        let profileImage = profileImage ?? UIImage(named: "default_profile")
        guard let portfolioUrl = portfolioTextView.text else { return }
        guard let selfIntroduction = selfIntroductionTextView.text else { return }
        
        let disposeBag = DisposeBag()
        let imageStorage = ImageStorageManager()
        let filename = UUID().uuidString
        let path = "profile_image/" + filename
        let currentUser = Auth.auth().currentUser?.uid
        
        if let imageData = profileImage?.jpegData(compressionQuality: 0.3) {
            imageStorage.upload(imageData: imageData, path: path) { imageUrl in
                if let imageUrl = imageUrl {
                    print("이미지 업로드 성공")
                    let userProfile = UserProfile(nickname: nickname,
                                                  techStack: self.selectedTechStack,
                                                  areasOfInterest: self.selectedInterestField,
                                                  portfolioURL: portfolioUrl,
                                                  selfIntroduction: selfIntroduction,
                                                  githubURL: nil,
                                                  blogURL: nil,
                                                  profileImageURL: imageUrl,
                                                  userProjects: nil,
                                                  userID: currentUser,
                                                  blockIDs: self.blockIds,
                                                  followers: self.followerIds,
                                                  following: self.followingIds
                    )
                    
                    let firebaseManager:  FireBaseManagerProtocol = FireBaseManager()
                    let userRepository = UserRepository(collectionId: "User", firebaseBaseManager: firebaseManager)
                    
                    userRepository.create(user: userProfile)
                    userRepository.update(user: userProfile)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("Register"), object: nil)
                    
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? TabBarController else { return }
                    
                    tab.configureUI()
                    
                    self.dismiss(animated: true)
                } else {
                    print("이미지 업로드 실패!")
                }
            }
        } else {
            print("이미지 데이터가 유효하지 않습니당. 흠..")
        }
        
    }
    
    
    
    @objc func handleWithdrawButton() {
        if let user = Auth.auth().currentUser {
            self.alertViewAlert(title: "회원 탈퇴", message: """
                                                               정말 탈퇴 하시겠습니까?
                                                               기존의 정보들이 모두 삭제됩니다.
                                                               """, cancelText: "아니요", acceptCompletion:  {
                self.deleteEmail()
                user.delete { [self] error in
                    if let error = error {
                        print("Firebase Error : ", error)
                    } else {
                        let currentAuthor = self.data?.userID
                        let firebaseManager:  FireBaseManagerProtocol = FireBaseManager()
                        let userRepository = UserRepository(collectionId: "User", firebaseBaseManager: firebaseManager)
                        userRepository.delete(userId: currentAuthor ?? "")
                        let db = Firestore.firestore()
                        db.collection("Project").whereField("writerID", isEqualTo: currentAuthor ?? "").getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error)")
                            } else {
                                for document in querySnapshot!.documents {
                                    document.reference.delete()
                                    print("Document successfully deleted.")
                                }
                                self.alertViewAlert(title: "탈퇴 완료", message: """
                                                                               탈퇴가 완료 되었습니다.
                                                                               서비스를 이용하려면 다시 가입해주세요.
                                                                               로그인 화면으로 돌아갑니다.
                                                                               """, cancelText: nil, acceptCompletion:  {
                                    DispatchQueue.main.async {
                                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                                            fatalError("could not get scene delegate ")
                                        }
                                        sceneDelegate.window?.rootViewController = TabBarController()
                                    }
                                })
                            }
                        }
                    }
                }
            })
        } else {
            self.alertViewAlert(title: "로그인 정보가 일치하지 않습니다", message: """
                                                           다시 로그인 후 탈퇴해주세요.
                                                           """, cancelText: nil, acceptCompletion:  {})
                }
    }
    
    @objc func backBarButton() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleTechStackButton() {
        techstackTableview.isHidden = !techstackTableview.isHidden
        interestTableview.isHidden = true
    }
    
    @objc func handleInterestFieldButton() {
        interestTableview.isHidden = !interestTableview.isHidden
        techstackTableview.isHidden = true
    }
    
    
    // MARK: - Helpers
    
    func deleteEmail() {
        guard let email = getCurrentUserEmail() else { return }
        AuthManager().deleteAccountWithEmail(email) { error in
            if error == nil {
                print("이메일 지우기 성공!")
            } else {
                print("이메일 지우기 실패!")
            }
        }
    }
    
    func getCurrentUserEmail() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.email
        } else {
            return nil
        }
    }
    
    func hideWithdrawButton() {
        withdrawButton.isHidden = true 
    }
    
    func validateUserProfile(nickname: String) -> Bool {
        if !containsOnlyEnglishAndKorean(nickname) {
            nicknameView.shake()
        } else if nickname.count < 3 || nickname.count > 12 {
            nicknameView.shake()
        } else if selectedTechStack.isEmpty {
            techStackView.shake()
        } else if selectedInterestField.isEmpty {
            interestFieldView.shake()
        } else if portfolioTextView.text.isEmpty || portfolioTextView.text == "포트폴리오 링크를 입력해주세요." {
            portfolioUrlView.shake()
        } else if selfIntroductionTextView.text.isEmpty || selfIntroductionTextView.text == "자기 소개를 입력해주세요." {
            selfIntroductionView.shake()
        } else {
            return true
        }
        let alertController = UIAlertController(title: "프로필 등록 실패", message: "입력 사항을 모두 입력해주세요", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return false
    }
    
    func containsOnlyEnglishAndKorean(_ input: String) -> Bool {
        let pattern = "^[a-zA-Z가-힣]*$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        techstackTableview.dropDownDelegate = self
        interestTableview.dropDownDelegate = self
        
        view.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(CGFloat.spacing)
        }
        
        scrollview.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(130)
        }
        
        let stackview = UIStackView(arrangedSubviews: [nicknameView, techStackView, interestFieldView, portfolioUrlView, selfIntroductionView, doneButton, withdrawButton])
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.distribution = .fillProportionally
        
        scrollview.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20)
            make.left.right.width.equalToSuperview().inset(CGFloat.spacing)
            make.bottom.equalToSuperview().inset(CGFloat.spacing)
        }
        
        scrollview.contentSize = CGSize(width: view.frame.width, height: stackview.frame.maxY + 20)
        
    }
    
    func configureDropdownUI() {
        view.addSubview(techstackTableview)
        techstackTableview.isHidden = true
        techstackTableview.snp.makeConstraints { make in
            make.left.right.equalTo(techStackView)
            make.top.equalTo(techStackView.snp.bottom).offset(2)
            make.height.equalTo(250)
        }
        
        view.addSubview(interestTableview)
        interestTableview.isHidden = true
        interestTableview.snp.makeConstraints { make in
            make.left.right.equalTo(interestFieldView)
            make.top.equalTo(interestFieldView.snp.bottom).offset(2)
            make.height.equalTo(250)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension UserDataManageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        addPhotoButton.layer.cornerRadius = 130 / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.imageView?.contentMode = .scaleToFill
        addPhotoButton.imageView?.clipsToBounds = true
        addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - DropDownTableViewDelegate

extension UserDataManageController: DropDownTableViewDelegate {
    func didSelectItem(_ item: String) {
        if techstackTableview.isHidden == false {
            if !selectedTechStack.contains(item) {
                if !techStackTextView.text.isEmpty {
                    techStackTextView.text.append(", ")
                }
                techStackTextView.text.append(item)
                selectedTechStack.append(item)
                techStackTextView.layoutIfNeeded()
            }
        } else if interestTableview.isHidden == false {
            if !selectedInterestField.contains(item) {
                if !interestTextView.text.isEmpty {
                    interestTextView.text.append(", ")
                }
                interestTextView.text.append(item)
                selectedInterestField.append(item)
                interestTextView.layoutIfNeeded()
            }
        }
    }
    
    func didDeselectItem(_ item: String) {
        if techstackTableview.isHidden == false {
            if let range = techStackTextView.text.range(of: item) {
                techStackTextView.text.removeSubrange(range)
            }
            selectedTechStack.removeAll { $0 == item }
            techStackTextView.text = selectedTechStack.joined(separator: ", ")
        } else if interestTableview.isHidden == false {
            if let range = interestTextView.text.range(of: item) {
                interestTextView.text.removeSubrange(range)
            }
            selectedInterestField.removeAll { $0 == item }
        interestTextView.text = selectedInterestField.joined(separator: ", ")
        }
    }
}
