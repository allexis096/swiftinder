//
//  CombineVC.swift
//  tinder
//
//  Created by allexis on 12/08/21.
//

import UIKit

enum Action {
    case deslike
    case like
    case superlike
}

class CombineVC: UIViewController {
    var profileButton: UIButton = .iconMenu(named: "icone-perfil")
    var chatButton: UIButton = .iconMenu(named: "icone-chat")
    var logoButton: UIButton = .iconMenu(named: "icone-logo")
    
    var deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var superLikeButton: UIButton = .iconFooter(named: "icone-superlike")
    var likeButton: UIButton = .iconFooter(named: "icone-like")
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.systemGroupedBackground
        
        let loading = Loading(frame: view.frame)
        view.insertSubview(loading, at: 0)
        
        self.addHeader()
        self.addFooter()
        self.searchUsers()
    }
    
    func searchUsers() {
        UserService.shared.searchUsers { (users, err) in
            if let users = users {
                DispatchQueue.main.async {
                    self.users = users
                    self.addCards()
                }
            }
        }
    }
}

extension CombineVC {
    func addHeader() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        
        let stackView = UIStackView(arrangedSubviews: [profileButton, logoButton, chatButton])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: nil,
            padding: .init(top: top, left: 16, bottom: 0, right: 16)
        )
    }
    
    func addFooter() {
        let stackView = UIStackView(
            arrangedSubviews: [UIView(), deslikeButton, superLikeButton, likeButton, UIView()]
        )
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: 34, right: 16)
        )
        
        deslikeButton.addTarget(self, action: #selector(deslikeClick), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
        superLikeButton.addTarget(self, action: #selector(superLikeClick), for: .touchUpInside)
    }
}

extension CombineVC {
    func addCards() {
        for user in users {
            let card = CombineCardView()
            card.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            
            card.center = view.center
            card.user = user
            card.tag = user.id
            
            card.callback = {(data) in
                self.viewDetail(user: data)
            }
            
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleCard))
            
            card.addGestureRecognizer(gesture)
            
            view.insertSubview(card, at: 1)
        }
    }
    
    func removeCard(card: UIView) {
        card.removeFromSuperview()
        
        self.users = self.users.filter({ (user) -> Bool in
            return user.id != card.tag
        })
    }
    
    func verifyMatch(user: User) {
        if user.match {
            let matchVC = MatchVC()
            matchVC.user = user
            matchVC.modalPresentationStyle = .fullScreen
            
            self.present(matchVC, animated: true, completion: nil)
        }
    }
    
    func viewDetail(user: User) {
        let detailVC = DetailVC()
        detailVC.user = user
        detailVC.modalPresentationStyle = .fullScreen
        
        detailVC.callback = {(user, action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if action == .deslike {
                    self.deslikeClick()
                } else {
                    self.likeClick()
                }
            })
        }
        
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension CombineVC {
    @objc func handleCard (_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? CombineCardView {
            let point = gesture.translation(in: view)
            
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.likeImageView.alpha = rotationAngle * 5
                card.deslikeImageView.alpha = 0
            } else {
                card.deslikeImageView.alpha = rotationAngle * 5 * -1
                card.likeImageView.alpha = 0
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                if card.center.x > self.view.bounds.width + 50 {
                    self.animateCard(rotationAngle: rotationAngle, action: .like)
                    return
                }
                
                if card.center.x < 0 - 50 {
                    self.animateCard(rotationAngle: rotationAngle, action: .deslike)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                    
                    card.likeImageView.alpha = 0
                    card.deslikeImageView.alpha = 0
                }
            }
        }
    }
    
    @objc func deslikeClick() {
        self.animateCard(rotationAngle: -0.4, action: .deslike)
    }
    
    @objc func likeClick() {
        self.animateCard(rotationAngle: 0.4, action: .like)
    }
    
    @objc func superLikeClick() {
        self.animateCard(rotationAngle: 0, action: .superlike)
    }
    
    func animateCard(rotationAngle: CGFloat, action: Action) {
        if let user = self.users.first {
            for view in self.view.subviews {
                if view.tag == user.id {
                    if let card = view as? CombineCardView {
                        let center: CGPoint
                        var like: Bool
                        
                        switch action {
                        case .deslike:
                            center = CGPoint(
                                x: card.center.x - self.view.bounds.width,
                                y: card.center.y + 50
                            )
                            like = false
                        case .like:
                            center = CGPoint(
                                x: card.center.x + self.view.bounds.width,
                                y: card.center.y + 50
                            )
                            like = true
                        case .superlike:
                            center = CGPoint(
                                x: card.center.x,
                                y: card.center.y - self.view.bounds.height
                            )
                            like = true
                        }
                        
                        UIView.animate(withDuration: 0.4, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            
                            card.deslikeImageView.alpha = like == false ? 1 : 0
                            card.likeImageView.alpha = like == true ? 1 : 0
                        }) { (_) in
                            if like {
                                self.verifyMatch(user: user)
                            }
                            
                            self.removeCard(card: card)
                        }
                    }
                }
            }
        }
    }
}
