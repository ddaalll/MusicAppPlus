//
//  Music.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.


import UIKit

//MARK: - 데이터 모델



struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}


final class Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    var isSaved: Bool = false  // 좋아요 버튼 컨트롤
    

    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
    
    var releaseDateString: String? {
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else {
            return ""
        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}
