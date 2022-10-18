//
//  AlbumListController.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit
import CoreData

class AlbumListController: UIViewController {
    
    // MARK: Properties
    
    private static let albumCellIdentifier = "AlbumCellIdentifier"
    
    var mainCoordinator: MainCoordinator?
    private let navigationTitle = "Top 100 Albums"
    private var albumCollectionView: UICollectionView!
    private var albumViewModel = AlbumViewModel()

    
    private let cellPadding = 16.0
    private let cellInsetTop = 10.0
    private let cellSpacing = 12.0
    private let column = 2
        
    private var cellWidthAndHeight: Double {
        return (UIScreen.width - (cellPadding * Double(column)) - cellSpacing) / Double(column)
    }
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        callApi()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addAlbumCollectionViewConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = .systemBackground
    }
    
    override func actionRightNavButton(sender: UIButton) {
        callApi()
    }
}

// MARK: Private methods

private extension AlbumListController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = navigationTitle
    }
    
    private func setUpDelegateAndDatasource() {
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
    }
    
    private func configureCollectionView(){
        
        ///create flow layout
        collectionViewFlowLayout()
        setUpDelegateAndDatasource()
        //configure collectionview
        albumCollectionView.register(AlbumListCell.self, forCellWithReuseIdentifier: AlbumListController.albumCellIdentifier)
        albumCollectionView.backgroundColor = .systemBackground
        view.addSubview(albumCollectionView)
    }
    
    private func collectionViewFlowLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellInsetTop, left: cellPadding, bottom: 0.0, right: cellPadding)
        layout.itemSize = CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        albumCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    }
    
    private func startSpinging() {
        if  albumViewModel.albums == nil{
            self.displayAnimatedActivityIndicatorView()
        }
    }
    
    private func stopSpinging() {
        DispatchQueue.main.async {
            if self.isDisplayingActivityIndicatorView() {
                self.hideAnimatedActivityIndicatorView()
            }
        }
    }
    
    private func callApi() {
        startSpinging()
        albumViewModel.fetchAndSyncAlbums {
            DispatchQueue.main.async {
                self.stopSpinging()
                self.addReloadButton()
                self.albumCollectionView.reloadData()
            }
        } failure: { message in
            DispatchQueue.main.async {
                self.stopSpinging()
                self.addReloadButton()
                self.showToastMsg(message: message, isError: true)
            }
        }
    }
    
    //Add reload button to refresh data if no data on the screen
    private func addReloadButton() {
        guard let albums = albumViewModel.albums else {
            addRightBarButton(nil, UIImage(systemName: "arrow.2.circlepath"))
            return
        }
        if albums.count > 0 {
            removeRightBarButton()
        } else {
            addRightBarButton(nil, UIImage(systemName: "arrow.2.circlepath"))
        }
    }
    
    private func addAlbumCollectionViewConstraint() {
        self.albumCollectionView.topAnchor.constraint(equalTo: self.albumCollectionView.superview!.safeAreaLayoutGuide.topAnchor, constant: UIEdgeInsets.zero.top).isActive = true
        
        self.albumCollectionView.bottomAnchor.constraint(equalTo: self.albumCollectionView.superview!.bottomAnchor, constant: UIEdgeInsets.zero.bottom).isActive = true
    }

    /// Show toast message
    /// - Parameters:
    ///   - message: message
    ///   - isError: send true if message is for error, else send false
    private func showToastMsg(message:String, isError:Bool){
        DispatchQueue.main.async {
            AppToast.show(message: message, controller: self, isError: isError)
        }
    }
}

// MARK: UICollectionViewDataSource

extension AlbumListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albums = albumViewModel.albums else { return 0 }
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let albums = albumViewModel.albums else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListController.albumCellIdentifier, for: indexPath) as? AlbumListCell
        cell?.configure(albums[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate

extension AlbumListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albums = albumViewModel.albums else { return }
        mainCoordinator?.coordinateToAlbumDetail(album: albums[indexPath.row])
    }
}

