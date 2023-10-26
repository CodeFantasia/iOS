//
//  MyProjectViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class MyProjectViewModel {
    
    struct Input {
        var viewDidLoad: Observable<Void>
    }
    struct Output {
        var projectDataFetched: Observable<Project>
    }
    private let disposeBag = DisposeBag()
     let projectRepository: ProjectRepositoryProtocol
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
        
        return Output(
            projectDataFetched: projectData
        )
    }
}
