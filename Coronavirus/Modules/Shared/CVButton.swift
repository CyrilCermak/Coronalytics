//
//  CVButton.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 28.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class CVButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = self.isHighlighted ? UIColor.cvGrey : UIColor.clear
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.cvCyan, for: .normal)
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.cvCyan.cgColor
        titleLabel?.font = UIFont.regular(size: .normal)
    }
}
