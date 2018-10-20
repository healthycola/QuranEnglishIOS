//
//  SurahViewController.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-06-17.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import UIKit

class SurahTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var quran: Quran!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let settingsButton = UIBarButtonItem.getFontAwesomeBarButton(icon: .cog, size: 18)
        settingsButton.target = self
        settingsButton.action = #selector(showSettingsVC)
        navigationItem.rightBarButtonItem = settingsButton
        
        navigationItem.title = "Surahs"
        
        SettingsManager.shared.addObserver(self)
    }
    
    deinit {
        SettingsManager.shared.removeObserver(self)
    }
    
    @objc
    private func showSettingsVC() {
        let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quran.surahs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "surahCell") as! SurahCell
        let metadata = quran.metadata
        tableViewCell.arabicLabel.text = metadata[indexPath.row].arabicName
        tableViewCell.translatedLabel.text = metadata[indexPath.row].translatedName
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Surah", bundle: nil).instantiateViewController(withIdentifier: "SurahView") as! SurahViewController
        viewController.quran = self.quran
        viewController.surahIndex = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SurahTableViewController: SettingsObserver {
    func receiveNotification(updatedSetting: Setting) {
        tableView.reloadData()
    }
}

class SurahCell: UITableViewCell {
    @IBOutlet weak var arabicLabel: UILabel! {
        didSet {
            arabicLabel.font = UIFont.currentArabicFont()
        }
    }
    @IBOutlet weak var translatedLabel: UILabel! {
        didSet {
            translatedLabel.font = UIFont.currentEnglishFont()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        arabicLabel.font = UIFont.currentArabicFont()
        translatedLabel.font = UIFont.currentEnglishFont()
    }
}
