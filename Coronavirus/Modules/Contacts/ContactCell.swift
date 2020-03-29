//
//  ContactCell.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 28.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell, HeightProviding {
    
    var didTapAt: ((MyContact) -> Void)?
    var height: CGFloat = 44
    
    private var model: MyContact!
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.cvCyan.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cvCyan
        label.font = UIFont.regular(size: .normal)
        return label
    }()
    
    private var statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        return view
    }()
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        addSubviews()
        
        setContainerView()
        setNameLabel()
        setStatusImage()
        setSpinnerView()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        [nameLabel, statusImage, spinnerView].forEach({ containerView.addSubview($0) })
    }
    
    private func setContainerView() {
        containerView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(6)
            make.right.bottom.equalToSuperview().offset(-6)
        }
    }
    
    private func setNameLabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setStatusImage() {
        statusImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setSpinnerView() {
        spinnerView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateView(for model: MyContact) {
        containerView.layer.borderColor = model.result.statusColor.cgColor
        nameLabel.text = model.fullName
        nameLabel.textColor = model.result.statusColor
        statusImage.image = UIImage(named: model.result.statusImageName)
    }
    
    func set(model: MyContact, updating: Bool) {
        self.model = model
        updateView(for: model)
        
        if updating {
            spinnerView.startAnimating()
            statusImage.isHidden = true
        } else {
            spinnerView.stopAnimating()
            statusImage.isHidden = false
        }
    }
}
