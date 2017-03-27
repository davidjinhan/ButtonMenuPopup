//
//  ButtonMenuPopupViewController.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ButtonMenuPopupViewController: UITabBarController {

    enum Constants {
        static let menuButtonWidth: CGFloat = 44
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuButton()
    }
    
    private func setupMenuButton() {
        let menuButton = UIButton(type: .custom)
        let plusIcon = UIImage(named: "icon_plus_filled")?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(plusIcon, for: .normal)
        menuButton.setTitle(nil, for: .normal)
        menuButton.tintColor = .purple
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: Constants.menuButtonWidth).isActive = true
        menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor).isActive = true
        
        tabBar.addSubview(menuButton)
        menuButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
    }
}
