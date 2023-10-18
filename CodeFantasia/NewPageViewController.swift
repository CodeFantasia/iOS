//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import UIKit

class NewPageViewController: UIViewController {

    // 뒤로가기 버튼
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backbutton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 10, y: 40, width: 30, height: 30)
        return button
    }()

    // 임시저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("임시저장", for: .normal)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 110, y: 60, width: 100, height: 30)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // 제목 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y: 100)
        return label
    }()

    // 제목 텍스트 필드
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.width - 40, height: 30)
        return textField
    }()

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

        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(thumbnailLabel)
        view.addSubview(thumbnailTextView)
        view.addSubview(platformLabel)
        view.addSubview(platformTextField)
        // ... 다른 요소들 추가
        view.addSubview(completeButton)

        // 나머지 코드는 동일...
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
