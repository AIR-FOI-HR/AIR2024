//
//  FooterView.swift
//  WeatherActivity
//
//  Created by Infinum on 28.12.2020..
//

import UIKit

//MARK: - Protocol

protocol FooterViewDelegate: class {
    
    func footerVIewDidSelectBack()
    func footerVIewDidSelectNext()
}

//MARK: - FooterView class

class FooterView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    weak var delegate: FooterViewDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectBack(_ sender: UIButton) {
        print("Klik na back!")
        delegate?.footerVIewDidSelectBack()
    }
    
    @IBAction func didSelectNext(_ sender: UIButton) {
        print("Klik na next!")
        delegate?.footerVIewDidSelectNext()
    }
    
}
