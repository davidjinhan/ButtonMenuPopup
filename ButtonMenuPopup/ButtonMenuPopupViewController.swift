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
    
    struct CenterButtonPresenter: ImageButtonPresentable {
        var buttonImage = UIImage(named: "icon_plus_filled")!.withRenderingMode(.alwaysTemplate)
        var buttonTintColor: UIColor? {
            return .purple
        }
        var buttonBackgroundColor: UIColor = .white
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuButtonPopupProperties()
        setupMenuButton()
    }
    
    private func setupMenuButtonPopupProperties() {
        ButtonMenuPopupManager.shared.bottomHeight = tabBar.bounds.height
    }
    
    private func setupMenuButton() {
        let menuButton = UIButton(type: .custom)
        menuButton.configure(withPresenter: CenterButtonPresenter())
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: Constants.menuButtonWidth).isActive = true
        menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor).isActive = true
        
        tabBar.addSubview(menuButton)
        menuButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
        
        menuButton.rx.tap
            .bindNext {
                ButtonMenuPopupManager.shared.showOrHideActivityButtons()
            }.addDisposableTo(disposeBag)
    }
}
