//
//  FollowViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/11/15.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit
import Firebase

final class FollowViewModel {
    struct Input {
        var viewDidLoad: Observable<Void>
    }
    struct Output {
        var userDataFetched: Observable<[UserProfile]>
    }
    private let USER_REF = Firestore.firestore().collection("User")
    private let currentUser = Auth.auth().currentUser?.uid
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryProtocol
    private let userId: String
    var userProfile: [UserProfile]?
    var followType: String?

    init(
        userRepository: UserRepositoryProtocol,
        userId: String
    ) {
        self.userRepository = userRepository
        self.userId = userId
    }
    
    func transform(input: Input) -> Output {
//        let userData = input.viewDidLoad
//            .startWith(())
//            .flatMapLatest { [weak self] _ -> Observable<[UserProfile]> in
//                guard let self = self else { return Observable.empty() }
//                print("유저 데이터 가져오는 중...")
//                print("\(String(describing: followType))")
//
//                if self.followType == "followers" {
//                    return self.userRepository.readFollowerUsers(userId: self.userId)
//                } else {
//                    return self.userRepository.readFollowingUsers(userId: self.userId)
//                }
//            }
//                    .share()
        let userData = input.viewDidLoad
            .startWith(())
            .flatMapLatest { [weak self] _ -> Observable<[UserProfile]> in
                guard let self = self else { return Observable.empty() }
                print("유저 데이터 가져오는 중...")
                print("\(String(describing: followType))")

                if self.followType == "followers" {
                    return self.userRepository.readFollowerUsers(userId: self.userId)
                } else {
                    return self.userRepository.readFollowingUsers(userId: self.userId)
                }
            }
            .observe(on: MainScheduler.instance) // MainScheduler에서 작업을 수행하도록 설정
            .share()
                userData
                    .subscribe(onNext: { [weak self] user in
                        self?.userProfile = user
                        print("User data updated: \(user)")
                    }, onError: { error in
                        // 에러 처리 로직을 수행합니다.
                    })
                    .disposed(by: disposeBag)
                
                return Output(
                    userDataFetched: userData
                )
            
    }
}

