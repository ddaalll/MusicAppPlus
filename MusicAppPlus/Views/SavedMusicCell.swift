//
//  SavedMusicCell.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.
//

import UIKit

class SavedMusicCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releseDateLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var savedDateLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: UILabel!
    
    
    @IBOutlet weak var updateButton: UIButton!
    
    var musicSaved: MusicSaved? {
        didSet{
            configureUIwithData()
        }
    }
    
    var saveButtonPressed: ((SavedMusicCell) -> ()) = { (sender) in }
    
    var updateButtonPressed: ((SavedMusicCell, String?) -> ()) = { (sender, text) in }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUpdateButton()
    }

    
    private func setupUpdateButton() {
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUIwithData() {
        guard let musicSaved = musicSaved else { return }
        loadImage(with: musicSaved.imageUrl)
        songNameLabel.text = musicSaved.songName
        artistNameLabel.text = musicSaved.artistName
        albumNameLabel.text = musicSaved.albumName
        releseDateLabel.text = musicSaved.releaseDate
        savedDateLabel.text = "Saved Date: \(musicSaved.savedDateString ?? "")"
        commentMessageLabel.text = musicSaved.myMessage
        setButtonStatus()
        
        
    }
    
    private func loadImage(with imagerUrl: String?) {
        guard let urlString = imagerUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButtonPressed(self)
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self, musicSaved?.myMessage)
    }
    
    func setButtonStatus() {
        saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        saveButton.tintColor = .red
    }
    
    
}
