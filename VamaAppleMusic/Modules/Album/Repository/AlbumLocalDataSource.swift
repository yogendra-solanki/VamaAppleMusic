//
//  AlbumLocalDataSource.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import RealmSwift

class AlbumLocalDataSource {
    
    func addAlbumFeed(feed: AlbumFeed) {
        RealmManager.add(feed)
    }
    
    func fetchAlbums() -> List<Album>? {
        let feeds = fetchAlbumFeed()
        guard let feed = feeds?.first else { return nil }
        return feed.albums
    }
    
    func fetchCopyrightInfo() -> String? {
        let feeds = fetchAlbumFeed()
        guard let feed = feeds?.first else { return nil }
        return feed.copyright
    }
    
    func deleteAlbumFeed() {
        RealmManager.clearAllData()
    }
    
    private func fetchAlbumFeed() -> Results<AlbumFeed>? {
        return RealmManager.objects(AlbumFeed.self)
    }
}
