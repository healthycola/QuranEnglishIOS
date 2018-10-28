//
//  SurahView.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-13.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import FontAwesome_swift
import UIKit
import SwipeCellKit

class SurahViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private static let offsetFromTopOfNavigationTitleHeader: CGFloat = 10
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 80;
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    fileprivate var titleTopConstraint: NSLayoutConstraint?
    fileprivate var translatedTitleTopConstraint: NSLayoutConstraint?
    fileprivate var navigationTitleLabel: UILabel?
    fileprivate var navigationTitleContainer: UIView?
    fileprivate var headerLabel: UILabel!
    
    var quran: Quran!
    var surahIndex: Int!
    
    private var bookmarks: [Int : Bookmark] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        
        let headerView = constructHeader()
        setTableHeaderView(with: headerView)
        
        setupNavigationTitle()
        
        BookmarksManager.shared.bookmarks.forEach {
            guard let bookmarkSurahIndex = $0.ayametadata?.surahindex, bookmarkSurahIndex == Int16(surahIndex), let bookmarkAyaIndex = $0.ayametadata?.ayaindex else {
                return
            }
            
            let bookmarkAyaIndexInt = Int(bookmarkAyaIndex)
            self.bookmarks[bookmarkAyaIndexInt] = $0
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surahViewCell", for: indexPath) as! SurahViewCell
        cell.setup(
            theme: SettingsManager.shared.theme,
            arabicText: getSurah().ayas[indexPath.row].text,
            index: indexPath.row + 1,
            translation: getTranslation()?.ayas[indexPath.row].text,
            isBookmarked: bookmarks[indexPath.row + 1] != nil
        )
        cell.delegate = self
        
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

extension SurahViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let bookmarkAction = SwipeAction(style: .default, title: "Bookmark")
            { action, indexPath in
                let ayaIndex = indexPath.row + 1
                if let bookmark = self.bookmarks[ayaIndex] {
                    if let _ = BookmarksManager.shared.removeBookmark(bookmark) {
                        self.bookmarks.removeValue(forKey: ayaIndex)
                        let cell = tableView.cellForRow(at: indexPath) as! SurahViewCell
                        cell.setBookmark(false)
                    }
                } else {
                    if let newBookmark = BookmarksManager.shared.addBookmark(surahIndex: self.surahIndex, ayaIndex: ayaIndex) {
                        self.bookmarks[ayaIndex] = newBookmark
                        
                        let cell = tableView.cellForRow(at: indexPath) as! SurahViewCell
                        cell.setBookmark(true)
                    }
                }
            }
            
            // customize the action appearance
            bookmarkAction.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
            bookmarkAction.backgroundColor = SettingsManager.shared.theme.primaryTint
            bookmarkAction.title = String.fontAwesomeIcon(name: .bookmark)
            
            return [bookmarkAction]
        } else {
            let notesActions = SwipeAction(style: .default, title: "Notes") { action, indexPath in
                print("Notes Actions")
            }
            
            // customize the action appearance
            notesActions.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
            notesActions.backgroundColor = SettingsManager.shared.theme.secondaryTint
            notesActions.title = String.fontAwesomeIcon(name: .stickyNote)
            
            return [notesActions]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        options.expansionStyle = .selection
        options.backgroundColor = SettingsManager.shared.theme.backgroundColor
        return options
    }
}

class SurahViewCell: SwipeTableViewCell {
    @IBOutlet private weak var arabicText: UILabel!
    @IBOutlet private weak var translation: UILabel!
    @IBOutlet private weak var index: UILabel!
    @IBOutlet private weak var secondaryBackground: UIView!
    @IBOutlet private weak var secondaryBackgroundShadow: UIView!
    @IBOutlet private weak var bookmarkView: UIView!
    
    private var theme: Theme!
    
    func setup(theme: Theme, arabicText: String, index: Int, translation: String?, isBookmarked: Bool) {
        backgroundColor = theme.backgroundColor
        secondaryBackground.backgroundColor = theme.secondaryBackgroundColor
        secondaryBackgroundShadow.backgroundColor = theme.foreground
        self.theme = theme
        self.arabicText.textColor = theme.foreground
        self.translation.textColor = theme.foreground
        self.index.textColor = theme.foreground
        self.bookmarkView.backgroundColor = isBookmarked ? theme.primaryTint : UIColor.clear
        
        setArabicText(arabicText)
        setTranslationText(translation)
        self.index.text = String(index)
    }
    
    func setBookmark(_ value: Bool) {
        self.bookmarkView.backgroundColor = value ? theme.primaryTint : UIColor.clear
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
