//
//  Extension + UIView.swift
//  MyWeather
//
//  Created by Jarae on 11/9/23.
//

import UIKit

extension UIView {
    func addSubiews(_ view: UIView...) {
        view.forEach { view in
            self.addSubview(view)
        }
    }
}
