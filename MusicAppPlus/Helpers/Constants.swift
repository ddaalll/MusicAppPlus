//
//  Constants.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.
//

import UIKit

public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=movie"
}


public struct Cell {
    static let musicCellIdentifier = "MusicCell"
    static let savedMusicCellidentifier = "SavedMusicCell"
    private init() {}
}

public struct CVCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}
