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
        var userAuthConfirmed: Driver<Bool>
    }
    let editMove = PublishSubject<Void>()
    let logoutComplete = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryProtocol
    private let userId: String
    var userProfile: UserProfile?
    
    init(
        userRepository: UserRepositoryProtocol,
        userId: String
    ) {
        self.userRepository = userRepository
        self.userId = userId
    }
    
    func transform(input: Input) -> Output {
        let userData = input.viewDidLoad
            .flatMapLatest { [weak self] _ in
                return self?.userRepository.read(userId: self?.userId ?? "") ?? .error( Error.self as! Error)
            }
            .share()
        userData
            .subscribe(onNext: { [weak self] user in
                self?.userProfile = user
            }, onError: { error in
                // Handle the error as needed
            })
            .disposed(by: disposeBag)

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
            logoutDidTap: input.logoutTapped,
            userAuthConfirmed: userData.map { [weak self] user in
                guard let currentAuthor = Auth.auth().currentUser?.uid else {
                    return false
                }
                return user.userID == currentAuthor
            }.asDriver(onErrorJustReturn: false)
        )
    }
}
