//
//  ProfileViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    let fireBaseManager: FireBaseManager = FireBaseManager()
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var profileEditTapped: Driver<Void>
        var logoutTapped: Driver<Void>
    }
    struct Output {
        var userDataFetched: Observable<UserProfile>
        var profileEditDidTap: Driver<Void>
        var logoutDidTap: Driver<Void>
    }
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryProtocol
    private let userId: String
    
    init(
        userRepository: UserRepositoryProtocol,
        userId: String
    ) {
        self.userRepository = userRepository
        self.userId = userId
    }
    
    func transform(input: Input) -> Output {
        
        let userData = Observable<UserProfile>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            input.viewDidLoad
                .withUnretained(self)
                .subscribe { userId in
                self.userRepository.read(userId: self.userId)
                    .subscribe(onSuccess: { user in
                        observer.onNext(user)
                    }, onFailure: { error in
                        observer.onError(error)
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        return Output(
            userDataFetched: userData,
            profileEditDidTap: input.profileEditTapped,
            logoutDidTap: input.logoutTapped
        )
    }
}
