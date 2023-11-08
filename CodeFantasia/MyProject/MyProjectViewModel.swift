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
import FirebaseAuth

final class MyProjectViewModel {
    
    struct Input {
        var viewDidLoad: Observable<Void>
    }
    struct Output {
        var projectDataFetched: Observable<Project>
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
            projectDataFetched: projectData.flatMap { Observable.from($0) }
        )
    }
    
    // 프로젝트 데이터가 갱신될 때마다 방출할 Subject를 선언합니다.
    let projectDataFetched = PublishSubject<[Project]>()
    
    // MyProjectViewModel.swift 내에 추가
    func fetchData() {
        let currentAuthor = Auth.auth().currentUser?.uid
        projectRepository.readAll()
            .subscribe(onSuccess: { [weak self] projects in
                guard let self = self else { return }
                let filteredProjects = projects.filter { $0.writerID == currentAuthor }
                // 여기서는 각 프로젝트를 개별적으로 방출하는 대신 프로젝트 배열 전체를 방출합니다.
                self.projectDataFetched.onNext(filteredProjects)
            }, onError: { error in
                // 에러 처리를 위해 필요한 경우 여기에 코드를 추가합니다.
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }


}
