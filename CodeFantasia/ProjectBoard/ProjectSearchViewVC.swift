//
//  ProjectSearchViewVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/23/23.
//

import UIKit
import SnapKit
import Then



class ProjectSearchViewVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, FilterBottomSheetDelegate {

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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        searchController.searchBar.backgroundImage = UIImage()
        
        if let filterImage = UIImage(systemName: "slider.vertical.3") {
            let filterButton = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(filterButtonTapped))
            navigationItem.rightBarButtonItem = filterButton
        }
        
        setupUI()

        if searchController.isActive {
            print("Search bar is active")
        } else {
            print("Search bar is not active")
        }
    }
    
    @objc func filterButtonTapped() {
        let filterVC = FilterBottomSheetVC()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        self.present(filterVC, animated: true, completion: nil)
    }

    func didApplyFilter(showOngoingProjectsOnly: Bool) {
        if showOngoingProjectsOnly {
            filteredData = mockData.filter { $0.status == "모집 중" }
        } else {
            filteredData = mockData
        }
        tableView.reloadData()
    }

    private func setupUI() {
        setupSearchController()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "제목 검색"
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        view.addSubview(searchController.searchBar)
        searchController.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchController.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
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
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
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

class HalfSizePresentationController: UIPresentationController {
    private var dimmingView: UIView?
    private var tapGestureRecognizer: UITapGestureRecognizer?

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView = UIView(frame: containerView.bounds)
        dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView?.alpha = 0.0
        containerView.insertSubview(dimmingView!, at: 0)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        dimmingView?.addGestureRecognizer(tapGestureRecognizer!)

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView?.alpha = 1.0
            return
        }

        coordinator.animate { _ in
            self.dimmingView?.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView?.alpha = 0.0
            return
        }

        coordinator.animate { _ in
            self.dimmingView?.alpha = 0.0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
            dimmingView = nil
        }
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}
