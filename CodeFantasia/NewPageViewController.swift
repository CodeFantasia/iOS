//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import SnapKit
import Then
import UIKit

class NewPageViewController: UIViewController {
    // 뒤로가기 버튼
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "backbutton"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }

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
        label.frame.origin = CGPoint(x: 20, y: 200)
        return label
    }()

    // 썸네일 텍스트뷰
    private let thumbnailTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        textView.frame = CGRect(x: 20, y: 250, width: UIScreen.main.bounds.width - 40, height: 100)
        return textView
    }()

    // 출시 플랫폼 라벨
    private let platformLabel: UILabel = {
        let label = UILabel()
        label.text = "출시 플랫폼"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 380)
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
        textField.frame = CGRect(x: 20, y: 430, width: UIScreen.main.bounds.width - 40, height: 30)
        textField.addTarget(self, action: #selector(showPlatformSelection), for: .touchDown) //
        return textField
    }()

    // 모집 기술 및 언어 라벨
    private let techLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 기술 및 언어"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 560)
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
        textField.frame = CGRect(x: 20, y: 610, width: UIScreen.main.bounds.width - 40, height: 30)
        return textField
    }()

    // 모집 분야 라벨
    private let recruitmentFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 분야"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 660)
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
        textField.frame = CGRect(x: 20, y: 710, width: UIScreen.main.bounds.width - 40, height: 30)
        return textField
    }()

    // 프로젝트 소개 라벨
    private let projectIntroLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 소개"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 760)
        return label
    }()

    // 프로젝트 소개 텍스트뷰
    private let projectIntroTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        textView.frame = CGRect(x: 20, y: 810, width: UIScreen.main.bounds.width - 40, height: 100)
        return textView
    }()

    // 프로젝트 기간 라벨
    private let projectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 기간"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 940)
        return label
    }()

    // 프로젝트 기간 데이트 피커
    private let projectDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 20, y: 990, width: UIScreen.main.bounds.width - 40, height: 100)
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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        // Back Button (뒤로가기 버튼)
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(30)
        }
        // Save Button (임시저장 버튼)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        // Title Label (제목 라벨)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(20)
        }
        // Title Text Field (제목 텍스트 필드)
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        // 썸네일 라벨와 텍스트뷰 SnapKit 설정
        view.addSubview(thumbnailLabel)
        thumbnailLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(thumbnailTextView)
        thumbnailTextView.snp.makeConstraints {
            $0.top.equalTo(thumbnailLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        // 출시 플랫폼 라벨와 텍스트 필드 SnapKit 설정
        view.addSubview(platformLabel)
        platformLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailTextView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(platformTextField)
        platformTextField.snp.makeConstraints {
            $0.top.equalTo(platformLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        // 모집 기술 및 언어 라벨와 텍스트 필드 SnapKit 설정
        view.addSubview(techLanguageLabel)
        techLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(platformTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(techLanguageTextField)
        techLanguageTextField.snp.makeConstraints {
            $0.top.equalTo(techLanguageLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        // 모집 분야 라벨와 텍스트 필드 SnapKit 설정
        view.addSubview(recruitmentFieldLabel)
        recruitmentFieldLabel.snp.makeConstraints {
            $0.top.equalTo(techLanguageTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(recruitmentFieldTextField)
        recruitmentFieldTextField.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        // 프로젝트 소개 라벨와 텍스트뷰 SnapKit 설정
        view.addSubview(projectIntroLabel)
        projectIntroLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(projectIntroTextView)
        projectIntroTextView.snp.makeConstraints {
            $0.top.equalTo(projectIntroLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        // 프로젝트 기간 라벨와 데이트 피커 SnapKit 설정
        view.addSubview(projectDateLabel)
        projectDateLabel.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        view.addSubview(projectDatePicker)
        projectDatePicker.snp.makeConstraints {
            $0.top.equalTo(projectDateLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        // 작성 완료 버튼 SnapKit 설정
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(projectDatePicker.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width - 20)
            $0.height.equalTo(30)
        }
    }

    @objc func showPlatformSelection() {
        let showPlatformSelectionVC = PlatformSelectionViewController() // 모달 뷰 컨트롤러 인스턴스 생성
        // 모달 페이지 표시 스타일 설정 (예: .popover)
        showPlatformSelectionVC.modalPresentationStyle = .popover
        // 모달 페이지 크기 및 위치 설정
        showPlatformSelectionVC.preferredContentSize = CGSize(width: 300, height: 400)
        if let popoverPresentationController = showPlatformSelectionVC.popoverPresentationController {
            popoverPresentationController.sourceView = techLanguageTextField
            popoverPresentationController.sourceRect = techLanguageTextField.bounds
            popoverPresentationController.permittedArrowDirections = .up
        }
        present(showPlatformSelectionVC, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000ff) / 255.0,
            alpha: alpha
        )
    }
}
