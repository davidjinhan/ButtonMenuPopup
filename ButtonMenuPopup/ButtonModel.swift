//
//  ButtonModel.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import Foundation
import RxSwift

enum ButtonType {
    case fruit, vegetable
    
    var buttonStrings: [String] {
        switch self {
        case .fruit:
            return [
                "citrus", "pear", "apple", "avocado", "banana"
            ]
        case .vegetable:
            return [
                "corn", "tomato", "mushroom", "carrot"
            ]
        }
    }
}

struct ButtonModel {
    var buttonImage: UIImage
    var buttonTitle: String
    var type: ButtonType
    var isVisible: Variable<Bool>
    
    init(image: String, title: String, type: ButtonType, isVisible: Bool = true) {
        self.buttonImage = UIImage(named: image)!.withRenderingMode(.alwaysTemplate)
        self.buttonTitle = title
        self.type = type
        self.isVisible = Variable(isVisible)
    }
}

extension ButtonModel: Equatable {
    
}

func == (lhs: ButtonModel, rhs: ButtonModel) -> Bool {
    return (lhs.buttonTitle == rhs.buttonTitle)
}
