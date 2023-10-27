//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import Firebase
import FirebaseStorage
import Kingfisher
import SnapKit
// import SwiftUI
import Then
import UIKit

class NewPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - 변수선언

    // firebase 선언
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())

    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 수직 스크롤바 표시 여부
        return scrollView
    }()

    // 임시저장 버튼
    private let saveButton = UIButton().then {
        $0.setTitle("임시저장", for: .normal)
        $0.backgroundColor = UIColor(hex: 0x000000)
        $0.layer.cornerRadius = 15
        $0.setTitleColor(.white, for: .normal)
    }

    // 제목 라벨
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = UIColor(hex: 0x000000)
        $0.sizeToFit()
    }

    // 제목 텍스트필드
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목"
        $0.borderStyle = .roundedRect
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.backgroundColor = .white
    }

    // 썸네일 라벨
    private let thumbnailLabel: UILabel = {
        let label = UILabel()
        label.text = "썸네일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 썸네일 이미지 뷰
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.backgroundColor = .white
        return imageView
    }()

    // 출시 플랫폼 라벨
    private let platformLabel: UILabel = {
        let label = UILabel()
        label.text = "출시 플랫폼"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 출시 플랫폼 텍스트 필드
    private let platformTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "출시 플랫폼"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        //        textField.addTarget(self, action: #selector(showPlatformSelection), for: .touchDown) //
        return textField
    }()

    // 모집 기술 및 언어 라벨
    private let techLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 기술 및 언어"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 모집 기술 및 언어 텍스트 필드
    private let techLanguageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모집 기술 및 언어"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()

    // 모집 분야 라벨
    private let recruitmentFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 분야"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 모집 분야 텍스트 필드
    private let recruitmentFieldTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모집 분야"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()

    // 프로젝트 소개 라벨
    private let projectIntroLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 소개"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 프로젝트 소개 텍스트뷰
    private let projectIntroTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        return textView
    }()

    // 프로젝트 시작 기간 라벨
    let projectStartDateLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 시작일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 프로젝트 종료 기간 라벨
    let projectEndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 종료일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 프로젝트 기간 데이트 피커1
    let projectStartDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    // 프로젝트 기간 데이트 피커2
    let projectEndDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    // 모임 유형 라벨
    let meetingTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 유형"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 모임 유형 텍스트 필드
    let meetingTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 유형"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()

    // 신청 시 연락 방법 라벨
    let contactMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "연락 수단을 적어주세요."
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 신청 시 연락 방법 텍스트 필드
    let contactMethodTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "신청 시 연락 방법"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()

    // 작성 완료 버튼
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
//        button.frame = CGRect(x: 10, y: 1000, width: UIScreen.main.bounds.width - 20, height: 40)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // 출시 플랫폼 텍스트 필드를 탭할 때 모달 페이지를 표시
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(platformTextFieldTapped))
        platformTextField.addGestureRecognizer(tapGesture)
        platformTextField.isUserInteractionEnabled = true

        // 썸네일 이미지 뷰를 탭할 때 이미지 선택 기능을 호출
        let thumbnailTapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailImageViewTapped))
        thumbnailImageView.addGestureRecognizer(thumbnailTapGesture)
        thumbnailImageView.isUserInteractionEnabled = true
    }

    private func setupUI() {
        view.backgroundColor = .white

        // MARK: - 레이아웃설정

        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }

        let contentView = UIView()

        // 제목 라벨
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(100)
            $0.left.equalTo(contentView).offset(20)
        }
        // 제목 텍스트 필드
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        contentView.addSubview(thumbnailLabel)
        thumbnailLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(200)
        }

        // 출시 플랫폼 라벨와 텍스트 필드
        contentView.addSubview(platformLabel)
        platformLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(platformTextField)
        platformTextField.snp.makeConstraints {
            $0.top.equalTo(platformLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        // 모집 기술 및 언어 라벨와 텍스트 필드
        contentView.addSubview(techLanguageLabel)
        techLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(platformTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(techLanguageTextField)
        techLanguageTextField.snp.makeConstraints {
            $0.top.equalTo(techLanguageLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        // 모집 분야 라벨와 텍스트 필드
        contentView.addSubview(recruitmentFieldLabel)
        recruitmentFieldLabel.snp.makeConstraints {
            $0.top.equalTo(techLanguageTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(recruitmentFieldTextField)
        recruitmentFieldTextField.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        // 프로젝트 소개 라벨와 텍스트뷰
        contentView.addSubview(projectIntroLabel)
        projectIntroLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(projectIntroTextView)
        projectIntroTextView.snp.makeConstraints {
            $0.top.equalTo(projectIntroLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(100)
        }

        // 프로젝트 시작 기간 라벨과 데이트 피커
        contentView.addSubview(projectStartDateLabel)
        projectStartDateLabel.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(projectStartDatePicker)
        projectStartDatePicker.snp.makeConstraints {
            $0.top.equalTo(projectStartDateLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(100)
        }

        // 프로젝트 종료 기간 라벨 2와 데이트 피커 2
        contentView.addSubview(projectEndDateLabel)
        projectEndDateLabel.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(projectStartDatePicker.snp.right).offset(150)
        }
        contentView.addSubview(projectEndDatePicker)
        projectEndDatePicker.snp.makeConstraints {
            $0.top.equalTo(projectEndDateLabel.snp.bottom).offset(10)
            $0.left.equalTo(projectStartDatePicker.snp.right).offset(150)
            $0.height.equalTo(100)
        }

        // 모집유형 라벨과 텍스트필드
        contentView.addSubview(meetingTypeLabel)
        meetingTypeLabel.snp.makeConstraints {
            $0.top.equalTo(projectEndDatePicker.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
        }

        contentView.addSubview(meetingTypeTextField)
        meetingTypeTextField.snp.makeConstraints {
            $0.top.equalTo(meetingTypeLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        // 연락방법 라벨과 텍스트필드
        contentView.addSubview(contactMethodLabel)
        contactMethodLabel.snp.makeConstraints {
            $0.top.equalTo(meetingTypeTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }

        contentView.addSubview(contactMethodTextField)
        contactMethodTextField.snp.makeConstraints {
            $0.top.equalTo(contactMethodLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        // 작성 완료 버튼
        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(contactMethodTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width - 20)
            $0.height.equalTo(30)
        }
        scrollView.addSubview(contentView)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(saveButton.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.bottom.equalTo(completeButton.snp.bottom).offset(20)
        }
    }

    // MARK: - 데이터 이동 함수

    @objc func completeButtonTapped() {
//        let projectInfo = Project(projectTitle: "", projecSubtitle: "",techStack: [], recruitmentCount: 1,projectDescription: "", projectID: UUID(), platform: [], teamMember: [])
//        projectRepository.create(project: projectInfo)
//        print("aaa")
        let projectTitle = titleTextField.text
        let platform = platformTextField.text
        let techLanguage = techLanguageTextField.text
        let recruitmentField = recruitmentFieldTextField.text
        let projectDescription = projectIntroTextView.text
        let meetingType = meetingTypeTextField.text
        let contactMethod = contactMethodTextField.text

        // DateFormatter를 사용하여 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let projectStartDate = dateFormatter.string(from: projectStartDatePicker.date)
        let projectEndDate = dateFormatter.string(from: projectEndDatePicker.date)

        let thumbnailImageURL = ""

        // Project 구조체에 데이터 할당
        let projectInfo = Project(
            projectTitle: projectTitle,
            projecSubtitle: nil,
            techStack: [],
            recruitmentCount: 1,
            projectDescription: projectDescription,
            projectDuration: "\(projectStartDate) - \(projectEndDate)",
            meetingType: meetingType,
            imageUrl: thumbnailImageURL,
            projectID: UUID(),
            platform: [.CarrierAppStore], // 이 부분을 필요에 따라 채워넣으세요
            recruitmentField: recruitmentField,
            recruitingStatus: true,
            teamMember: [],
            contactMethod: contactMethod
        )
        // Firebase에 데이터 업로드
        projectRepository.create(project: projectInfo)
    }

    func convertToEnum(rawValue: String) -> Platform? {
        return Platform(rawValue: rawValue)
    }

    // MARK: - 모달페이지함수

    @objc func platformTextFieldTapped() {
        // 출시 플랫폼 선택 뷰 컨트롤러를 표시
        let platformSelectionVC = PlatformSelectionViewController()
        platformSelectionVC.onPlatformSelected = { [weak self] platform in
            self?.platformTextField.text = platform
        }
        present(platformSelectionVC, animated: true, completion: nil)
    }

    // MARK: - 썸네일이미지피커

    @objc func thumbnailImageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // 이미지를 선택한 후 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            thumbnailImageView.image = selectedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

//     //MARK: - 미리보기

// struct NewPageViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPageViewControllerReprsentable().edgesIgnoringSafeArea(.all)
//    }
// }
//
// struct NewPageViewControllerReprsentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        return UINavigationController(rootViewController: NewPageViewController())
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//    typealias UIViewControllerType = UIViewController
// }

//
// extension UIColor {
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
//            blue: CGFloat(hex & 0x0000ff) / 255.0,
//            alpha: alpha
//        )
//    }
// }

// import UIKit
// import RxSwift
// import RxCocoa
//
// class NewPageViewController: UIViewController {
//    private let disposeBag = DisposeBag()
//    private let viewModel = NewPageViewModel()
//
////     뒤로가기 버튼
//        private let backButton = UIButton().then {
//            $0.setImage(UIImage(named: "backbutton"), for: .normal)
//            $0.imageView?.contentMode = .scaleAspectFit
//        }
//
//        // 임시저장 버튼
//        private let saveButton = UIButton().then {
//            $0.setTitle("임시저장", for: .normal)
//            $0.backgroundColor = UIColor(hex: 0x000000)
//            $0.layer.cornerRadius = 15
//            $0.setTitleColor(.white, for: .normal)
//        }
//
//        // 제목 라벨
//        private let titleLabel = UILabel().then {
//            $0.text = "제목"
//            $0.textColor = UIColor(hex: 0x000000)
//            $0.sizeToFit()
//        }
//
//        // 제목 텍스트필드
//        private let titleTextField = UITextField().then {
//            $0.placeholder = "제목"
//            $0.borderStyle = .roundedRect
//            $0.layer.cornerRadius = 8
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.black.cgColor
//            $0.backgroundColor = .white
//        }
//
//        // 썸네일 라벨
//        private let thumbnailLabel: UILabel = {
//            let label = UILabel()
//            label.text = "썸네일"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 200)
//            return label
//        }()
//
//        // 썸네일 텍스트뷰
//        private let thumbnailTextView: UITextView = {
//            let textView = UITextView()
//            textView.layer.cornerRadius = 8
//            textView.layer.borderWidth = 1
//            textView.layer.borderColor = UIColor.black.cgColor
//            textView.backgroundColor = .white
//            textView.frame = CGRect(x: 20, y: 250, width: UIScreen.main.bounds.width - 40, height: 100)
//            return textView
//        }()
//
//        // 출시 플랫폼 라벨
//        private let platformLabel: UILabel = {
//            let label = UILabel()
//            label.text = "출시 플랫폼"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 380)
//            return label
//        }()
//
//        // 출시 플랫폼 텍스트 필드
//        private let platformTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "출시 플랫폼"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 430, width: UIScreen.main.bounds.width - 40, height: 30)
////            textField.addTarget(self, action: #selector(showPlatformSelection), for: .touchDown) //
//            return textField
//        }()
//
//        // 모집 기술 및 언어 라벨
//        private let techLanguageLabel: UILabel = {
//            let label = UILabel()
//            label.text = "모집 기술 및 언어"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 560)
//            return label
//        }()
//
//        // 모집 기술 및 언어 텍스트 필드
//        private let techLanguageTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "모집 기술 및 언어"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 610, width: UIScreen.main.bounds.width - 40, height: 30)
//            return textField
//        }()
//
//        // 모집 분야 라벨
//        private let recruitmentFieldLabel: UILabel = {
//            let label = UILabel()
//            label.text = "모집 분야"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 660)
//            return label
//        }()
//
//        // 모집 분야 텍스트 필드
//        private let recruitmentFieldTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "모집 분야"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 710, width: UIScreen.main.bounds.width - 40, height: 30)
//            return textField
//        }()
//
//        // 프로젝트 소개 라벨
//        private let projectIntroLabel: UILabel = {
//            let label = UILabel()
//            label.text = "프로젝트 소개"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 760)
//            return label
//        }()
//
//        // 프로젝트 소개 텍스트뷰
//        private let projectIntroTextView: UITextView = {
//            let textView = UITextView()
//            textView.layer.cornerRadius = 8
//            textView.layer.borderWidth = 1
//            textView.layer.borderColor = UIColor.black.cgColor
//            textView.backgroundColor = .white
//            textView.frame = CGRect(x: 20, y: 810, width: UIScreen.main.bounds.width - 40, height: 100)
//            return textView
//        }()
//
//        // 프로젝트 기간 라벨
//        private let projectDateLabel: UILabel = {
//            let label = UILabel()
//            label.text = "프로젝트 기간"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 940)
//            return label
//        }()
//
//        // 프로젝트 기간 데이트 피커
//        private let projectDatePicker: UIDatePicker = {
//            let datePicker = UIDatePicker()
//            datePicker.datePickerMode = .date
//            datePicker.frame = CGRect(x: 20, y: 990, width: UIScreen.main.bounds.width - 40, height: 100)
//            return datePicker
//        }()
//
//        // 작성 완료 버튼
//        private let completeButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("작성 완료", for: .normal)
//            button.frame = CGRect(x: 10, y: 1000, width: UIScreen.main.bounds.width - 20, height: 30)
//            button.backgroundColor = UIColor(hex: 0x000000)
//            button.layer.cornerRadius = 15
//            button.setTitleColor(.white, for: .normal)
//            return button
//        }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        bindViewModel()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        // UI 요소들을 SnapKit을 사용하여 추가 및 레이아웃 설정 (생략)
//    }
//
//    private func bindViewModel() {
//        titleTextField.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
//        thumbnailTextView.rx.text.orEmpty.bind(to: viewModel.thumbnail).disposed(by: disposeBag)
//        platformTextField.rx.text.orEmpty.bind(to: viewModel.platform).disposed(by: disposeBag)
//        techLanguageTextField.rx.text.orEmpty.bind(to: viewModel.techLanguage).disposed(by: disposeBag)
//        recruitmentFieldTextField.rx.text.orEmpty.bind(to: viewModel.recruitmentField).disposed(by: disposeBag)
//        projectIntroTextView.rx.text.orEmpty.bind(to: viewModel.projectIntro).disposed(by: disposeBag)
//
//        // 프로젝트 날짜를 DatePicker에서 ViewModel로 바인딩
////        projectDatePicker.rx.date.bind(to: viewModel.projectDate).disposed(by: disposeBag)
//
//        // 저장 버튼 액션
//        saveButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.saveButtonTapped()
//            })
//            .disposed(by: disposeBag)
//    }
// }

// extension UIColor {
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
//            blue: CGFloat(hex & 0x0000ff) / 255.0,
//            alpha: alpha
//        )
//    }
// }
