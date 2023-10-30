//
//  ProjectSearchViewVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/23/23.
//

import UIKit
import SnapKit
import Then

class ProjectSearchViewVC: UIViewController {
    private let tableView = UITableView().then {
        $0.register(ProjectBoardTableviewCell.self, forCellReuseIdentifier: "ProjectBoardCell")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    private var filteredData: [(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String, projectID: UUID)]
    private let searchController = UISearchController(searchResultsController: nil)
    var mockData: [(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String, projectID: UUID)]
    
    init(mockData: [(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String, projectID: UUID)]) {
        self.mockData = mockData
        self.filteredData = mockData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if searchController.isActive {
            print("Search bar is active")
        } else {
            print("Search bar is not active")
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupSearchController()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "제목 검색"
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProjectSearchViewVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectBoardCell", for: indexPath) as! ProjectBoardTableviewCell
        let dataItem = filteredData[indexPath.row]
        
        cell.recruitmentLabelCheck(imageURL: dataItem.imageURL, title: dataItem.title, detail: dataItem.detail, icons: dataItem.icons, status: dataItem.status)
        
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

// MARK: - UISearchResultsUpdating
extension ProjectSearchViewVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

// MARK: - UISearchBarDelegate
extension ProjectSearchViewVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredData = mockData.filter { $0.title.contains(searchText) }
            tableView.reloadData()
        } else {
            filteredData = mockData
            tableView.reloadData()
        }
    }
}
