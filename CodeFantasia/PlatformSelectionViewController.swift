//
//  TechLanguageSelectionViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/23.
//

import UIKit

class PlatformSelectionViewController: UIViewController {

    // 체크박스를 보유하는 배열
    private var checkboxes: [UIStackView] = []

    // 출시 플랫폼 선택 완료 버튼
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택 완료", for: .normal)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        // 스크롤 뷰 추가
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // 출시 플랫폼 선택 항목 배열
        let platforms = [
            "iOS App Store (iOS 앱 출시)",
            "Google Play Store (Android 앱 출시)",
            "웹 애플리케이션 (웹 브라우저에서 실행)",
            "Windows Store (Windows 앱 출시)",
            "macOS App Store (macOS 앱 출시)",
            "Linux 배포 (Linux 앱 출시)",
            "PlayStation Store (PlayStation 게임 출시)",
            "Xbox Live Marketplace (Xbox 게임 출시)",
            "Nintendo eShop (Nintendo 게임 출시)",
            "Steam (PC 게임 출시)",
            "Oculus Store (가상 현실 앱 및 게임 출시)",
            "웹 확장 프로그램 스토어 (브라우저 확장 프로그램 출시)",
            "휴대폰 캐리어 앱 스토어 (특정 휴대폰 캐리어에 의한 앱 출시)"
        ]

        for platform in platforms {
            // 각 출시 플랫폼 체크박스를 생성
            let checkbox = createCheckbox(title: platform)
            checkboxes.append(checkbox)

            // 스크롤 뷰에 추가
            scrollView.addSubview(checkbox)
        }

        // Complete 버튼 추가
        scrollView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(checkboxes.last!.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(30)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-20)
        }

        // 스크롤 뷰 컨텐츠 사이즈 설정
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(checkboxes.count * 40 + 200))
    }

    private func createCheckbox(title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10

        let checkbox = UISwitch()
        stackView.addArrangedSubview(checkbox)

        let label = UILabel()
        label.text = title
        stackView.addArrangedSubview(label)

        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        return stackView
    }

    // Complete 버튼 액션 처리 (체크된 항목을 출시 플랫폼 텍스트 필드에 추가)
    @objc func completeButtonTapped() {
        var selectedPlatforms: [String] = []
        for (index, checkbox) in checkboxes.enumerated() {
            if let switchView = checkbox.subviews.first as? UISwitch, switchView.isOn {
                selectedPlatforms.append("항목 \(index + 1)")
            }
        }

        // 선택된 항목을 텍스트 필드에 표시
//        platformTextField.text = selectedPlatforms.joined(separator: ", ")

        // 모달 닫기
        dismiss(animated: true, completion: nil)
    }
}

