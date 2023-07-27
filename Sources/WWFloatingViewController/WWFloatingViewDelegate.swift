//
//  WWFloatingViewDelegate.swift
//  WWFloatingViewController
//
//  Created by iOS on 2023/7/27.
//  Copyright © 2023 William.Weng. All rights reserved.
//

import UIKit

// MARK: - WWFloatingViewDelegate
public protocol WWFloatingViewDelegate: AnyObject {
    
    /// 將要顯示 - 沒出現
    /// - Parameters:
    ///   - viewController: Self
    ///   - completePercent: 滑動完成的百分比
    func willAppear(_ viewController: WWFloatingViewController, completePercent: CGFloat)
    
    /// 出現中
    /// - Parameters:
    ///   - viewController: Self
    ///   - fractionComplete: 滑動的百分比
    func appearing(_ viewController: WWFloatingViewController, fractionComplete: CGFloat)
    
    /// 顯示完成 - 出現了
    /// - Parameters:
    ///   - viewController: Self
    ///   - animatingPosition: 滑動的百分比
    func didAppear(_ viewController: WWFloatingViewController, animatingPosition: UIViewAnimatingPosition)
    
    /// 顯示結束 - 不見了
    /// - Parameters:
    ///   - viewController: Self
    ///   - animatingPosition: 滑動的百分比
    func didDisAppear(_ viewController: WWFloatingViewController, animatingPosition: UIViewAnimatingPosition)
}
