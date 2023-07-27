//
//  Extension+.swift
//  WWFloatingViewController
//
//  Created by William.Weng on 2023/07/27.
//  Copyright © 2023 William.Weng. All rights reserved.
//

import UIKit

// MARK: - UIViewController (class function)
extension UIViewController {
    
    /// 設定UIViewController透明背景 (當Alert用)
    /// - Present Modally
    /// - Parameter backgroundColor: 背景色
    func _transparent(_ backgroundColor: UIColor = .clear) {
        view.backgroundColor = backgroundColor
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
}

// MARK: - UIPanGestureRecognizer
extension UIPanGestureRecognizer {
    
    /// 拖曳手勢產生器 (單指)
    /// - Parameters:
    ///   - target: 要設定的位置
    ///   - action: 拖曳下去要做什麼？
    /// - Returns: UIPanGestureRecognizer
    static func _build(target: Any?, action: Selector?) -> UIPanGestureRecognizer {
        
        let recognizer = UIPanGestureRecognizer(target: target, action: action)
        return recognizer
    }
}

// MARK: - UIView (class function)
extension UIView {
    
    /// 設定LayoutConstraint
    /// - Parameter view: 要設定的View
    /// - Returns: Self
    func _constraint(on view: UIView) -> Self {
        
        removeFromSuperview()
        view.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        return self
    }
}

// MARK: - CALayer (class function)
extension CALayer {
    
    /// 設定圓角
    /// - 可以個別設定要哪幾個角
    /// - 預設是四個角全是圓角
    /// - Parameters:
    ///   - radius: 圓的半徑
    ///   - corners: 圓角要哪幾個邊
    func _maskedCorners(radius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        
        masksToBounds = true
        maskedCorners = corners
        cornerRadius = radius
    }
}

// MARK: - NSLayoutConstraint (function)
extension NSLayoutConstraint {
    
    /// [更新比例倍數](https://www.jianshu.com/p/afa79ad6605e)
    /// - Parameter multiplier: [CGFloat](https://stackoverflow.com/questions/37294522/ios-change-the-multiplier-of-constraint-by-swift)
    /// - Returns: NSLayoutConstraint
    func _multiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        
        guard let firstItem = firstItem else { fatalError() }
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
