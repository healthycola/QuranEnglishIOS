//
//  ViewController.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2017-06-02.
//  Copyright © 2017 Aamir Jawaid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var parser = QuranParser()
    var arabicSurahs = [Surah]()
    var translatedSurahs = [Surah]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        dowork()
    }
    
    func dowork() {
        parser.parse() { (arabicSurahs, translatedSurahs) in
            self.arabicSurahs = arabicSurahs
            self.translatedSurahs = translatedSurahs
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arabicSurahs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arabicSurahs[section].ayas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arabicCell", for: indexPath) as! ArabicCell
        cell.label.text = arabicSurahs[indexPath.section].ayas[indexPath.row].text
        cell.translatedLabel.text = translatedSurahs[indexPath.section].ayas[indexPath.row].text
        return cell
    }
}

class ArabicCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
}
