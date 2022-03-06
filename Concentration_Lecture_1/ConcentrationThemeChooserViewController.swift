//
//  ConcentrationThemeChooserViewController.swift
//  Concentration_Lecture_1
//
//  Created by Rona Bompa on 28.02.2022.
//

import UIKit

class ConcentrationThemeChooserViewController: VCLLoggingViewController, UISplitViewControllerDelegate {

    override var vclLoggingName: String {
        return "ThemeChooser"
    }
    var themes = [
        "Sports": ["🏀","⚽️","🥎", "🏐", "🏓", "🎱", "🏉" ,"🏸","🥊","🏹"],
        "Fruits": ["🍎","🫐","🍉", "🍇", "🍍", "🥝", "🥥" ,"🍒","🍋","🍊"],
        "Animals": ["🦁","🐰","🐨", "🐔", "🦊", "🐻", "🐒" ,"🐴","🐢","🐬"]
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }

    func splitViewController (
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewCOntroller: UIViewController) -> Bool {
            if let cvc = secondaryViewController as? ConcentrationViewController {
                if cvc.themeConcentration == nil {
                    return true
                }
            }
            return false
    }


    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.themeConcentration = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.themeConcentration = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    private var lastSeguedToConcentrationViewController: ConcentrationViewController?


    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.title(for: .normal), let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.themeConcentration = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}



