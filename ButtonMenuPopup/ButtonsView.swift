//
//  ButtonsView.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit
import RxSwift

class ButtonsView: UIView {

    enum LayoutConstants {
        static let viewAspectRatio: CGFloat = 375 / 200
        static let cellAspectRatio: CGFloat = 71 / 100
        static let collectionViewMarginRatio: CGFloat = 10 / 375
        static let buttonWidthRatio: CGFloat = 51 / 71
        static let buttonBorderWidthRatio: CGFloat = 57 / 71
    }
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    private var disposeBag = DisposeBag()
    
    private var buttonViewModel: ButtonViewModel!
    
    private var movingCell: ButtonsCollectionViewCell?
    
    private var circleBackgroundView: ButtonsBackgroundView!
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    private var collectionViewMargin: CGFloat {
        return screenWidth * LayoutConstants.collectionViewMarginRatio
    }
    
    // MARK: - Setup
    
    init(type: ButtonType) {
        super.init(frame: CGRect.zero)
        
        buttonViewModel = ButtonViewModel(type: type)
        setupCollectionView()
        setupBorderCicleBackgroundView()
        addBinds(toViewModel: buttonViewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        // TODO : check setting mode
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: collectionView)), selectedIndexPath.row < buttonViewModel.enabledButtons.count else {
                break
            }
            if let cell = collectionView.cellForItem(at: selectedIndexPath) as? ButtonsCollectionViewCell {
                movingCell = cell
                cell.effect(forSelected: true)
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            movingCell?.effect(forSelected: false)
            movingCell = nil
            if let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                if selectedIndexPath.row >= buttonViewModel.enabledButtons.count {
                    collectionView.cancelInteractiveMovement()
                } else {
                    collectionView.endInteractiveMovement()
                }
            } else {
                collectionView.cancelInteractiveMovement()
            }
        default:
            movingCell?.effect(forSelected: false)
            movingCell = nil
            collectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.layer.masksToBounds = false
        addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: collectionViewMargin).isActive = true
        let trailing = collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -collectionViewMargin)
        trailing.priority = 999
        trailing.isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(ButtonsCollectionViewCell.self)
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func setupBorderCicleBackgroundView() {
        let numberOfBorderCircles = buttonViewModel.buttonModels.value.count
        let cellWidth = (screenWidth - collectionViewMargin * 2) / 5
        let cellHeight = cellWidth / LayoutConstants.cellAspectRatio
        let borderCircleSize = screenWidth / 5 * LayoutConstants.buttonBorderWidthRatio
        circleBackgroundView = ButtonsBackgroundView(numberOfCircles: numberOfBorderCircles, columns: 5, borderCircleSize: borderCircleSize, cellWidth: cellWidth, cellHeight: cellHeight)
        collectionView.backgroundView = circleBackgroundView
        circleBackgroundView.isHidden = true
        
        
        // TODO : bind with setting view model
    }
    
    private func addBinds(toViewModel viewModel: ButtonViewModel) {
        let buttonWidth = UIScreen.main.bounds.width / 5 * LayoutConstants.buttonWidthRatio
        
        viewModel.buttonModels
            .asObservable()
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { [weak self] collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: ButtonsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                let image = element.buttonImage.withRenderingMode(.alwaysTemplate)
                let buttonColor = UIColor(red: 117 / 255, green: 118 / 255, blue: 179 / 255, alpha: 1.0)
                let presenter = ButtonsCollectionViewPresenter(text: element.buttonTitle,
                                                               textColor: .black,
                                                               image: image,
                                                               imageBackgroundColor: buttonColor,
                                                               cornerRadius: buttonWidth / 2)
                cell.configure(withPresenter: presenter)
                cell.buttonWidth = buttonWidth
                
                cell.isVisible = element.isVisible.asObservable()
                
                cell.containerView.layoutIfNeeded()
                self?.circleBackgroundView.drawBorderCircle(withCircleContainerHeight: cell.containerView.frame.height, iconCircleSize: buttonWidth)
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        collectionView.rx.dataSource
            .sentMessage(#selector(UICollectionViewDataSource.collectionView(_:moveItemAt:to:)))
            .map {
                ($0[0] as! UICollectionView, $0[1] as! IndexPath, $0[2] as! IndexPath)
            }
            .subscribe(onNext: { [weak self] collectionView, moveItemAt, to in
                let sourceIndex = moveItemAt.row
                let destinationIndex = to.row
                self?.buttonViewModel.saveButtonSequence(fromSourceIndex: sourceIndex, destinationIndex: destinationIndex)
            })
            .addDisposableTo(disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                // TODO : check setting view model
                self?.itemSelectedOnSetting(atIndexPath: indexPath)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func itemSelectedToAdd(atIndexPath indexPath: IndexPath) {
        
        let completion = {
            // implement button actions here
        }
        
        ButtonMenuPopupManager.shared.close(withCompletion: completion)
    }
    
    private func itemSelectedOnSetting(atIndexPath indexPath: IndexPath) {
        let model = buttonViewModel.buttonModels.value[indexPath.row]
        if indexPath.row >= buttonViewModel.enabledButtons.count { // enable
            model.isVisible.value = true
            let toIndexPath = IndexPath(row: buttonViewModel.enabledButtons.count - 1, section: 0)
            collectionView.moveItem(at: indexPath, to: toIndexPath)
            buttonViewModel.saveButtonSequence(fromSourceIndex: indexPath.row, destinationIndex: toIndexPath.row)
        } else { // disable
            model.isVisible.value = false
            let toIndexPath = IndexPath(row: buttonViewModel.enabledButtons.count, section: 0)
            collectionView.moveItem(at: indexPath, to: toIndexPath)
            buttonViewModel.saveButtonSequence(fromSourceIndex: indexPath.row, destinationIndex: toIndexPath.row)
        }
    }
    
    // MARK: - APIs
    
    func confirmSetting() {
        buttonViewModel.confirmCurrentButtonSettings()
    }
    
    func cancelSetting() {
        buttonViewModel.cancelCurrentButtonSettings()
    }
}

extension ButtonsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 5
        let height = collectionView.bounds.height / 2
        return CGSize(width: width, height: height)
    }
}
