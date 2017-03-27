//
//  ButtonViewModel.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import Foundation
import RxSwift

class ButtonViewModel {
    
    var buttonModels: Variable<[ButtonModel]>!
    
    var enabledButtons: [ButtonModel] {
        return buttonModels.value.filter { $0.isVisible.value }
    }
    
    private let disposeBag = DisposeBag()
    
    let type: ButtonType
    
    init(type: ButtonType) {
        self.type = type
    
        setupActivityButtonModels()
    }
    
    private func setupActivityButtonModels() {
        // TODO: setup from user defaults
        let format = type == .fruit ? "icon_fruit_%@" : "icon_vegetable_%@"
        let buttonColor = type == .fruit ? UIColor(red: 117 / 255, green: 118 / 255, blue: 179 / 255, alpha: 1.0) : UIColor(red: 86 / 255, green: 191 / 255, blue: 244 / 255, alpha: 1.0)
        let models = type.buttonStrings.map { ButtonModel(image: String(format: format, $0), title: $0, color: buttonColor, type: type) }
        self.buttonModels = Variable(models)
    }
    
    func saveButtonSequence(fromSourceIndex sourceIndex: Int, destinationIndex: Int) {
        var array = buttonModels.value
        let source = array[sourceIndex]
        array.remove(at: sourceIndex)
        array.insert(source, at: destinationIndex)
        buttonModels.value = array
    }
    
    func confirmCurrentButtonSettings() {
        // TODO
    }
    
    func cancelCurrentButtonSettings() {
        // TODO
    }
}
