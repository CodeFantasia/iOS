
import UIKit
import Firebase
import FirebaseStorage

class UserDataManageController: UIViewController {
    
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()

    private lazy var nicknameView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*닉네임 (영어, 한글 3~12자 입력)", firstSectionLength: 4, textfield: nicknameTextField, textfieldHeight: nil)
        return view
    }()
    
    private lazy var techStackView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*기술스택 (1개 이상 선택)", firstSectionLength: 5, textfield: techStackTextField, textfieldHeight: nil)
        return view
    }()
    
    private lazy var interestFieldView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*관심분야 (1개 이상 선택)", firstSectionLength: 5, textfield: interestTextField, textfieldHeight: nil)
        return view
    }()
    
    private lazy var portfolioUrlView: UIView = {
        let view = Utilities().inputFormView(withLabel: "포트폴리오 링크", firstSectionLength: 0, textfield: portfolioURLTextField, textfieldHeight: nil)
        return view
    }()
    
    private lazy var selfIntroductionView: UIView = {
        let view = Utilities().inputFormView(withLabel: "자기소개", firstSectionLength: 0, textfield: selfIntroductionTextField, textfieldHeight: nil)
        return view
    }()
    
    private let nicknameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해주세요."
        return textfield
    }()
    
    private let techStackTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "기술 스택을 선택해주세요."
        return textfield
    }()
    
    private let interestTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "관심분야를 입력해주세요."
        return textfield
    }()
    
    private let portfolioURLTextField = {
        let textfield = UITextField()
        textfield.placeholder = "링크를 입력해주세요"
        return textfield
    }()
    
    private let selfIntroductionTextField = {
        let textfield = UITextField()
        textfield.placeholder = "자기소개를 입력해주세요."
        return textfield
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.titleLabel?.font = UIFont.buttonTitle
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleDoneButton() {
        print("Done button tapped!")
    }
    
    @objc func handleAddPhoto() {
        print("Add Photo tapped!")
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "회원 정보 등록"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(150)
        }

        let stackview = UIStackView(arrangedSubviews: [nicknameView, techStackView, interestFieldView, interestFieldView, portfolioUrlView, selfIntroductionView, doneButton])
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.distribution = .fillEqually
        
        view.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
        }

    }
}

extension UserDataManageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        addPhotoButton.layer.cornerRadius = 150 / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.imageView?.contentMode = .scaleToFill
        addPhotoButton.imageView?.clipsToBounds = true
        addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
