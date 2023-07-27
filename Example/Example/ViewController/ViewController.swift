//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/07/27.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/ios/Desktop/WWFloatingViewController

import UIKit
import WWPrint
import WWFloatingViewController

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func test(_ sender: UIButton) {

        let floatingViewController = WWFloatingView.shared.maker()
        let currentView = UIImageView(image: UIImage(systemName: "scribble.variable"))
        
        currentView.contentMode = .scaleAspectFit
        currentView.backgroundColor = .systemPink.withAlphaComponent(0.5)

        floatingViewController.myDelegate = self
        floatingViewController.configure(backgroundColor: .systemTeal.withAlphaComponent(0.5), multiplier: 0.8, completePercent: 0.5, currentView: currentView)
        
        present(floatingViewController, animated: true)
    }
}

// MARK: - WWFloatingViewDelegate
extension ViewController: WWFloatingViewDelegate {
    
    func willAppear(_ viewController: WWFloatingViewController, completePercent: CGFloat) {
        wwPrint("completePercent => \(completePercent)")
    }
    
    func appearing(_ viewController: WWFloatingViewController, fractionComplete: CGFloat) {
        wwPrint("fractionComplete => \(fractionComplete)")
    }
    
    func didAppear(_ viewController: WWFloatingViewController, animatingPosition: UIViewAnimatingPosition) {
        wwPrint("animatingPosition => \(animatingPosition)")
    }
    
    func didDisAppear(_ viewController: WWFloatingViewController, animatingPosition: UIViewAnimatingPosition) {
        wwPrint("animatingPosition => \(animatingPosition)")
    }
}
