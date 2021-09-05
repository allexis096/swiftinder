//
//  DetailProfileCell.swift
//  tinder
//
//  Created by allexis on 05/09/21.
//

import UIKit

class DetailProfileCell: UICollectionViewCell {
    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                ageLabel.text = String(user.age)
                phraseLabel.text = user.phrase
            }
        }
    }
    
    let nameLabel: UILabel = .textBoldLabel(32)
    let ageLabel: UILabel = .textLabel(28)
    let phraseLabel: UILabel = .textLabel(18, numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameAgeStackView = UIStackView(
            arrangedSubviews: [nameLabel, ageLabel, UIView()]
        )
        nameAgeStackView.spacing = 12
        
        let stackView = UIStackView(
            arrangedSubviews: [nameAgeStackView, phraseLabel]
        )
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.fillSuperview(
            padding: .init(
                top: 20,
                left: 20,
                bottom: 20,
                right: 20
            )
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
