//
//  GithubUserCellCollectionViewCell.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 7.08.2025.
//

import UIKit
import SDWebImage

protocol GitHubUserCellDelegate: AnyObject {
    func gitHubUserCellDidTapFavourite(_ cell: GitHubUserCollectionViewCell, for user: GitHubUser)
}

final class GitHubUserCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: GitHubUserCellDelegate?
    private var isFavourite: Bool = false
    private var user: GitHubUser?

    // MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 30
        backgroundColor = ColorSet.incodiBlack.withAlphaComponent(0.3)
        setupAvatarImageView()
        setupUserNameLabel()
    }

    // MARK: - Configure
    
    func configure(
        with user: GitHubUser,
        isFavourite: Bool
    ) {
        self.user = user
        userNameLabel.text = user.login
        self.isFavourite = isFavourite
        favouriteButton.isSelected = isFavourite
        
        avatarImageView.sd_setImage(
            with: URL(string: user.avatar_url),
            placeholderImage: UIImage(systemName: "person.circle"),
            options: [.continueInBackground, .scaleDownLargeImages],
            completed: nil
        )
        setupFavouriteButton()
    }
    
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 15
        avatarImageView.tintColor = ColorSet.incodiOrange
    }
    
    private func setupUserNameLabel() {
        userNameLabel.numberOfLines = 0
        userNameLabel.textColor = .white
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.minimumScaleFactor = 0.7
    }
    
    private func setupFavouriteButton() {
        favouriteButton.tintColor = ColorSet.incodiOrange
        favouriteButton.contentHorizontalAlignment = .center
        favouriteButton.setTitle(nil, for: .normal)
        favouriteButton.setTitle(nil, for: .selected)
        if isFavourite {
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    @IBAction func favouriteButtonTapped(_ sender: Any) {
        guard let user = user else { return }
        delegate?.gitHubUserCellDidTapFavourite(self, for: user)
    }
}
