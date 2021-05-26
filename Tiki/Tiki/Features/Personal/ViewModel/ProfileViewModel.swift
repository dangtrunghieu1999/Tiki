//
//  ProfileViewModel.swift
//  Tiki
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewModel {
    lazy var fullName    = BehaviorRelay<String?>(value: nil)
    lazy var firstName   = BehaviorRelay<String?>(value: nil)
    lazy var lastName    = BehaviorRelay<String?>(value: nil)
    lazy var gender      = BehaviorRelay<Int>(value: 0)
    lazy var email       = BehaviorRelay<String?>(value: nil)
    lazy var phone       = BehaviorRelay<String?>(value: nil)
    lazy var birthday    = BehaviorRelay<Date?>(value: nil)
    lazy var userProfile = BehaviorRelay<User?>(value: UserManager.currentUser)
    
    lazy var isEdit      = BehaviorRelay<Bool>(value: false)
    var updateProfilePS  = PublishSubject<Void>()
    var getProfilePS     = PublishSubject<Void>()
    
    var disposeBag       = DisposeBag()
    
    init() {

        userProfile.bind { [weak self] profile in
            self?.firstName.accept(profile?.firstName)
            self?.lastName.accept(profile?.lastName)
            self?.gender.accept(profile?.gender.rawValue ?? 0)
            self?.email.accept(profile?.email)
            self?.phone.accept(String(profile?.phone.dropFirst(2) ?? ""))
            self?.birthday.accept(profile?.birthDay)
        }.disposed(by: disposeBag)
        isEdit.skip(1).bind { [weak self] isNotFinished in
            guard !isNotFinished else { return }
            self?.updateProfilePS.onNext(())
        }.disposed(by: disposeBag)
        
        getProfilePS.onNext(())
    }
    
}
