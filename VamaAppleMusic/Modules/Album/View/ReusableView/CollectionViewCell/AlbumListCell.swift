//
//  AlbumListCell.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

class AlbumListCell: UICollectionViewCell {
    
    // MARK: Properties
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
        label.font = UIFont.SFProText(.medium, size: 12)
        label.text = ""
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = ""
        label.numberOfLines = 4
        label.font = UIFont.SFProText(.semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.setUpViews()
    }
    
    // MARK: Custom Method
    
    func configure(_ result: Album?) {
        if let resultNotNull = result {
            self.albumNameLabel.text = (resultNotNull.name ?? "").uppercased()
            self.artistNameLabel.text = resultNotNull.artistName ?? ""
            
            self.albumImageView.imageFromServerURL(urlString: resultNotNull.artworkUrl100 ?? "")
        }
    }
}

// MARK: Private Method

extension AlbumListCell {
    private func setUpViews() {
        self.addSubview(self.albumImageView)
        self.addAlbumImageViewConstraint()
        self.addSubview(gradientView)
        self.addAlphaLabelViewConstraint()
        self.addSubview(artistNameLabel)
        self.addArtistNameLabelViewConstraint()
        self.addSubview(albumNameLabel)
        self.addAlbumNameLabelViewConstraint()
        self.applyGradient()
    }
    
    private func addAlbumImageViewConstraint() {
        self.albumImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.albumImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.albumImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.albumImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func addArtistNameLabelViewConstraint() {
        self.artistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        self.artistNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        self.artistNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
    }
    
    private func addAlbumNameLabelViewConstraint() {
        self.albumNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        self.albumNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        self.albumNameLabel.bottomAnchor.constraint(equalTo: self.artistNameLabel.topAnchor, constant: -1).isActive = true
    }
    
    private func addAlphaLabelViewConstraint() {
        self.gradientView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.gradientView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.gradientView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    private func applyGradient() {
        DispatchQueue.main.async {
            self.gradientView.layer.sublayers?.filter{$0 is CAGradientLayer}.forEach{ $0.removeFromSuperlayer()
            }
            let startColor =  UIColor.black.withAlphaComponent(0.0).cgColor
            let endColor = UIColor.black.withAlphaComponent(0.75).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [startColor, endColor]
            gradientLayer.locations = [0.0,1.0]
            gradientLayer.frame = self.gradientView.bounds
            self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        }
    }
}
