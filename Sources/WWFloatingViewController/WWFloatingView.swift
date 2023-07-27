//
//  WWFloatingView.swift
//  WWFloatingViewController
//
//  Created by William.Weng on 2023/07/27.
//  Copyright © 2023 William.Weng. All rights reserved.
//

import Foundation

// MARK: - WWFloatingView
open class WWFloatingView {
    
    public static let shared = WWFloatingView()
    
    /// 產生WWFloatingViewController
    /// - Returns: WWFloatingViewController
    public func maker() -> WWFloatingViewController {
        let viewController = WWFloatingViewController(nibName: String(describing: WWFloatingViewController.self), bundle: .module)
        return viewController
    }
}
