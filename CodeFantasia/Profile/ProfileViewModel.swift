//
//  ProfileViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/24.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit
import Firebase

final class ProfileViewModel {
    
    let fireBaseManager: FireBaseManager = FireBaseManager()
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var profileEditTapped: Driver<Void>
        var logoutTapped: Driver<Void>
        var withdrawTapped: Driver<Void>
        var followTapped: Driver<Void>
    }
    struct Output {
        var userDataFetched: Observable<UserProfile>
        var userAuthConfirmed: Driver<Bool>
        var profileEditDidTap: Driver<Void>
        var logoutDidTap: Driver<Void>
        var withdrawDidTap: Driver<String?>
        var followDidTap: Driver<Void>
    }
    let editMove = PublishSubject<Void>()
    let logoutComplete = PublishSubject<Void>()
    let deleteComplete = PublishSubject<Void>()
    let followComplete = PublishSubject<Void>()
    let unfollowComplete = PublishSubject<Void>()
    let isFollowing = PublishSubject<Bool>()
    let followUpdate = PublishSubject<[UserProfile]>()
    private let USER_REF = Firestore.firestore().collection("User")
    private let currentUser = Auth.auth().currentUser?.uid
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

        let userData = Observable.merge(
            input.viewDidLoad
        )
            .flatMapLatest { [weak self] _ in
                return self?.userRepository.read(userId: self?.userId ?? "") ?? .error( Error.self as! Error)
            }
            .share()
        userData
            .subscribe(onNext: { [weak self] user in
                self?.userProfile = user
            }, onError: { error in
            })
            .disposed(by: disposeBag)

        USER_REF.document(self.currentUser ?? "").getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                if let followingArray = document.data()?["following"] as? [String],
                   let userProfileID = self.userProfile?.userID {
                    let isFollowing = followingArray.contains(userProfileID)
                    print("1")
                    self.isFollowing.onNext(isFollowing)
                } else {
                    print("2")
                    self.isFollowing.onNext(false)
                }
            } else {
                print("3")
                self.isFollowing.onNext(false)
            }
        }
        
        followComplete.subscribe { [weak self] _ in
            self?.USER_REF.document(self?.currentUser ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var following = document.data()?["following"] as? [String] {
                        if !following.contains(self?.userProfile?.userID ?? "") {
                            following.append(self?.userProfile?.userID ?? "")
                            self?.USER_REF.document(self?.currentUser ?? "").setData(["following": following], merge: true) { error in
                                if let error = error {
                                    print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                                } else {
                                    print("데이터가 성공적으로 업데이트되었습니다.")
                                }
                            }
                        } else {
                        }
                    } else {
                        // blockIDs 필드가 없는 경우, 새로운 배열을 만들어서 selfWriterID를 추가합니다.
                        self?.USER_REF.document(self?.currentUser ?? "").setData(["following": [self?.userProfile?.userID]], merge: true) { error in
                            if let error = error {
                                print("데이터를 설정하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("데이터가 성공적으로 설정되었습니다.")
                            }
                        }
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            self?.USER_REF.document(self?.userProfile?.userID ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var followers = document.data()?["followers"] as? [String] {
                        if !followers.contains(self?.currentUser ?? "") {
                            followers.append(self?.currentUser ?? "")
                            self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": followers], merge: true) { error in
                                if let error = error {
                                    print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                                } else {
                                    print("데이터가 성공적으로 업데이트되었습니다.")
                                }
                            }
                        } else {
                        }
                    } else {
                        self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": [self?.currentUser ?? ""]], merge: true) { error in
                            if let error = error {
                                print("데이터를 설정하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("데이터가 성공적으로 설정되었습니다.")
                            }
                        }
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            self?.isFollowing.onNext(true)
            self?.followUpdate.onNext([self?.userProfile].compactMap { $0 })
        }
        .disposed(by: disposeBag)
        
        unfollowComplete.subscribe { [weak self] _ in
            self?.USER_REF.document(self?.currentUser ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var following = document.data()?["following"] as? [String] {
                        if let userProfileID = self?.userProfile?.userID, let index = following.firstIndex(of: userProfileID) {
                            following.remove(at: index)
                        }
                        self?.USER_REF.document(self?.currentUser ?? "").setData(["following": following], merge: true) { error in
                            if let error = error {
                                print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("데이터가 성공적으로 업데이트되었습니다.")
                            }
                        }
                    } else {
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            
            self?.USER_REF.document(self?.userProfile?.userID ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var followers = document.data()?["followers"] as? [String] {
                        if let userProfileID = self?.currentUser, let index = followers.firstIndex(of: userProfileID) {
                            followers.remove(at: index)
                        }
                        self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": followers], merge: true) { error in
                            if let error = error {
                                print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("데이터가 성공적으로 업데이트되었습니다.")
                            }
                        }
                    } else {
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
           self?.isFollowing.onNext(false)
            self?.followUpdate.onNext([self?.userProfile].compactMap { $0 })
        }
        .disposed(by: disposeBag)
        
        
        deleteComplete.subscribe { [weak self] _ in
            guard let self = self else { return }
            if let current = userProfile?.userID {
                self.userRepository.delete(userId: current)
                print("유저 프로필 삭제 완료")
                let firebaseManager:  FireBaseManagerProtocol = FireBaseManager()
                let userRepository = UserRepository(collectionId: "User", firebaseBaseManager: firebaseManager)
                userRepository.delete(userId: current)
                let db = Firestore.firestore()
                db.collection("Project").whereField("writerID", isEqualTo: current ).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                            print("유저 게시글 삭제 완료")
                        }
                    }
                }
            }
        }
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
            userAuthConfirmed: userData.map { [weak self] user in
                guard let currentAuthor = Auth.auth().currentUser?.uid else {
                    return false
                }
                return user.userID == currentAuthor
            }.asDriver(onErrorJustReturn: false),
            profileEditDidTap: input.profileEditTapped,
            logoutDidTap: input.logoutTapped,
            withdrawDidTap: input.withdrawTapped.map { [weak self] _ in
                self?.userProfile?.userID
            },
            followDidTap: input.followTapped
        )
    }
}

// let followButtonTapped = PublishSubject<Void>()
//            followButtonTapped,
//            followStatusChanged: isFollowing
//        input.followTapped.drive(onNext: { [weak self] in
//            self?.followButtonTapped.onNext(())
//        }).disposed(by: disposeBag)
        
//        Observable.merge(
//            followComplete.map { true },
//            unfollowComplete.map { false }
//        )
//        .observe(on: MainScheduler.instance)
//        .subscribe(onNext: { [weak self] isFollowing in
//            self?.isFollowing.onNext(isFollowing)
//        })
//        .disposed(by: disposeBag)
// var followStatusChanged: Observable<Bool>
