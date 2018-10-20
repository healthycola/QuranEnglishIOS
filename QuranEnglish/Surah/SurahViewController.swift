//
//  SurahView.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit

class SurahViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 80;
        }
    }
    fileprivate var titleTopConstraint: NSLayoutConstraint?
    fileprivate var navigationTitleLabel: UILabel?
    fileprivate var navigationTitleContainer: UIView?
    fileprivate var headerLabel: UILabel!
    
    var quran: Quran!
    var surahIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = constructHeader()
        setTableHeaderView(with: headerView)
        
        setupNavigationTitle()
    }
    
    fileprivate func setTableHeaderView(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = view
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            view.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor)
        ])
        
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = tableView.tableHeaderView
    }
    
    fileprivate func constructHeader() -> UIView {
        let label = UILabel();
        label.textAlignment = .center
        label.font = UIFont.arabicFont(arabicFont: .AlNileBold, size: 45)
        label.text = getSurahMetadata().arabicName
        label.sizeToFit()
        
        let englishLabel = UILabel();
        englishLabel.textAlignment = .center
        englishLabel.font = UIFont.systemFont(ofSize: 14)
        englishLabel.text = getSurahMetadata().translatedName
        [label, englishLabel].forEach { $0.sizeToFit() }
        
        let borderContainer = UIView()
        let border = BorderView(borderType: .Horizontal, length: 200)
        border.backgroundColor = UIColor.gray
        borderContainer.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            border.centerXAnchor.constraint(equalTo: borderContainer.centerXAnchor),
            border.topAnchor.constraint(equalTo: borderContainer.topAnchor, constant: 10)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [label, englishLabel, borderContainer])
        stackView.axis = .vertical
    
        headerLabel = label
        
        return stackView
    }
    
    fileprivate func setupNavigationTitle() {
        let titleContainer = UIView()
        let arabicLabel = UILabel()
        titleContainer.addSubview(arabicLabel)
        arabicLabel.attributedText = getArabicTitleAttributedText(for: getSurahMetadata().arabicName, with: 35)
        arabicLabel.translatesAutoresizingMaskIntoConstraints = false
        arabicLabel.sizeToFit()
        let containerHeight = arabicLabel.frame.height
        NSLayoutConstraint.activate([
            arabicLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            arabicLabel.widthAnchor.constraint(equalTo: titleContainer.widthAnchor)
            ])
        titleTopConstraint = arabicLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor)
        titleTopConstraint?.isActive = true
        titleContainer.clipsToBounds = true
        navigationItem.titleView = titleContainer
        titleTopConstraint?.constant = containerHeight
        
        navigationTitleLabel = arabicLabel
        navigationTitleContainer = titleContainer
    }
    
    fileprivate func getSurah() -> Surah {
        return quran.surahs[surahIndex]
    }
    
    fileprivate func getSurahMetadata() -> SurahMetadata {
        return quran.metadata[surahIndex]
    }
    
    fileprivate func getTranslation() -> Surah? {
        return quran.translation?.surahs[surahIndex]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSurah().ayas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surahViewCell", for: indexPath) as! SurahViewCell
        cell.setup(arabicText: getSurah().ayas[indexPath.row].text, translation: getTranslation()?.ayas[indexPath.row].text)
        
        return cell
    }
    
    private func getArabicTitleAttributedText(for text: String, with size: CGFloat = 30) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.arabicFont(arabicFont: .AlNileBold, size: size), range: NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        return attributedString
    }
    
    private func getEnglishTitleAttributedText(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}

extension SurahViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationLabel = navigationTitleLabel, let navigationContainer = navigationTitleContainer else {
            return
        }
        let headerViewTitleRectInScrollView = headerLabel.convert(headerLabel.frame, to: scrollView)
        let offset = headerViewTitleRectInScrollView.minY - scrollView.bounds.origin.y
        navigationLabel.accessibilityElementsHidden = offset > 0
        let scaledOffset = (offset / headerViewTitleRectInScrollView.height) * navigationLabel.frame.height
        titleTopConstraint?.constant = max(0, min(navigationContainer.frame.maxY, navigationContainer.frame.maxY + scaledOffset))
    }
}

class SurahViewCell: UITableViewCell {
    @IBOutlet private weak var arabicText: UILabel!
    @IBOutlet private weak var translation: UILabel!
    
    func setup(arabicText: String, translation: String?) {
        setArabicText(arabicText)
        setTranslationText(translation)
    }
    
    private func setArabicText(_ arabicText: String) {
        let attributedString = NSMutableAttributedString(string: arabicText)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        paragraphStyle.alignment = .right
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.arabicFont(arabicFont: .AlBayan, size: 30), range: NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        self.arabicText.attributedText = attributedString
    }
    
    private func setTranslationText(_ text: String?) {
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.englishFont(englishFont: .Palatino, size: 15), range: NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.translation.attributedText = attributedString
        } else {
            self.translation.text = ""
        }
    }
}
