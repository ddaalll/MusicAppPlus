//
//  CoreDataManager.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "MusicSaved"
    
    func getMusicSavedArrayFromCoreData() -> [MusicSaved] {
        var savedMusicList: [MusicSaved] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let savedDate = NSSortDescriptor(key: "savedDate", ascending: true)
            request.sortDescriptors = [savedDate]
            
            do {
                if let fetchedMusicList = try context.fetch(request) as? [MusicSaved] {
                    savedMusicList = fetchedMusicList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
        
        return savedMusicList
    }
    
    func saveMusic(with music: Music, message: String?, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let musicSaved = NSManagedObject(entity: entity, insertInto: context) as? MusicSaved {
                    musicSaved.songName = music.songName
                    musicSaved.artistName = music.artistName
                    musicSaved.albumName = music.albumName
                    musicSaved.imageUrl = music.imageUrl
                    musicSaved.releaseDate = music.releaseDateString
                    musicSaved.savedDate = Date()
                    musicSaved.myMessage = message
                    
                    appDelegate?.saveContext()
                    
                }
            }
        }
        completion()
    }
    
    func deleteMusic(with music: MusicSaved, completion: @escaping () -> Void) {
        guard let savedDate = music.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                if let fetchedMusicList = try context.fetch(request) as? [MusicSaved] {
                    if let targetMusic = fetchedMusicList.first {
                        context.delete(targetMusic)
                        
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    func updateMusic(with music: MusicSaved, completion: @escaping () -> Void) {
        guard let savedDate = music.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                if let fetchMusicList = try context.fetch(request) as? [MusicSaved] {
                    if var targetMusic = fetchMusicList.first {
                        targetMusic = music
                        
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("업데이트 실패")
                completion()
            }
        }
    }
}
