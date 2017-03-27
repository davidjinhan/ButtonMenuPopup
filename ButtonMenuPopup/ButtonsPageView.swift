//
//  ButtonsPageView.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit
import RxSwift

class ButtonsPageView: UIView {

    enum LocalizedString {
        static let buttonType1 = NSLocalizedString("Add Fruits", comment: "")
        static let buttonType2 = NSLocalizedString("Add Vegetables", comment: "")
        static let buttonSetting = NSLocalizedString("Button Edit", comment: "")
    }
    
    struct TopLabelPresenter: LabelPresentable {
        var text: String? = LocalizedString.buttonType1
        var textColor: UIColor = .black
        var fontSize: CGFloat {
            return 12
        }
        var fontWeight: CGFloat {
            return UIFontWeightSemibold
        }
        var labelBackgroundColor: UIColor {
            return UIColor(red: 218 / 255, green: 237 / 255, blue: 247 / 255, alpha: 1.0)
        }
    }
    
    struct ConfirmButtonPresenter: ImageButtonPresentable {
        var buttonImage: UIImage = UIImage(named: "icon_check")!.withRenderingMode(.alwaysTemplate)
        var buttonBackgroundColor: UIColor = .gray
        var buttonTintColor: UIColor? {
            return .white
        }
        var width: CGFloat?
        var height: CGFloat?
        var cornerRadius: CGFloat?
    }
    
    struct CancelButtonPresenter: ImageButtonPresentable {
        var buttonImage: UIImage = UIImage(named: "icon_delete")!.withRenderingMode(.alwaysTemplate)
        var buttonBackgroundColor: UIColor = .lightGray
        var buttonTintColor: UIColor? {
            return .white
        }
        var width: CGFloat?
        var height: CGFloat?
        var cornerRadius: CGFloat?
    }
    
    // MARK: - Properties
    
    enum ViewConstants {
        static let topLabelHeight: CGFloat = 26
        static let pageControlHeight: CGFloat = 15
        static let confirmButtonHeight: CGFloat = 38
    }
    
    private let disposeBag = DisposeBag()
    
    private var topTitleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var confirmButton: UIButton!
    private var cancelButton: UIButton!
    
    private let fruitButtonModels: [String] = [
        "citrus", "pear", "apple", "avocado", "banana"
    ]
    
    private let vegetableButtonModels: [String] = [
        "corn", "tomato", "mushroom", "carrot"
    ]
    
    // MARK: - Setup
    
    init() {
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        setupTopTitleLabel()
        setupScrollView()
        setupPageControl()
        setupConfirmButtons()
        setupButtonsView()
        setupSettingModel()
    }
    
    private func setupTopTitleLabel() {
        topTitleLabel = UILabel()
        let presenter = TopLabelPresenter()
        topTitleLabel.configure(withPresenter: presenter)
        topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topTitleLabel)
        
        topTitleLabel.heightAnchor.constraint(equalToConstant: ViewConstants.topLabelHeight).isActive = true
        topTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        // TODO : set a aspect ratio by a buttons view
        scrollView.widthAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 375 / 200).isActive = true
        scrollView.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        scrollView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                
                let pageWidth = strongSelf.scrollView.frame.width
                let pageFraction = strongSelf.scrollView.contentOffset.x / pageWidth
                strongSelf.pageControl.currentPage = Int(round(pageFraction))
                
                self?.updateTopLabel()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = UIColor(red: 218 / 255, green: 237 / 255, blue: 247 / 255, alpha: 1.0)
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        addSubview(pageControl)
        
        pageControl.heightAnchor.constraint(equalToConstant: ViewConstants.pageControlHeight).isActive = true
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupConfirmButtons() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        addSubview(view)
        
        view.heightAnchor.constraint(equalToConstant: ViewConstants.confirmButtonHeight).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cancelButton = UIButton(type: .custom)
        let cancelButtonPresenter = CancelButtonPresenter()
        cancelButton.configure(withPresenter: cancelButtonPresenter)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        confirmButton = UIButton(type: .custom)
        let confirmButtonPresenter = ConfirmButtonPresenter()
        confirmButton.configure(withPresenter: confirmButtonPresenter)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        
        confirmButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor, multiplier: 1.0).isActive = true
    }
    
    private func setupButtonsView() {
        let fruitButtonsView = ButtonsView(type: .fruit)
        fruitButtonsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(fruitButtonsView)
        fruitButtonsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        fruitButtonsView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        fruitButtonsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        fruitButtonsView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
        
        let vegetableButtonsView = ButtonsView(type: .vegetable)
        vegetableButtonsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(vegetableButtonsView)
        vegetableButtonsView.leadingAnchor.constraint(equalTo: fruitButtonsView.trailingAnchor).isActive = true
        vegetableButtonsView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        vegetableButtonsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        vegetableButtonsView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                fruitButtonsView.cancelSetting()
                vegetableButtonsView.cancelSetting()
                // TODO: set setting view model
            })
            .addDisposableTo(disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: {
                fruitButtonsView.confirmSetting()
                vegetableButtonsView.confirmSetting()
                // TODO: set setting view model
            })
            .addDisposableTo(disposeBag)
    }
    
    private func updateTopLabel() {
        var presenter = TopLabelPresenter()
        // TODO: update a top label by setting
        presenter.text = pageControl.currentPage == 0 ? LocalizedString.buttonType1 : LocalizedString.buttonType2
        topTitleLabel.configure(withPresenter: presenter)
    }
    
    private func setupSettingModel() {
        // TODO: update a top label by setting
    }
    
    // MARK: - APIs
    
    func confirmButtons(show: Bool) {
        confirmButton.isHidden = !show
        cancelButton.isHidden = !show
    }

}
