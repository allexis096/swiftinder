//
//  CombineVC.swift
//  tinder
//
//  Created by allexis on 12/08/21.
//

import UIKit

class CombineVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        
        let redView = UIView()
        redView.backgroundColor = .red
        redView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        
        redView.center = view.center
        
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleCard))
        
        redView.addGestureRecognizer(gesture)
        
        view.addSubview(redView)
    }
}

extension CombineVC {
    @objc func handleCard (_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view {
            let point = gesture.translation(in: view)
            
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            if gesture.state == .ended {
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                }
            }
        }
    }
}
