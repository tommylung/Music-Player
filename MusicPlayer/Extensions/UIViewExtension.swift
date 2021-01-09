//
//  UIViewExtension.swift
//  MusicPlayer
//
//  Created by Ngan Chak Lung on 9/1/2021.
//

import RxSwift
import UIKit

extension UIView {
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
}
