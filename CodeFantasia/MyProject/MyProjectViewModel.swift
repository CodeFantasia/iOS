//
//  MyProjectViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

final class MyProjectViewModel {
    
    struct Input {
        var viewDidLoad: Observable<Void>
    }
    struct Output {
        var projectDataFetched: Observable<Project>
        var userAuthConfirmed: Driver<Bool>
    }
    private let disposeBag = DisposeBag()
    let projectRepository: ProjectRepositoryProtocol

    init(
        projectRepository: ProjectRepositoryProtocol
    ) {
        self.projectRepository = projectRepository
    }
    
    func transform(input: Input) -> Output {
        let currentAuthor = Auth.auth().currentUser?.uid
        let projectData = Observable<[Project]>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            input.viewDidLoad
                .subscribe { _ in
                    self.projectRepository.readAll()
                        .subscribe(onSuccess: { projects in
                            let filteredProjects = projects.filter { $0.writerID == currentAuthor }
                            observer.onNext(filteredProjects)
                        }, onError: { error in
                            observer.onError(error)
                        })
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }

        return Output(
            projectDataFetched: projectData.flatMap { Observable.from($0) },
            userAuthConfirmed: projectData.map { [weak self] project in
                guard let self else {
                    return false // Handle the case where currentAuthor is nil
                }
                return true
            }.asDriver(onErrorJustReturn: false)
        )
    }
}
