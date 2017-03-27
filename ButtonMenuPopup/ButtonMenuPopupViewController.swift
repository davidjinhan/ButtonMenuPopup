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
    
    private var menuButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuButton()
        setupMenuButtonPopupProperties()
    }
    
    private func setupMenuButtonPopupProperties() {
        ButtonMenuPopupManager.shared.bottomHeight = tabBar.bounds.height
        ButtonMenuPopupManager.shared.showAnimation = { [weak self] in
            let buttonRotateTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            self?.menuButton.transform = buttonRotateTransform
        }
        ButtonMenuPopupManager.shared.hideAnimation = { [weak self] in
            self?.menuButton.transform = CGAffineTransform.identity
        }
    }
    
    private func setupMenuButton() {
        menuButton = UIButton(type: .custom)
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
