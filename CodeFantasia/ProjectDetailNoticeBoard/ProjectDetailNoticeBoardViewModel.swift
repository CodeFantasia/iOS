//
//  ProjectDetailNoticeBoardViewModel.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/23.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectDetailNoticeBoardViewModel {
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var editImageTapped: Driver<Void>
        var profileImageTapped: Driver<Void>
        var projectApplyButtonTapped: Driver<Void>
        var projectReportButtonTapped: Driver<Void>
    }
    struct Output {
        var projectDataFetched: Observable<Project>
        var projectApplyButtonDidTap: Driver<Void>
        var projectLeaderProfileDidTap: Driver<Void>
        var projectEditButtonDidTap: Driver<Void>
        var projectReportButtonDidTap: Driver<Void>
//        var projectApplySuccess: Observable<Void>
//        var projectApplyFail: Observable<Void>
//        var projectReportSuccess: Observable<Void>
//        var projectReportFail: Observable<Void>
    }
    let projectApplyComplete = PublishSubject<Void>()
    let projectReportComplete = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let projectRepository: ProjectRepositoryProtocol
    private let projectId: String
    
    init(
        projectRepository: ProjectRepositoryProtocol,
        projectId: String
    ) {
        self.projectRepository = projectRepository
        self.projectId = projectId
    }
    
    func transform(input: Input) -> Output {
        
        let projectData = Observable<Project>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            input.viewDidLoad
                .subscribe { projectId in
                    self.projectRepository.read(projectId: self.projectId)
                        .subscribe(onSuccess: { project in
                            observer.onNext(project)
                        }, onFailure: { error in
                            observer.onError(error)
                        })
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        
        //TODO: - apply, report 기능 추가
        projectApplyComplete.subscribe { _ in

        }
        .disposed(by: disposeBag)
        
        projectReportComplete.subscribe { _ in
            
        }
        .disposed(by: disposeBag)
        
        return Output(
            projectDataFetched: projectData,
            projectApplyButtonDidTap: input.projectApplyButtonTapped,
            projectLeaderProfileDidTap: input.profileImageTapped,
            projectEditButtonDidTap: input.editImageTapped,
            projectReportButtonDidTap: input.projectReportButtonTapped
        )
    }
}
