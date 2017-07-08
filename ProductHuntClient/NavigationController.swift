//
//  NavigationController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit

final class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.barTintColor = UIColor(red: 220, green: 84, blue: 37)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
