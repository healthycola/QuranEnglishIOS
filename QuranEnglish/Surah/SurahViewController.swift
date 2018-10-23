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
    private static let offsetFromTopOfNavigationTitleHeader: CGFloat = 10
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 80;
        }
    }
    fileprivate var titleTopConstraint: NSLayoutConstraint?
    fileprivate var translatedTitleTopConstraint: NSLayoutConstraint?
    fileprivate var navigationTitleLabel: UILabel?
    fileprivate var navigationTitleContainer: UIView?
    fileprivate var headerLabel: UILabel!
    
    var quran: Quran!
    var surahIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        
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
        label.textColor = SettingsManager.shared.theme.foreground
        label.font = UIFont.arabicFont(arabicFont: .AlNileBold, size: 45)
        label.text = getSurahMetadata().arabicName
        label.sizeToFit()
        
        let borderContainer = UIView()
        let border = BorderView(borderType: .Horizontal, length: 200)
        border.backgroundColor = UIColor.gray
        borderContainer.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            border.centerXAnchor.constraint(equalTo: borderContainer.centerXAnchor),
            border.topAnchor.constraint(equalTo: borderContainer.topAnchor),
            border.bottomAnchor.constraint(equalTo: borderContainer.bottomAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [label, borderContainer])
        stackView.axis = .vertical
    
        headerLabel = label
        
        return stackView
    }
    
    fileprivate func setupNavigationTitle() {
        let titleContainer = UIView()
        let arabicLabel = UILabel()
        arabicLabel.attributedText = getArabicTitleAttributedText(for: getSurahMetadata().arabicName, with: 35)
        arabicLabel.textColor = SettingsManager.shared.theme.foreground

        let englishLabel = UILabel()
        englishLabel.text = getSurahMetadata().translatedName
        englishLabel.font = UIFont.boldSystemFont(ofSize: 17)
        englishLabel.textColor = SettingsManager.shared.theme.foreground
        
        titleContainer.addSubview(englishLabel)
        titleContainer.addSubview(arabicLabel)
        
        englishLabel.sizeToFit()
        arabicLabel.sizeToFit()
        let containerHeight = arabicLabel.frame.height + englishLabel.frame.height
        
        arabicLabel.translatesAutoresizingMaskIntoConstraints = false
        englishLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arabicLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            arabicLabel.widthAnchor.constraint(equalTo: titleContainer.widthAnchor),
            englishLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            englishLabel.widthAnchor.constraint(equalTo: titleContainer.widthAnchor),
            ])
        titleTopConstraint = arabicLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor)
        titleTopConstraint?.isActive = true
        translatedTitleTopConstraint = englishLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: SurahViewController.offsetFromTopOfNavigationTitleHeader)
        translatedTitleTopConstraint?.isActive = true
        
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surahViewCell", for: indexPath) as! SurahViewCell
        cell.setup(
            theme: SettingsManager.shared.theme,
            arabicText: getSurah().ayas[indexPath.row].text,
            index: indexPath.row + 1,
            translation: getTranslation()?.ayas[indexPath.row].text
        )
        
        return cell
    }
    
    private func getArabicTitleAttributedText(for text: String, with size: CGFloat = 30) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.arabicFont(arabicFont: .AlNileBold, size: size), range: NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        return attributedString
    }
    
    private func getEnglishTitleAttributedText(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, attributedString.length))
        return attributedString
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

extension SurahViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationLabel = navigationTitleLabel, let navigationContainer = navigationTitleContainer else {
            return
        }
        let headerViewTitleRectInScrollView = headerLabel.convert(headerLabel.frame, to: scrollView)
        let offset = headerViewTitleRectInScrollView.minY - scrollView.bounds.origin.y
        navigationLabel.accessibilityElementsHidden = offset > 0
        let scaledOffset = (offset / headerViewTitleRectInScrollView.height) * navigationContainer.frame.height
        let labelOffset = max(0, min(navigationContainer.frame.maxY, navigationContainer.frame.maxY + scaledOffset))
        titleTopConstraint?.constant = labelOffset
        
        translatedTitleTopConstraint?.constant = min(SurahViewController.offsetFromTopOfNavigationTitleHeader, labelOffset - navigationContainer.frame.maxY + SurahViewController.offsetFromTopOfNavigationTitleHeader)
    }
}

class SurahViewCell: UITableViewCell {
    @IBOutlet private weak var arabicText: UILabel!
    @IBOutlet private weak var translation: UILabel!
    @IBOutlet private weak var index: UILabel!
    @IBOutlet private weak var secondaryBackground: UIView!
    @IBOutlet private weak var secondaryBackgroundShadow: UIView!
    
    func setup(theme: Theme, arabicText: String, index: Int, translation: String?) {
        backgroundColor = theme.backgroundColor
        secondaryBackground.backgroundColor = theme.secondaryBackgroundColor
        secondaryBackgroundShadow.backgroundColor = theme.foreground
        self.arabicText.textColor = theme.foreground
        self.translation.textColor = theme.foreground
        self.index.textColor = theme.foreground
        
        setArabicText(arabicText)
        setTranslationText(translation)
        self.index.text = String(index)
    }
    
    private func setArabicText(_ arabicText: String) {
        let attributedString = NSMutableAttributedString(string: arabicText)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        paragraphStyle.alignment = .right
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.currentArabicFont(), range: NSMakeRange(0, attributedString.length))
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
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.currentEnglishFont(), range: NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.translation.attributedText = attributedString
        } else {
            self.translation.text = ""
        }
    }
}
