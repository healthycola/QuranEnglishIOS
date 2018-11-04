//
//  SurahNotes.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-10-28.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

enum NotesData {
    case aya(surahIndex: Int, ayaIndex: Int)
    case note(note: String)
}

class SurahNotesViewController: UIViewController {
    @IBOutlet private weak var noteTextView: UITextView! {
        didSet {
            let theme = SettingsManager.shared.theme
            noteTextView.backgroundColor = theme.secondaryBackgroundColor
            noteTextView.textColor = theme.foreground
            noteTextView.font = UIFont.englishFont(englishFont: .OpenSans, size: 15)
            noteTextView.layer.borderWidth = 1
            noteTextView.layer.borderColor = theme.foreground.withAlphaComponent(0.1).cgColor;
            noteTextView.layer.cornerRadius = 5
            updateTextViewSize()
        }
    }
    @IBOutlet weak var addNotesHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setupWithFontAwesome(text: FontAwesome.commentAlt, theme: SettingsManager.shared.theme)
            sendButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        }
    }
    @IBOutlet weak var addSurahButton: UIButton! {
        didSet {
            addSurahButton.setupWithFontAwesome(text: FontAwesome.plus, theme: SettingsManager.shared.theme)
        }
    }
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerSurahViewCell()
            tableView.tableFooterView = UIView()
        }
    }
    
    fileprivate var data: [NotesData] = []
    fileprivate var quran: Quran!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
    }
    
    private func setupTheme() {
        let theme = SettingsManager.shared.theme
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        notesTableView.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.barStyle
        navigationController?.navigationBar.barTintColor  = theme.backgroundColor;
        navigationController?.navigationBar.tintColor = theme.primaryTint
    }
    
    fileprivate func updateTextViewSize() {
        let amountOfLinesToBeShown:CGFloat = 6
        let maxHeight:CGFloat = noteTextView.font!.lineHeight * amountOfLinesToBeShown
        
        let size = noteTextView.sizeThatFits(CGSize(width: noteTextView.frame.width, height: maxHeight))
        let textViewHeight = min(size.height, maxHeight)
        
        addNotesHeight.constant = textViewHeight + 10
    }
    
    @objc private func addNote() {
        data.append(NotesData.note(note: noteTextView.text))
        noteTextView.text = ""
        updateTextViewSize()
        tableView.reloadData()
    }
}

extension SurahNotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewSize()
    }
}

extension SurahNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch data[indexPath.row] {
        case .aya(let surahIndex, let ayaIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: SurahViewCell.reuseIdentifier, for: indexPath) as! SurahViewCell
            
            cell.setup(theme: SettingsManager.shared.theme, arabicText: quran.surahs[surahIndex].ayas[ayaIndex].text, index: ayaIndex, translation: quran.translation?.surahs[surahIndex].ayas[ayaIndex].text, isBookmarked: false)
            
            return cell
        case .note(let note):
            let cell = tableView.dequeueReusableCell(withIdentifier: SurahNoteTableViewCell.reusableIdentifier, for: indexPath) as! SurahNoteTableViewCell
            cell.setup(noteText: note, theme: SettingsManager.shared.theme)
            return cell
        }
    }
}

extension UIViewController {
    func pushSurahNotesController(quran: Quran, data: [NotesData]) {
        let viewController = UIStoryboard(name: "Surah", bundle: nil).instantiateViewController(withIdentifier: "SurahNotes") as! SurahNotesViewController
        viewController.quran = quran
        viewController.data = data
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

class SurahNoteTableViewCell: UITableViewCell {
    public static let reusableIdentifier = "SurahNoteCell"
    
    @IBOutlet private weak var notesLabel: UILabel!
    
    func setup(noteText: String, theme: Theme) {
        backgroundColor = theme.backgroundColor
        notesLabel.textColor = theme.foreground
        setNotesText(noteText)
    }
    
    private func setNotesText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.currentEnglishFont(isItalic: true), range: NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        self.notesLabel.attributedText = attributedString
    }
}
