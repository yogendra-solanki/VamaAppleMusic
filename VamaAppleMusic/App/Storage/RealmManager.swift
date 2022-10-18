//
//  RealmManager.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Realm
import RealmSwift

class RealmManager {

    static func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        do {
            let realm = try Realm()
            realm.refresh()
            return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }

    static func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        do {
            let realm = try Realm()
            realm.refresh()
            return realm.object(ofType: type, forPrimaryKey: key)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }

    static func add<T: Object>(_ data: [T], update: Bool = true) {
        do {
            let realm = try Realm()
            realm.refresh()
            if realm.isInWriteTransaction {
                realm.add(data, update: (update ? .modified : .all))
            } else {
                try? realm.write {
                    realm.add(data, update: (update ? .modified : .all))
                }
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }

    static func add<T: Object>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }

    static func delete<T: Object>(_ data: [T]) {
        do {
            let realm = try Realm()
            realm.refresh()
            try? realm.write { realm.delete(data) }
        }  catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }

    static func delete<T: Object>(_ data: T) {
        delete([data])
    }

    static func clearAllData() {
        do {
            let realm = try Realm()
            realm.refresh()
            try? realm.write { realm.deleteAll() }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
}

extension RealmManager {
    static func configureRealm() {
        let fileManager = FileManager.default
        var config = Realm.Configuration()
        
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        if let applicationSupportURL = urls.last {
            do {
                try fileManager.createDirectory(at: applicationSupportURL, withIntermediateDirectories: true, attributes: nil)
                config.fileURL = applicationSupportURL.appendingPathComponent("VamaAppleMusic.realm")
            } catch let err {
                print(err)
            }
        }
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
