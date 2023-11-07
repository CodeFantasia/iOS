
import UIKit
import RxSwift
import Firebase
import FirebaseAuth
import FirebaseStorage
//import Kingfisher

class UserDataManageController: UIViewController {
    
    let data: UserProfile?
    
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
            techStackTextView.text = userProfile.techStack.joined(separator: ", ")
            interestTextView.text = userProfile.areasOfInterest.joined(separator: ", ")
            let profileImageURL = (URL(string: userProfile.profileImageURL ?? "") ?? URL(string: ""))

//            // Kingfisher를 사용하여 이미지를 다운로드
//            KingfisherManager.shared.retrieveImage(with: profileImageURL!) { result in
//                switch result {
//                case .success(let imageResult):
//                    // 이미지 다운로드 및 처리가 성공한 경우
//                    let image = imageResult.image
//                    self.profileImage = image
//                    // 이제 'self.profileImage'에 이미지가 할당되었습니다.
//                case .failure(let error):
//                    // 이미지 다운로드 중 오류 발생한 경우
//                    print("이미지 다운로드 오류: \(error)")
//                }

        } else {
        }
    }
    // MARK: - Properties
    
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
        button.tintColor = .white
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
        button.backgroundColor = UIColor.white
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.titleLabel?.font = UIFont.buttonTitle
        button.setTitleColor(.primaryColor, for: .normal)
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
        configureNavBar()
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
                                                  userID: UUID())
                    
                    let firebaseManager:  FireBaseManagerProtocol = FireBaseManager()
                    let userRepository = UserRepository(collectionId: "User", firebaseBaseManager: firebaseManager)

                    userRepository.create(user: userProfile)
                    userRepository.update(user: userProfile)
                    
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
        if  let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    print("Firebase Error : ", error)
                } else {
                    print("회원탈퇴 성공!")
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
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
        view.backgroundColor = UIColor.primaryColor
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        techstackTableview.dropDownDelegate = self
        interestTableview.dropDownDelegate = self
        
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.spacing)
        }
        
        scrollview.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
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
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backBarButton))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "회원 정보 입력"
        navigationItem.titleView?.tintColor = .white
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
            if !techStackTextView.text.isEmpty {
                techStackTextView.text.append(", ")
            }
            techStackTextView.text.append(item)
            selectedTechStack.append(item)
            techStackTextView.layoutIfNeeded()
        } else if interestTableview.isHidden == false {
            if !interestTextView.text.isEmpty {
                interestTextView.text.append(", ")
            }
            interestTextView.text.append(item)
            selectedInterestField.append(item)
            interestTextView.layoutIfNeeded()
        }
    }
    
    func didDeselectItem(_ item: String) {
        if techstackTableview.isHidden == false {
            if let range = techStackTextView.text.range(of: item) {
                techStackTextView.text.removeSubrange(range)
            }
            selectedTechStack.removeAll { $0 == item }
        } else if interestTableview.isHidden == false {
            if let range = interestTextView.text.range(of: item) {
                interestTextView.text.removeSubrange(range)
            }
            selectedInterestField.removeAll { $0 == item }
        }
        
    }
    
}
