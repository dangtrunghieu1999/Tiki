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
    lazy var isLoading   = BehaviorRelay<Bool>(value: false)
    lazy var fullName    = BehaviorRelay<String?>(value: nil)
    lazy var firstName   = BehaviorRelay<String?>(value: nil)
    lazy var lastName    = BehaviorRelay<String?>(value: nil)
    lazy var picture     = BehaviorRelay<String?>(value: nil)
    lazy var gender      = BehaviorRelay<Int>(value: 0)
    lazy var email       = BehaviorRelay<String?>(value: nil)
    lazy var phone       = BehaviorRelay<String?>(value: nil)
    lazy var birthday    = BehaviorRelay<Date?>(value: nil)
    lazy var userProfile = BehaviorRelay<User?>(value: UserManager.currentUser)
    
    lazy var isEdit      = BehaviorRelay<Bool>(value: false)
    var updateProfilePS  = PublishSubject<Void>()
    var getProfilePS     = PublishSubject<Void>()
    lazy var error       = BehaviorRelay<ServiceErrorAPI?>(value: nil)
    var disposeBag       = DisposeBag()
    
    init() {
        setupUpdateProfilePS()
        setupGetProfilePS()
        userProfile.bind { [weak self] profile in
            self?.firstName.accept(profile?.firstName)
            self?.lastName.accept(profile?.lastName)
            self?.picture.accept(profile?.pictureURL)
            self?.gender.accept(profile?.gender.rawValue ?? 0)
            self?.email.accept(profile?.email)
            self?.phone.accept(profile?.phone)
            self?.birthday.accept(profile?.birthDay)
        }.disposed(by: disposeBag)
        isEdit.skip(1).bind { [weak self] isNotFinished in
            guard !isNotFinished else { return }
            self?.updateProfilePS.onNext(())
        }.disposed(by: disposeBag)
        
        getProfilePS.onNext(())
    }
    
    func setupUpdateProfilePS() {
        updateProfilePS.do(onNext: { [weak self] in
            guard let self = self else { return }
            guard self.profileIsEdited() else { return }
            self.isLoading.accept(true)
            let updateInfo = UserSessionManager
                .UpdateProfileRequest(firstName: self.firstName.value,
                                      lastName: self.lastName.value,
                                      gender: Gender(rawValue: self.gender.value),
                                      phone: self.phone.value,
                                      email: self.email.value,
                                      birthday: self.birthday.value?.toString(.ddMMyyyy))
            let endPoint = UserEndPoint.updateInfo(bodyParams: updateInfo.parameters)
            
            APIService.request(endPoint: endPoint) { (apiResponse) in
                self.getProfilePS.onNext(())
            } onFailure: { (error) in
                self.error.accept(error)
            } onRequestFail: {
                
            }
        }).subscribe().disposed(by: disposeBag)
    }
    
    func setupGetProfilePS() {
        getProfilePS.do(onNext: {
            UserManager.getUserProfile()
        }).subscribe().disposed(by: disposeBag)
    }
    
    private func profileIsEdited() -> Bool {
        let user      = UserManager.currentUser
        let firstName = self.firstName.value != user?.firstName ? self.firstName.value : nil
        let lastName  = self.lastName.value  != user?.lastName  ? self.lastName.value  : nil
        let phone     = self.phone.value     != user?.phone     ? self.phone.value     : nil
        let email     = self.email.value     != user?.email     ? self.email.value     : nil
        let birthday  = self.birthday.value?.toString(.yyyyMMdd) != user?.birthDay?.toString(.yyyyMMdd) ? self.birthday.value : nil
        let genderRawvalue = self.gender.value != user?.gender.rawValue ? self.gender.value : nil
        let gender = genderRawvalue != nil ? Gender(rawValue: genderRawvalue!) : nil
        let updateInfo = UserSessionManager.UpdateProfileRequest(firstName: firstName,
                                                                 lastName: lastName,
                                                                 gender: gender,
                                                                 phone: phone,
                                                                 email: email,
                                                                 birthday: birthday?.toString(.ddMMyyyy))
        return !updateInfo.parameters.isEmpty
    }
}
