//
//  TechLanguageSelectionViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/23.
//
import UIKit
import SnapKit

class PlatformSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var onPlatformSelected: ((String) -> Void)?

    // 출시 플랫폼 열거형을 사용한 플랫폼 목록
    let platforms: [Platform] = [
        .iOSAppStore,
        .GooglePlayStore,
        .WebApplication,
        .WindowsStore,
        .MacOSAppStore,
        .LinuxDistribution,
        .PlayStationStore,
        .XboxLiveMarketplace,
        .NintendoEshop,
        .Steam,
        .OculusStore,
        .WebExtensionStore,
        .CarrierAppStore
    ]

    // 선택한 플랫폼을 저장할 Set
    var selectedPlatforms: Set<Platform> = []

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
        navigationController?.isNavigationBarHidden = true

        let completeButton = UIButton()
        completeButton.setTitle("선택 완료", for: .normal)
        completeButton.backgroundColor = .black
        completeButton.addTarget(self, action: #selector(selectComplete), for: .touchUpInside)
        completeButton.layer.cornerRadius = 10.0
        view.addSubview(completeButton)

        completeButton.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view).offset(10)
            $0.right.equalTo(view).offset(-10)

        }

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(completeButton.snp.top)
        }
    }

    @objc func selectComplete() {
        let selectedItems = selectedPlatforms.map { $0.rawValue }
        let selectedItemsString = selectedItems.joined(separator: " / ") // '/'로 구분
        onPlatformSelected?(selectedItemsString)
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platforms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let platform = platforms[indexPath.row]
        cell.textLabel?.text = platform.rawValue

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


