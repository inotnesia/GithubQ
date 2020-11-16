//
//  Modal.swift
//  MovieQ
//
//  Created by Tony Hadisiswanto on 05/07/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit

protocol Modal {
    func show(animated: Bool, alpha: CGFloat, superView: UIView)
    func dismiss(animated: Bool)
    
    var backgroundView: UIView! { get }
    var contentView: UIView! { get set }
}

extension Modal where Self: UIView {
    func show(animated: Bool, alpha: CGFloat, superView: UIView = UIApplication.shared.delegate?.window??.rootViewController?.view ?? UIView()) {
        guard backgroundView != nil else { return }
        guard contentView != nil else { return }
        
        self.backgroundView.alpha = 0
        self.contentView.center = CGPoint(x: self.center.x, y: self.frame.height + self.contentView.frame.height/2)
        superView.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = alpha
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.contentView.center = self.center
            }, completion: { _ in
                
            })
        } else {
            self.backgroundView.alpha = alpha
            self.contentView.center = self.center
        }
    }
    
    func dismiss(animated: Bool) {
        guard backgroundView != nil else { return }
        guard contentView != nil else { return }
        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { _ in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.contentView.center = CGPoint(x: self.center.x, y: self.frame.height + self.contentView.frame.height/2)
            }, completion: { _ in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
}
