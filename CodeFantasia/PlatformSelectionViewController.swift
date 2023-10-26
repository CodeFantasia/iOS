//
//  TechLanguageSelectionViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/23.
//
import UIKit

class PlatformSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var onPlatformSelected: ((String) -> Void)?

    // 여기에 플랫폼 목록을 정의하세요.
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

    // 선택한 플랫폼을 저장할 Set
    var selectedPlatforms: Set<String> = []

    // 테이블 뷰를 생성
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
            view.backgroundColor = .white
            title = "플랫폼 선택"

            // 네비게이션 바를 숨기기
            navigationController?.isNavigationBarHidden = true

            // "선택 완료" 버튼을 모달 페이지 하단에 추가
            let completeButton = UIButton()
            completeButton.setTitle("선택 완료", for: .normal)
            completeButton.backgroundColor = .black
            completeButton.addTarget(self, action: #selector(selectComplete), for: .touchUpInside)
            view.addSubview(completeButton)

            completeButton.translatesAutoresizingMaskIntoConstraints = false
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            tableView.delegate = self
            tableView.dataSource = self
            view.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor).isActive = true
        }

    // "선택 완료" 버튼을 누를 때 호출될 메서드
    @objc func selectComplete() {
        let selectedItems = selectedPlatforms.map { $0 }
        onPlatformSelected?(selectedItems.joined(separator: "\n"))
        dismiss(animated: true, completion: nil)
    }

    // UITableViewDelegate 및 UITableViewDataSource 메서드 구현

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platforms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let platform = platforms[indexPath.row]
        cell.textLabel?.text = platform

        // 선택된 플랫폼의 표시 설정
        if selectedPlatforms.contains(platform) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlatform = platforms[indexPath.row]
        selectedPlatforms.insert(selectedPlatform)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedPlatform = platforms[indexPath.row]
        selectedPlatforms.remove(deselectedPlatform)
    }
}




