//
//  ProfileViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import UIKit

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
    let logoutComplete = PublishSubject<Void>()
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
        
        logoutComplete.subscribe { [weak self] _ in
            guard let self = self else { return }
            do {
                try Auth.auth().signOut()
                
                DispatchQueue.main.async {
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    fatalError("could not get scene delegate ")
                }
                    sceneDelegate.window?.rootViewController = TabBarController()
                }
                
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }
        .disposed(by: disposeBag)
        
        return Output(
            userDataFetched: userData,
            profileEditDidTap: input.profileEditTapped,
            logoutDidTap: input.logoutTapped
        )
    }
}
