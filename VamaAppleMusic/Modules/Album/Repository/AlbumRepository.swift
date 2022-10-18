//
//  AlbumRepository.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import RealmSwift

class AlbumRepository {
    
    // MARK: - Properties
    
    let localDataSource = AlbumLocalDataSource()
    let remoteDataSource = AlbumRemoteDataSource()
    
    // MARK: - Fetch Methods
    
    /// fetchAndSyncAlbums from remote datasource and sync the local database
    /// - Parameters:
    ///   - success: success
    ///   - failure: failure
    func fetchAndSyncAlbums(success: @escaping (() -> Void), failure: @escaping ((String) -> Void)) {
        remoteDataSource.fetchAlbumFeed { feed in
            self.localDataSource.deleteAlbumFeed()
            self.localDataSource.addAlbumFeed(feed: feed)
            success()
        } failure: { errorMessage in
            failure(errorMessage)
        }
    }
    
    /// Fetch albums from local database
    /// - Returns: albums list
    func fetchAlbums() -> List<Album>? {
        return localDataSource.fetchAlbums()
    }
    
    /// fetchCopyrightInfo
    /// - Returns: copyright text
    func fetchCopyrightInfo() -> String? {
        return localDataSource.fetchCopyrightInfo()
    }
}
