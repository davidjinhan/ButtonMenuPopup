//
//  ButtonSettingsViewModel.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import Foundation
import RxSwift

class ButtonSettingViewModel {
    
    static let shared = ButtonSettingViewModel()
    
    var onSetting: Variable<Bool>!
    
    private let disposeBag = DisposeBag()
    
    private init() {
        onSetting = Variable(false)
    }
    
    func settingValueChange() {
        onSetting.value = !onSetting.value
    }
}
