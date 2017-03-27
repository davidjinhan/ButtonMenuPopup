//
//  ButtonsCollectionViewCell.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit
import RxSwift

typealias ButtonsCollectionViewPresentable = ImagePresentable & LabelPresentable

struct ButtonsCollectionViewPresenter: ButtonsCollectionViewPresentable {
    var text: String?
    var textColor: UIColor = .black
    var image: UIImage
    var imageBackgroundColor: UIColor
    var cornerRadius: CGFloat?
    var imageTintColor: UIColor? {
        return .white
    }
}

extension ButtonsCollectionViewPresenter {
    var fontSize: CGFloat {
        return 12
    }
}

struct ButtonPlusMinusImageViewPresentable: ImagePresentable {
    var image: UIImage
    var imageBackgroundColor: UIColor = .clear
    var cornerRadius: CGFloat?
    var imageTintColor: UIColor? {
        return .white
    }
}

class ButtonsCollectionViewCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    
    enum ViewConstants {
        static let plusMinusWidthRatio: CGFloat = 20 / 51
        static let plusMinusBorderWidth: CGFloat = 1
    }
    
    private var delegate: ButtonsCollectionViewPresentable?
    
    private var buttonWidthConstraint: NSLayoutConstraint!
    
    private var plusView: UIImageView!
    
    private var minusView: UIImageView!
    
    private var disposable: Disposable?
    
    var isVisible: Observable<Bool>! {
        didSet {
            if let isVisible = isVisible {
                disposable?.dispose()
                
                // TODO : from setting view model observable
                let onSetting = Variable(false).asObservable()
                
                disposable = Observable.combineLatest(isVisible, onSetting) { visible, setting in
                    return (visible, setting)
                    }
                    .subscribe(onNext: { [weak self] visible, setting in
                        self?.update(byOnOffSetting: setting, enabled: visible)
                    })
            }
        }
    }
    
    var buttonWidth: CGFloat {
        get {
            return buttonWidthConstraint.constant
        }
        set(width) {
            buttonWidthConstraint.constant = width
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        buttonWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 51)
        buttonWidthConstraint.isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1.0).isActive = true
        
        let addIcon = UIImage(named: "icon_add_small")!.withRenderingMode(.alwaysOriginal)
        let removeIcon = UIImage(named: "icon_remove_small")!.withRenderingMode(.alwaysOriginal)
        plusView = setupSmallImageView(withIcon: addIcon, backgroundColor: .clear)
        minusView = setupSmallImageView(withIcon: removeIcon, backgroundColor: .clear)
        
        overlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        overlayView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        overlayView.layer.masksToBounds = true
        overlayView.layer.cornerRadius = overlayView.frame.height / 2
    }
    
    private func setupCorner(ofView view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: ViewConstants.plusMinusWidthRatio).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
    }
    
    private func setupSmallImageView(withIcon icon: UIImage, backgroundColor: UIColor) -> UIImageView {
        let presenter = ButtonPlusMinusImageViewPresentable(image: icon,
                                                            imageBackgroundColor: backgroundColor,
                                                            cornerRadius: nil)
        let imageView = UIImageView()
        imageView.configure(withPresenter: presenter)
        containerView.addSubview(imageView)
        setupCorner(ofView: imageView)
        return imageView
    }
    
    private func setupMinusView() {
        minusView.backgroundColor = .red
        containerView.addSubview(minusView)
        setupCorner(ofView: minusView)
    }
    
    func update(byOnOffSetting on: Bool, enabled: Bool) {
        switch (on, enabled) {
        case (false, true):
            containerView.isHidden = false
            plusView.isHidden = true
            minusView.isHidden = true
            iconImageView.alpha = 1.0
            iconImageView.isHidden = false
        case (false, false):
            containerView.isHidden = true
        case (true, true):
            containerView.isHidden = false
            plusView.isHidden = true
            minusView.isHidden = false
            iconImageView.isHidden = false
            iconImageView.alpha = 1.0
        case (true, false):
            containerView.isHidden = false
            plusView.isHidden = false
            minusView.isHidden = true
            iconImageView.isHidden = false
            iconImageView.alpha = 0.25
        }
    }
    
    func configure(withPresenter presenter: ButtonsCollectionViewPresenter) {
        delegate = presenter
        
        iconImageView.configure(withPresenter: presenter)
        titleLabel.configure(withPresenter: presenter)
    }
    
    func effect(forSelected selected: Bool) {
        if selected {
            overlayView.isHidden = false
            containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } else {
            containerView.transform = .identity
            overlayView.isHidden = true
        }
    }
}
