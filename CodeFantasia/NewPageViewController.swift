//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import SnapKit
// import SwiftUI
import Then
import UIKit

class NewPageViewController: UIViewController {
    // MARK: - 변수선언

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

    // 썸네일 텍스트뷰
    private let thumbnailTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        return textView
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

    // 프로젝트 기간 라벨1
    let projectDateLabel1: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 시작일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 프로젝트 기간 라벨2
    let projectDateLabel2: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 종료일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()

    // 프로젝트 기간 데이트 피커1
    let projectDatePicker1: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    // 프로젝트 기간 데이트 피커2
    let projectDatePicker2: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    // 작성 완료 버튼
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        button.frame = CGRect(x: 10, y: 1000, width: UIScreen.main.bounds.width - 20, height: 30)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        // Title Label (제목 라벨)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(100)
            $0.left.equalTo(contentView).offset(20)
        }
        // Title Text Field (제목 텍스트 필드)
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
        contentView.addSubview(thumbnailTextView)
        thumbnailTextView.snp.makeConstraints {
            $0.top.equalTo(thumbnailLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(100)
        }

        // 출시 플랫폼 라벨와 텍스트 필드 SnapKit 설정
        contentView.addSubview(platformLabel)
        platformLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailTextView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(platformTextField)
        platformTextField.snp.makeConstraints {
            $0.top.equalTo(platformLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }

        // 모집 기술 및 언어 라벨와 텍스트 필드 SnapKit 설정
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

        // 모집 분야 라벨와 텍스트 필드 SnapKit 설정
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

        // 프로젝트 소개 라벨와 텍스트뷰 SnapKit 설정
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

        // 프로젝트 기간 라벨 1과 데이트 피커 1 SnapKit 설정
        contentView.addSubview(projectDateLabel1)
        projectDateLabel1.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(projectDatePicker1)
        projectDatePicker1.snp.makeConstraints {
            $0.top.equalTo(projectDateLabel1.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(100)
        }

        // 프로젝트 기간 라벨 2와 데이트 피커 2 SnapKit 설정
        contentView.addSubview(projectDateLabel2)
        projectDateLabel2.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(projectDatePicker1.snp.right).offset(150) // 첫 번째 데이트 피커의 오른쪽에서 20pt 이동
        }
        contentView.addSubview(projectDatePicker2)
        projectDatePicker2.snp.makeConstraints {
            $0.top.equalTo(projectDateLabel2.snp.bottom).offset(10)
            $0.left.equalTo(projectDatePicker1.snp.right).offset(150) // 첫 번째 데이트 피커의 오른쪽에서 20pt 이동
            $0.height.equalTo(100)
        }

        // 작성 완료 버튼 SnapKit 설정
        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(projectDatePicker2.snp.bottom).offset(20)
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
        // 사용자가 입력한 정보 가져오기
        let title = titleTextField.text ?? ""
        let thumbnail = thumbnailTextView.text ?? ""
        let platform = platformTextField.text ?? ""
        let techAndLanguage = techLanguageTextField.text ?? ""
        let recruitmentField = recruitmentFieldTextField.text ?? ""
        let projectDescription = projectIntroTextView.text ?? ""
        let projectStartDate = projectDatePicker1.date
        let projectEndDate = projectDatePicker2.date

        // Project 구조체 인스턴스 생성
        let project = Project(
            techStack: [], // 여기에 사용자가 선택한 기술 스택을 넣으세요.
            recruitmentCount: 0, // 여기에 사용자가 입력한 모집 인원 수를 넣으세요.
            projectDescription: projectDescription,
            projectDuration: "\(projectStartDate) ~ \(projectEndDate)",
            meetingType: nil, // 사용자가 선택한 회의 유형을 넣으세요.
            imageUrl: nil, // 이미지 URL을 넣으세요.
            projectID: UUID(),
            platform: [], // 여기에 사용자가 선택한 플랫폼을 넣으세요.
            recruitmentField: recruitmentField
        )
        print(project)
        // 이제 `project` 구조체를 적절한 위치로 저장하거나 활용하실 수 있습니다.
        // 예를 들어, 이를 데이터베이스에 저장하거나 다른 뷰 컨트롤러로 전달할 수 있습니다.
    }
}

//    @objc func showPlatformSelection() {
//        let platformSelectionVC = PlatformSelectionViewController()
//
//        // platformTextField를 설정합니다.
//        platformSelectionVC.platformTextField = platformTextField
//
//        // 모달 뷰 컨트롤러를 표시합니다.
//        present(platformSelectionVC, animated: true, completion: nil)
//    }
// }

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
