//
//  GithubUserCellCollectionViewCell.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 7.08.2025.
//

import UIKit
import SDWebImage

protocol GitHubUserCellDelegate: AnyObject {
    func gitHubUserCellDidTapFavourite(_ cell: GitHubUserCollectionViewCell)
}

final class GitHubUserCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: GitHubUserCellDelegate?
    private var isFavourite: Bool = false

    // MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.sd_imageTransition = .fade
        favouriteButton.setTitle(nil, for: .normal)
        favouriteButton.contentHorizontalAlignment = .center
        favouriteButton.titleLabel?.font = .systemFont(ofSize: 18)
        userNameLabel.numberOfLines = 0
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.minimumScaleFactor = 0.7
        favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }

    // MARK: - Configure
    
    func configure(
            name: String,
            avatarURL: URL?,
            isFavourite: Bool
    ) {
        userNameLabel.text = name
        self.isFavourite = isFavourite
        favouriteButton.isSelected = isFavourite
        
        avatarImageView.sd_setImage(
            with: avatarURL,
            placeholderImage: UIImage(systemName: "person.circle"),
            options: [.continueInBackground, .scaleDownLargeImages],
            completed: nil
        )
    }

    @IBAction func favouriteButtonTapped(_ sender: Any) {
        isFavourite.toggle()
        favouriteButton.isSelected = isFavourite
        delegate?.gitHubUserCellDidTapFavourite(self)
    }
}
