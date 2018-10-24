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
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 60;
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        
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
        tableViewCell.setupForTheme(theme: SettingsManager.shared.theme)
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
    
    fileprivate func setupTheme() {
        let theme = SettingsManager.shared.theme
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.barStyle
        navigationController?.navigationBar.barTintColor  = theme.backgroundColor;
        navigationController?.navigationBar.tintColor = theme.primaryTint
    }
}

extension SurahTableViewController: SettingsObserver {
    func receiveNotification(updatedSetting: Setting) {
        switch updatedSetting {
        case .theme:
            setupTheme()
            break
        default:
            break
        }
        tableView.reloadData()
    }
}

class SurahCell: UITableViewCell {
    func setupForTheme(theme: Theme) {
        backgroundColor = theme.backgroundColor
        arabicLabel.font = UIFont.currentArabicFont()
        arabicLabel.textColor = theme.foreground
        translatedLabel.font = UIFont.currentEnglishFont()
        translatedLabel.textColor = theme.foreground
    }
    
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
}
