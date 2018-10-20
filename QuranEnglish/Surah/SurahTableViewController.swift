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
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Surahs"
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

class SurahCell: UITableViewCell {
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
}
