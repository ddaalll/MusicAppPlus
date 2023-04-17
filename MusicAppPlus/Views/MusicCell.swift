//
//  MusicCell.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLAbel: UILabel!
    @IBOutlet weak var savedButton: UIButton!
    
    
    var music: Music? {
        didSet{
            configureUIwithData()
        }
    }
    
    
    var saveButtonPressed: ((MusicCell, Bool) -> ()) = { (sender, pressed) in }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
        savedButton.tintColor = .gray
        mainImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureUIwithData() {
        guard let music = music else { return }
        loadImage(with: music.imageUrl)
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        albumNameLabel.text = music.albumName
        releaseDateLAbel.text = music.releaseDateString
        setButtonStatus()
    }
    //URL ==> image setting
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func savedButtonTapped(_ sender: UIButton) {
        guard let isSaved = music?.isSaved else { return }
        saveButtonPressed(self, isSaved)
        setButtonStatus()
    }
    
    func setButtonStatus() {
        guard let isSaved = self.music?.isSaved else { return }
        if !isSaved {
            savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            savedButton.tintColor = .gray
        } else {
            savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            savedButton.tintColor = .red
            
        }
    }
    
    
    
    
}
