//
//  SavedListViewController.swift
//  MusicApp2
//
//  Created by DalHyun Nam on 2023/04/12.
//

import UIKit

class SavedListViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    let musicManager = MusicManager.shared
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavibar()
        setupTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNavibar() {
        self.title = "Saved Music List"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UINib(nibName: Cell.savedMusicCellidentifier, bundle: nil), forCellReuseIdentifier: Cell.savedMusicCellidentifier)
    }

}

extension SavedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicManager.getMusicDatasFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.savedMusicCellidentifier, for: indexPath) as! SavedMusicCell
        
        let musicSaved = self.musicManager.getMusicDatasFromCoreData()[indexPath.row]
        cell.musicSaved = musicSaved
        
        cell.saveButtonPressed = { [weak self] (senderCell) in
            guard let self = self else { return }
            self.makeRemoveCheckAlert { okAction in
                if okAction {
                    self.musicManager.deleteMusicFromCoreData(with: musicSaved) {
                        self.tableView.reloadData()
                        print("삭제 및 테이블뷰 리로드 완료")
                    }
                } else {
                    print("삭제 취소")
                }
            }
        }
        cell.updateButtonPressed = { [weak self] (senderCell, Message) in
            guard let self = self else { return }
            self.makeMessageAlert(myMessage: Message) { updatedMessage, okAction in
                if okAction {
                    senderCell.musicSaved?.myMessage = updatedMessage
                    guard let musicSaved = senderCell.musicSaved else { return }
                    self.musicManager.updateMusicToCoreData(with: musicSaved) {
                        senderCell.configureUIwithData()
                        print("셀 표시 다시하기 완료")
                    }
                } else {
                    print("업데이트 취소")
                }
            }
        }
        return cell
    }
    
    
    
    func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) {
            okAction in
            completion(true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) {
            cancelAction in
            completion(false)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func makeMessageAlert(myMessage message: String?, completion: @escaping (String?, Bool) -> Void) {
        let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요", preferredStyle: .alert)
        alert.addTextField { textField in textField.text = message }
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
        self.present(alert, animated: true)
    }
}

extension SavedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3) {
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height = self.tabBarController?.tabBar.frame.height ?? 0.0
                self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
}
