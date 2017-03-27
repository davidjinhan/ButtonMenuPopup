//
//  Presentables.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit

protocol TableViewCellPresentable {
    func configure(withPresenter presenter: Presentable)
}

protocol Presentable {
    
}

protocol LabelPresentable: Presentable {
    var text: String? { get }
    var textColor: UIColor { get }
    var fontSize: CGFloat { get }
    var fontWeight: CGFloat { get }
    var labelBackgroundColor: UIColor { get }
    var alignment: NSTextAlignment { get }
    var numberOfLines: Int { get }
    var lineBreakMode: NSLineBreakMode { get }
    var lineHeightMultiple: CGFloat { get }
}

extension LabelPresentable {
    
    var text: String? {
        return nil
    }
    
    var textColor: UIColor {
        return .black
    }
    
    var fontSize: CGFloat {
        return 14
    }
    
    var fontWeight: CGFloat {
        return UIFontWeightMedium
    }
    
    var labelBackgroundColor: UIColor {
        return .clear
    }
    
    var alignment: NSTextAlignment {
        return .center
    }
    
    var numberOfLines: Int {
        return 1
    }
    
    var lineBreakMode: NSLineBreakMode {
        return .byTruncatingTail
    }
    
    var lineHeightMultiple: CGFloat {
        return 1.0
    }
}

protocol LabelTextChangablePresentable: LabelPresentable {
    var text: String? { get set }
}

extension LabelTextChangablePresentable {
    
    var text: String? {
        return nil
    }
}

protocol LabelColorChangablePresentable: LabelPresentable {
    var text: String? { get set }
    var textColor: UIColor { get set }
}

extension LabelColorChangablePresentable {
    
    var text: String? {
        return nil
    }
    
    var textColor: UIColor {
        return .black
    }
}


extension UILabel {
    func configure(withPresenter presenter: Presentable) {
        if let presenter = presenter as? LabelPresentable {
            backgroundColor = presenter.labelBackgroundColor
            if let text = presenter.text {
                numberOfLines = presenter.numberOfLines
                let nsText = text as NSString
                let textRange = NSRange(location: 0, length: nsText.length)
                let attributedString = NSMutableAttributedString(string: text)
                let style = NSMutableParagraphStyle()
                style.alignment = presenter.alignment
                style.lineHeightMultiple = presenter.lineHeightMultiple
                style.lineBreakMode = presenter.lineBreakMode
                attributedString.addAttributes([
                    NSParagraphStyleAttributeName: style,
                    NSForegroundColorAttributeName: presenter.textColor,
                    NSFontAttributeName: UIFont.systemFont(ofSize: presenter.fontSize, weight: presenter.fontWeight),
                    ], range: textRange)
                attributedText = attributedString
            }
        }
    }
}

protocol ImageButtonPresentable: Presentable {
    var buttonImage: UIImage { get set }
    var buttonBackgroundColor: UIColor { get set }
    var buttonTintColor: UIColor? { get }
    var cornerRadius: CGFloat? { get }
}

extension ImageButtonPresentable {
    var buttonBackgroundColor: UIColor {
        return .white
    }
    var buttonTintColor: UIColor? {
        return nil
    }
    var cornerRadius: CGFloat? {
        return nil
    }
}

protocol ImageWithTitleButtonPresentable: Presentable {
    var buttonImage: UIImage { get set }
    var buttonTitle: String { get set }
    var buttonTitleColor: UIColor { get }
    var buttonTitleFontSize: CGFloat { get }
    var buttonTitleFontWeight: CGFloat { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTintColor: UIColor? { get }
    var cornerRadius: CGFloat? { get }
    var borderWidth: CGFloat? { get }
    var borderColor: UIColor? { get }
}

extension ImageWithTitleButtonPresentable {
    var buttonTitleColor: UIColor {
        return .black
    }
    
    var buttonTitleFontSize: CGFloat {
        return 14
    }
    
    var buttonTitleFontWeight: CGFloat {
        return UIFontWeightMedium
    }
    
    var buttonBackgroundColor: UIColor {
        return .white
    }
    
    var buttonTintColor: UIColor? {
        return nil
    }
    
    var cornerRadius: CGFloat? {
        return nil
    }
    
    var borderWidth: CGFloat? {
        return nil
    }
    
    var borderColor: UIColor? {
        return nil
    }
}

extension UIButton {
    func configure(withPresenter presenter: Presentable) {
        if let presenter = presenter as? ImageButtonPresentable {
            setImage(presenter.buttonImage, for: .normal)
            setTitle(nil, for: .normal)
            backgroundColor = presenter.buttonBackgroundColor
            if let buttonTintColor = presenter.buttonTintColor {
                tintColor = buttonTintColor
            }
            if let cornerRadius = presenter.cornerRadius {
                layer.masksToBounds = true
                layer.cornerRadius = cornerRadius
            }
        }
        if let presenter = presenter as? ImageWithTitleButtonPresentable {
            setImage(presenter.buttonImage, for: .normal)
            setTitle(presenter.buttonTitle, for: .normal)
            setTitleColor(presenter.buttonTitleColor, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: presenter.buttonTitleFontSize, weight: presenter.buttonTitleFontWeight)
            backgroundColor = presenter.buttonBackgroundColor
            if let buttonTintColor = presenter.buttonTintColor {
                tintColor = buttonTintColor
            }
            if let cornerRadius = presenter.cornerRadius {
                layer.masksToBounds = true
                layer.cornerRadius = cornerRadius
            }
            if let borderWidth = presenter.borderWidth {
                layer.borderWidth = borderWidth
            }
            if let borderColor = presenter.borderColor {
                layer.borderColor = borderColor.cgColor
            }
        }
    }
}

protocol ImagePresentable: Presentable {
    var image: UIImage { get set }
    var imageBackgroundColor: UIColor { get set }
    var cornerRadius: CGFloat? { get set }
    var imageTintColor: UIColor? { get }
}

extension ImagePresentable {
    var imageBackgroundColor: UIColor {
        return .white
    }
    var cornerRadius: CGFloat? {
        return nil
    }
    var imageTintColor: UIColor? {
        return nil
    }
}

extension UIImageView {
    func configure(withPresenter presenter: Presentable) {
        if let presenter = presenter as? ImagePresentable {
            image = presenter.image
            backgroundColor = presenter.imageBackgroundColor
            if let cornerRadius = presenter.cornerRadius {
                layer.masksToBounds = true
                layer.cornerRadius = cornerRadius
            }
            if let imageTintColor = presenter.imageTintColor {
                print("!!!!!!!!!!!!!!!!!!!")
                tintColor = imageTintColor
            }
        }
    }
}
