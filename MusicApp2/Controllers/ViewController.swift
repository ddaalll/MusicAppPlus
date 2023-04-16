//
//  ViewController.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/11.
//

import UIKit

class ViewController: UIViewController {

    
    let searchController = UISearchController()
    
    @IBOutlet weak var musicTableView: UITableView!
    
    let musicManager = MusicManager.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNaviBar()
        setupSearchBar()
        setupTableView()
        setupDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        musicTableView.reloadData()
    }
    
    func setupNaviBar() {
        self.title = "Music Search"
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupTableView() {
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }
    
    func setupDatas() {
        musicManager.setupDatasFromAPI {
            DispatchQueue.main.async {
                self.musicTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicManager.getMusicArraysFromAPI().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        let music = musicManager.getMusicArraysFromAPI()[indexPath.row]
        cell.music = music
        
        cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
            guard let self = self else { return }
            if !isSaved {
                self.makeMessageAlert { text, savedAction in
                    if savedAction {
                        self.musicManager.saveMusicData(with: music, messege: text) {
                            senderCell.music?.isSaved = true
                            senderCell.setButtonStatus()
                            print("저장됨")
                        }
                    } else {
                        print("취소됨")
                    }
                }
            } else {
                self.makeRemoveCheckAlert { removeAction in
                    if removeAction {
                        self.musicManager.deleteMusic(with: music) {
                            senderCell.music?.isSaved = false
                            senderCell.setButtonStatus()
                            print("저장된 것 삭제")
                        }
                    } else {
                        print("저장된 것 삭제하기 취소됨")
                    }
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func makeMessageAlert(completion: @escaping (String?, Bool) -> Void) {
        let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요.", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "저장하려는 메세지"
        }
        var savedText: String? = ""
        let ok = UIAlertAction(title: "확인", style: .default) {
            okAction in
            savedText = alert.textFields?[0].text
            completion(savedText, true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) {
            cancelAction in
            completion(nil, false)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) {
            okAction in
            completion(true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel){
            cancelAction in
            completion(false)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3) {
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height =
                self.tabBarController?.tabBar.frame.height ?? 0.0
                self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self.tabBarController?.tabBar.frame.origin =
                CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text?.lowercased()
        else { return }
        print(text)
        musicManager.fetchDatasFromAPI(withATerm: text) {
            DispatchQueue.main.async {
                self.musicTableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
    }
}
