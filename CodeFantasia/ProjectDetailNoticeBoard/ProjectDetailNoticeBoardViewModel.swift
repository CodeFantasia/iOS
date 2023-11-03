//
//  ProjectDetailNoticeBoardViewModel.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

final class ProjectDetailNoticeBoardViewModel {
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var profileImageTapped: Driver<Void>
        var projectApplyButtonTapped: Driver<Void>
        var projectReportButtonTapped: Driver<Void>
    }
    struct Output {
        var projectDataFetched: Observable<Project>
        var projectApplyButtonDidTap: Driver<String?>
        var projectLeaderProfileDidTap: Driver<Int?>
        var projectReportButtonDidTap: Driver<Void>
        var userAuthConfirmed: Driver<Bool>
//        var projectApplySuccess: Observable<Void>
//        var projectApplyFail: Observable<Void>
//        var projectReportSuccess: Observable<Void>
//        var projectReportFail: Observable<Void>
    }
    let projectDeleteComplete = PublishSubject<Void>()
    let projectApplyComplete = PublishSubject<Void>()
    let projectReportComplete = PublishSubject<Void>()
    let projectEditComplete = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let projectRepository: ProjectRepositoryProtocol
    private let projectId: String
    var project: Project?
    
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
                            self.project = project
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
        
        projectDeleteComplete.subscribe { _ in
            self.projectRepository.delete(projectId: self.projectId)
        }
        .disposed(by: disposeBag)
        
        projectEditComplete.subscribe { _ in
            self.projectRepository.update(project: self.project!)
        }
        .disposed(by: disposeBag)
        
        return Output(
            projectDataFetched: projectData,
            projectApplyButtonDidTap: input.projectApplyButtonTapped.map { [weak self] _ in
                self?.project?.contactMethod
            },
            projectLeaderProfileDidTap: input.profileImageTapped.map { [weak self] _ in
                self?.project?.teamMember.first(where: {$0.category == Role(detailRole: "leader")})?.employeeID
            },
            projectReportButtonDidTap: input.projectReportButtonTapped,
            
            userAuthConfirmed: projectData.map { [weak self] project in
                guard let currentAuthor = Auth.auth().currentUser?.uid else {
                    return false // Handle the case where currentAuthor is nil
                }
                
                return project.writerID == currentAuthor
            }.asDriver(onErrorJustReturn: false)
        )
    }
}
