//
//  DetailVC.swift
//  tinder
//
//  Created by allexis on 04/09/21.
//

import UIKit

class HeaderLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach({ (attribute) in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                
                let contentOffSetY = collectionView.contentOffset.y
                
                attribute.frame = CGRect(
                    x: 0,
                    y: contentOffSetY,
                    width: collectionView.bounds.width,
                    height: attribute.bounds.height - contentOffSetY
                )
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

class DetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let cellId = "cellId"
    let headerId = "headerId"
    let profileId = "profileId"
    
    init() {
        super.init(collectionViewLayout: HeaderLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.backgroundColor = .red
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: cellId
        )
        collectionView.register(
            DetailHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId
        )
        collectionView.register(
            DetailProfileCell.self,
            forCellWithReuseIdentifier: profileId
        )
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerId,
            for: indexPath
        ) as! DetailHeaderView
        header.user = self.user
        
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.height * 0.7)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: profileId,
                for: indexPath
            ) as! DetailProfileCell
        cell.user = self.user
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = 100
        
        let cell = DetailProfileCell(
            frame: CGRect(x: 0, y: 0, width: width, height: height)
        )
        cell.user = self.user
        cell.layoutIfNeeded()
        
        let estimatedSize = cell.systemLayoutSizeFitting(
            CGSize(width: width, height: 1000)
        )
        height = estimatedSize.height
        
        return .init(width: width, height: height)
    }
}
