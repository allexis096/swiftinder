//
//  DetailPhotosCell.swift
//  tinder
//
//  Created by allexis on 05/09/21.
//

import UIKit

class DetailPhotosCell: UICollectionViewCell {
    let descriptionLabel: UILabel = .textBoldLabel(16)
    
    let slidesPhotosVC = SlidePhotosVC()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        descriptionLabel.text = "Fotos recentes Instagram"
        
        addSubview(descriptionLabel)
        descriptionLabel.fill(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20)
        )
        
        addSubview(slidesPhotosVC.view)
        slidesPhotosVC.view.fill(
            top: descriptionLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
