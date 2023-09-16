//
//  WWFloatingViewController.swift
//  WWFloatingViewController
//
//  Created by William.Weng on 2023/07/27.
//  Copyright © 2023 William.Weng. All rights reserved.
//

import UIKit
import WWPrint

// MARK: - WWFloatingViewController
open class WWFloatingViewController: UIViewController {
    
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var floatingViewHeightConstraint: NSLayoutConstraint!
    
    public var currentView: UIView?
    public weak var myDelegate: WWFloatingViewDelegate?
    
    private var isPanning = false
    private var animationDuration: TimeInterval = 0.5
    private var floatingViewCornerRadius: CGFloat = 8.0
    private var completePercent: CGFloat = 0.5
    private var multiplier: CGFloat = 0.5
    private var propertyAnimator: UIViewPropertyAnimator!
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event); dismissActionRule(touches, with: event) }
    open override func viewDidLoad() { super.viewDidLoad(); initSetting() }
    open override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); showFloatingView(duration: animationDuration) }
    
    deinit { wwPrint("deinit") }
}

// MARK: - 公開function
public extension WWFloatingViewController {
    
    /// [參數設定](https://medium.com/jeremy-xue-s-blog/swift-簡單動手做一個懸浮拖曳視窗-33ce429ca0f2)
    /// - Parameters:
    ///   - animationDuration: 動畫時間
    ///   - cornerRadius: 圓角
    ///   - backgroundColor: 背景色
    ///   - completePercent: 下滑動作完成的比例
    ///   - currentView: 要顯示的View
    ///   - multiplier: 要顯示的View所佔的畫面比例
    func configure(animationDuration: TimeInterval = 0.5, cornerRadius: CGFloat = 8.0, backgroundColor: UIColor = .black.withAlphaComponent(0.3), multiplier: CGFloat = 0.5, completePercent: CGFloat = 0.5, currentView: UIView? = nil) {
        
        self.animationDuration = animationDuration
        self.floatingViewCornerRadius = cornerRadius
        self.currentView = currentView
        self.completePercent = completePercent
        self.multiplier = multiplier
        self._transparent(backgroundColor)
    }
    
    /// 退出ViewController
    /// - Parameters:
    ///   - animated: 是否使用動畫
    func dismissViewController(animated: Bool = false) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.floatingView.transform = CGAffineTransform(translationX: 0, y: self.floatingView.bounds.height)
            self.myDelegate?.willDisAppear(self)
        }, completion: { (animatingPosition) in
            self.dismiss(animated: animated) {
                self.myDelegate?.didDisAppear(self, animatingPosition: animatingPosition)
            }
        })
    }
}

// MARK: - @objc
private extension WWFloatingViewController {
    
    /// [拖曳時的相關動作的手勢動畫](https://ithelp.ithome.com.tw/articles/10205703?sc=iThelpR)
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc private func floatingViewAnimation(_ recognizer: UIPanGestureRecognizer) {
        
        isPanning = true
        
        switch recognizer.state {
        case .began: floatingViewPanBegan(recognizer, duration: animationDuration)
        case .changed: floatingViewPanChanged(recognizer)
        case .ended: floatingViewPanEnded(recognizer, completePercent: completePercent)
        default: break
        }
    }
}

// MARK: - 小工具
private extension WWFloatingViewController {
    
    /// [初始化設定](https://www.jianshu.com/p/33e8dab5d11b)
    func initSetting() {
        
        _ = floatingViewHeightConstraint._multiplier(multiplier)

        initFloatingViewSetting()
        currentViewSetting()
        floatingViewSetting(cornerRadius: floatingViewCornerRadius)
    }
    
    /// 初始化設定floatingView
    /// - 將FloatingView移出畫面外
    func initFloatingViewSetting() {
        
        let recognizer = UIPanGestureRecognizer._build(target: self, action: #selector(floatingViewAnimation(_:)))
        
        floatingView.transform = CGAffineTransform(translationX: 0, y: floatingView.bounds.height)
        floatingView.isUserInteractionEnabled = true
        floatingView.addGestureRecognizer(recognizer)
    }
    
    /// 加上自訂的View
    func currentViewSetting() {
        
        guard let currentView = currentView else { return }
        
        floatingView.backgroundColor = .clear
        _ = currentView._constraint(on: floatingView)
    }
    
    /// floatingView外型的圓角設定
    func floatingViewSetting(cornerRadius: CGFloat) {
        floatingView.layer._maskedCorners(radius: cornerRadius, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    /// 顯示FloatingView
    /// - 包含動畫
    func showFloatingView(duration: TimeInterval) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.floatingView.transform = .identity
            self.myDelegate?.willAppear(self, completePercent: 0)
        }, completion: { (animatingPosition) in
            self.myDelegate?.didAppear(self, animatingPosition: animatingPosition)
        })
    }
    
    /// 點擊View時dismiss的使用規則 => 點到View + 沒有滑動
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func dismissActionRule(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchedView = touches.first?.view,
              touchedView == view,
              !isPanning
        else {
            return
        }
        
        dismissViewController()
    }
    
    /// 拖曳開始
    /// - 創建animator
    /// - 裡面的值為「最後的結果」
    func floatingViewPanBegan(_ recognizer: UIPanGestureRecognizer, duration: TimeInterval) {
        
        propertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            self.floatingView.transform = CGAffineTransform(translationX: 0, y: self.floatingView.bounds.height)
            self.view.backgroundColor = .clear
        }
    }
    
    /// 拖曳改變時
    /// - 取得動畫的進行百分比 => fractionComplete => run
    func floatingViewPanChanged(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: floatingView)
        let fractionComplete = translation.y / floatingView.bounds.height
        
        propertyAnimator.fractionComplete = fractionComplete
        myDelegate?.appearing(self, fractionComplete: propertyAnimator.fractionComplete)
    }
    
    /// 拖曳結束時
    /// - 完成百分比 <= 50% => 彈回去 (反轉動畫)
    /// - 完成百分比 > 50% => 加上結束動畫
    /// - 不管結果如何，動畫都繼續
    func floatingViewPanEnded(_ recognizer: UIPanGestureRecognizer, completePercent: CGFloat = 0.5) {
        
        defer {
            propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            self.isPanning = false
        }
        
        guard propertyAnimator.fractionComplete > completePercent else { propertyAnimator.isReversed = true; myDelegate?.appearing(self, fractionComplete: propertyAnimator.fractionComplete); return }
        
        propertyAnimator.addCompletion { (animatingPosition) in
            
            self.myDelegate?.willDisAppear(self)
            
            self.dismiss(animated: true, completion: {
                self.myDelegate?.didDisAppear(self, animatingPosition: animatingPosition)
            })
        }
    }
}
