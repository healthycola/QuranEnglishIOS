//
//  LoadingScreen.swift
//  QuranEnglish
//
//  Created by Aamir Jawaid on 2018-06-16.
//  Copyright © 2018 Aamir Jawaid. All rights reserved.
//

import UIKit

class LoadingScreen: UIViewController {
    @IBOutlet private weak var errorContainer: UIView!
    @IBOutlet private weak var error: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    fileprivate func setSpinnerVisibility() {
        spinner.isHidden = !QuranDocument.shared().loading
    }
    
    fileprivate func setErrorVisibility(error: Error?) {
        if let error = error {
            errorContainer.isHidden = false
            self.error.text = error.localizedDescription
        } else {
            errorContainer.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpinnerVisibility()
        QuranDocument.shared().initialize { (error) in
            self.setErrorVisibility(error: error)
            self.setSpinnerVisibility();
            guard error == nil else {
                return
            }
            
            let viewController = UIStoryboard(name: "Surah", bundle: nil).instantiateViewController(withIdentifier: "SurahTable") as! SurahTableViewController
            viewController.quran = QuranDocument.shared().quran!
            let navController = UINavigationController(rootViewController: viewController)
            self.present(navController, animated: true)
        }
    }
}
