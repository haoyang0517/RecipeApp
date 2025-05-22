//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 22/05/2025.
//

import UIKit
import SnapKit

class RecipeTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let typeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
        
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 8
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        typeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        typeLabel.textColor = .secondaryLabel
        typeLabel.numberOfLines = 0
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, typeLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [recipeImageView, labelStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        
        containerView.addSubview(mainStack)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func configure(with recipe: RecipeModel) {
        titleLabel.text = recipe.title
        typeLabel.text = recipe.type
        if let imageData = recipe.imageData, let image = UIImage(data: imageData) {
            recipeImageView.image = image
        } else {
            recipeImageView.image = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
}
