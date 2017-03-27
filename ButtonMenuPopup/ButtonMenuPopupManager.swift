//
//  ButtonMenuPopupManager.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ButtonMenuPopupManager: NSObject {
    
    static let shared = ButtonMenuPopupManager()
    
    // MARK: - Presenters
    
    struct MenuSettingButton: ImageButtonPresentable {
        var buttonImage = UIImage(named: "icon_settings_filled")!.withRenderingMode(.alwaysTemplate)
        var buttonTintColor: UIColor? {
            return .darkGray
        }
        var buttonBackgroundColor: UIColor = .white
        var cornerRadius: CGFloat? = 20
    }
    
    // MARK: - Constants
    
    enum ViewConstants {
        static let maskBackgroundColor = UIColor.black
        static let maskBackgroundOpacity: CGFloat = 0.5
        static let dropdownAnimationDuration = 0.4
        static let settingAnimationDuration = 0.25
        
        static let settingButtonSize: CGFloat = 40
        static let settingButtonTop: CGFloat = 36
        static let settingButtonTrailing: CGFloat = 18
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    var bottomHeight: CGFloat = 0 {
        didSet {
            menuWrapper.frame = menuWrapperBounds
        }
    }
    
    private let window = UIApplication.shared.delegate!.window!!
    private var menuWrapperBounds: CGRect {
        var bounds = window.bounds
        bounds.size.height -= (bottomHeight + 0.5)
        return bounds
    }
    
    private var backgroundView: UIView!
    private var visualEffectView: UIVisualEffectView!
    private var menuWrapper: UIView!
    private var isShown = false
    
    private var settingButton: UIButton!
    private var settingButtonHideConstraint: NSLayoutConstraint!
    private var settingButtonShowConstraint: NSLayoutConstraint!
    
    private var containerView: UIView!
    private var butttonsPageView: ButtonsPageView!
    
    private var containerViewHideConstraint: NSLayoutConstraint!
    private var containerViewShowConstraint: NSLayoutConstraint!
    
    var showAnimation: (() -> Void)?
    var hideAnimation: (() -> Void)?
    
    // MARK: - Setup
    
    private override init() {
        super.init()
        
        setupBackground()
        setupSettingButton()
        setupContainerView()
        setupSettingViewModel()
    }
    
    // MARK: - Selectors
    
    func pauseBlurAnimation() {
        visualEffectView.pauseAnimation(delay: ViewConstants.dropdownAnimationDuration * 0.27)
    }
    
    // MARK: - Helper Methods
    
    private func setupSettingViewModel() {
        
    }
    
    private func setupSettingButton() {
        settingButton = UIButton(type: .custom)
        settingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // TODO: settingViewModel actions
            })
            .addDisposableTo(disposeBag)
        
        let settingButtonPresenter = MenuSettingButton()
        settingButton.configure(withPresenter: settingButtonPresenter)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        menuWrapper.addSubview(settingButton)
        
        settingButton.widthAnchor.constraint(equalToConstant: ViewConstants.settingButtonSize).isActive = true
        settingButton.heightAnchor.constraint(equalTo: settingButton.widthAnchor, multiplier: 1.0).isActive = true
        
        // centerX
        settingButton.trailingAnchor.constraint(equalTo: menuWrapper.trailingAnchor, constant: -ViewConstants.settingButtonTrailing).isActive = true
        
        // centerY
        settingButtonHideConstraint = settingButton.bottomAnchor.constraint(equalTo: menuWrapper.topAnchor)
        settingButtonShowConstraint = settingButton.topAnchor.constraint(equalTo: menuWrapper.topAnchor, constant: ViewConstants.settingButtonTop)
        settingButtonHideConstraint.isActive = true
    }
    
    private func setupBackground() {
        isShown = false
        
        menuWrapper = UIView(frame: CGRect(x: menuWrapperBounds.origin.x, y: 0, width: menuWrapperBounds.width, height: menuWrapperBounds.height))
        menuWrapper.clipsToBounds = true
        menuWrapper.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        
        visualEffectView = UIVisualEffectView(frame: menuWrapperBounds)
        visualEffectView.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        
        backgroundView = UIView(frame: menuWrapperBounds)
        backgroundView.backgroundColor = ViewConstants.maskBackgroundColor
        backgroundView.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        
        menuWrapper.addSubview(visualEffectView)
        menuWrapper.addSubview(backgroundView)
        
        window.addSubview(self.menuWrapper)
        
        // By default, hide menu view
        menuWrapper.isHidden = true
    }
    
    private func setupButtonsPageView() {
        butttonsPageView = ButtonsPageView()
        butttonsPageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(butttonsPageView)
        
        butttonsPageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        butttonsPageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        butttonsPageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        butttonsPageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        butttonsPageView.confirmButtons(show: false)
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        menuWrapper.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: menuWrapper.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: menuWrapper.trailingAnchor).isActive = true
        containerViewShowConstraint = containerView.bottomAnchor.constraint(equalTo: menuWrapper.bottomAnchor)
        containerViewHideConstraint = containerView.topAnchor.constraint(equalTo: menuWrapper.bottomAnchor)
        containerViewHideConstraint.isActive = true
        
        setupButtonsPageView()
    }
    
    private func hideMenu(withCompletion completion: (() -> Void)? = nil) {
        guard isShown else { return }
        
        isShown = false
        
        backgroundView.alpha = ViewConstants.maskBackgroundOpacity
        visualEffectView.isHidden = true
        visualEffectView.removeFromSuperview()
        visualEffectView = UIVisualEffectView(frame: menuWrapperBounds)
        visualEffectView.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        menuWrapper.insertSubview(visualEffectView, belowSubview: backgroundView)
        
        UIView.animate(
            withDuration: ViewConstants.dropdownAnimationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { [weak self] in
                self?.hideAnimation?()
                self?.settingButton(show: false)
                self?.containerView(show: false)
            }, completion: { [weak self] _ in
                // TODO: setting mode false
                completion?()
        })
        
        // Animation
        UIView.animate(
            withDuration: ViewConstants.dropdownAnimationDuration,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.backgroundView.alpha = 0
            }, completion: { [weak self] _ in
                self?.menuWrapper.isHidden = true
        })
    }
    
    private func showMenu() {
        guard !isShown else { return }
        
        isShown = true
        
        menuWrapper.frame.origin.y = 0
        menuWrapper.isHidden = false
        backgroundView.alpha = 0
        menuWrapper.superview?.bringSubview(toFront: menuWrapper)
        
        let blurEffect = UIBlurEffect(style: .dark)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationWillStart(#selector(pauseBlurAnimation))
        UIView.setAnimationDuration(ViewConstants.dropdownAnimationDuration)
        visualEffectView.effect = blurEffect
        backgroundView.alpha = ViewConstants.maskBackgroundOpacity
        UIView.commitAnimations()
        
        settingButton(fade: false, withAnimation: false)
        containerView(show: false)
        
        UIView.animate(
            withDuration: ViewConstants.dropdownAnimationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { [weak self] in
                self?.showAnimation?()
                self?.settingButton(show: true)
                self?.containerView(show: true)
            }, completion: { (_) in
                
        })
    }
    
    private func confirmButtons(show: Bool) {
        if show {
            butttonsPageView.confirmButtons(show: show)
        }
        UIView.animate(
            withDuration: ViewConstants.settingAnimationDuration,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.containerView(show: true, withConfirmButton: show)
            },
            completion: { [weak self] _ in
                if !show {
                    self?.butttonsPageView.confirmButtons(show: show)
                }
        })
    }
    
    private func settingButton(show: Bool) {
        if show {
            settingButtonHideConstraint.isActive = false
            settingButtonShowConstraint.isActive = true
        } else {
            settingButtonShowConstraint.isActive = false
            settingButtonHideConstraint.isActive = true
        }
        settingButton.superview?.layoutIfNeeded()
    }
    
    private func settingButton(fade: Bool, withAnimation: Bool = true) {
        if withAnimation {
            settingButton.alpha = fade ? 1.0 : 0.0
            settingButton.isHidden = !fade
            UIView.animate(
                withDuration: ViewConstants.settingAnimationDuration,
                delay: 0,
                options: UIViewAnimationOptions(),
                animations: { [weak self] in
                    self?.settingButton.alpha = fade ? 0.0 : 1.0
                },
                completion: { [weak self] _ in
                    self?.settingButton.isHidden = fade
            })
        } else {
            settingButton.alpha = fade ? 0.0 : 1.0
            settingButton.isHidden = fade
        }
    }
    
    private func containerView(show: Bool, withConfirmButton: Bool = false) {
        if show {
            containerViewHideConstraint.isActive = false
            let bottomConstant: CGFloat = withConfirmButton ? 0 : ButtonsPageView.ViewConstants.confirmButtonHeight
            containerViewShowConstraint.constant = bottomConstant
            containerViewShowConstraint.isActive = true
        } else {
            containerViewShowConstraint.isActive = false
            containerViewHideConstraint.isActive = true
        }
        containerView.superview?.layoutIfNeeded()
    }
    
    // MARK: - Public Methods
    
    func showOrHideActivityButtons() {
        isShown ? hideMenu() : showMenu()
    }
    
    func close(withCompletion completion: (() -> Void)? = nil) {
        hideMenu(withCompletion: completion)
    }
}
