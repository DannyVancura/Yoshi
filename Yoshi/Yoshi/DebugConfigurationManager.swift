//
//  DebugConfigurationManager.swift
//  Yoshi
//
//  Created by Michael Campbell on 12/22/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import UIKit

internal class DebugConfigurationManager {

    static let sharedInstance = DebugConfigurationManager()

    var currentDate = NSDate()
    var inDebugMenu: Bool = false
    let debugAlertController = UIAlertController(title: "Yoshi Debug", message: nil, preferredStyle: .ActionSheet)
    var yoshiMenuItems = [YoshiMenu]()
    var presentingViewController: UIViewController?

    func setupDebugMenuOptions(menuItems: [YoshiMenu]) {
        self.yoshiMenuItems = menuItems

        for menu in self.yoshiMenuItems {
            switch menu.menuType {
            case .TableView:
                guard let tableViewAction = self.tableViewAction(menu) else { continue }
                self.debugAlertController.addAction(tableViewAction)
            case .DateSelector:
                guard let datePickerAction = self.dateSelectorAction(menu) else { continue }
                self.debugAlertController.addAction(datePickerAction)
            case .CustomMenu:
                guard let customMenuAction = self.customMenuAction(menu) else { continue }
                self.debugAlertController.addAction(customMenuAction)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) -> Void in
            self.inDebugMenu = false
        }
        self.debugAlertController.addAction(cancelAction)
    }

    func showDebugActionSheetFromViewController(viewController: UIViewController) {
        self.presentingViewController = viewController
        viewController.presentViewController(self.debugAlertController, animated: true, completion: nil)
        self.inDebugMenu = true
    }

    // MARK: Private Methods

    private func presentViewController(viewControllerToDisplay: UIViewController) {
        guard let presentingViewController = self.presentingViewController else { return }
        presentingViewController.presentViewController(viewControllerToDisplay, animated: true, completion: { () -> Void in
            self.inDebugMenu = false
        })
    }

    private func dismiss(viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(true) { () -> Void in
            self.inDebugMenu = false
        }
    }

    private func tableViewAction(menu: YoshiMenu) -> UIAlertAction? {
        guard let menu = menu as? YoshiTableViewMenu else { return nil }
        return UIAlertAction(title: menu.debugMenuName, style: .Default) { (_) -> Void in
            let bundle = NSBundle(forClass: DebugConfigurationManager.self)
            let tableViewController = DebugTableViewController(nibName: DebugTableViewController.nibName(), bundle: bundle)
            tableViewController.modalPresentationStyle = .FullScreen
            tableViewController.setup(menu)
            tableViewController.delegate = self
            self.presentViewController(tableViewController)
        }
    }

    private func dateSelectorAction(menu: YoshiMenu) -> UIAlertAction? {
        guard let menu = menu as? YoshiDateSelectorMenu else { return nil }
        return UIAlertAction(title: menu.debugMenuName, style: .Default, handler: { (_) -> Void in
            let bundle = NSBundle(forClass: DebugConfigurationManager.self)
            let datePickerViewController = DebugDatePickerViewController(nibName: DebugDatePickerViewController.nibName(), bundle: bundle)
            datePickerViewController.setup(menu)
            datePickerViewController.delegate = self
            datePickerViewController.date = self.currentDate
            self.presentViewController(datePickerViewController)
        })
    }

    private func customMenuAction(menu: YoshiMenu) -> UIAlertAction? {
        guard let menu = menu as? YoshiCustomMenu else { return nil }
        menu.setup()
        return UIAlertAction(title: menu.debugMenuName, style: .Default) { (_) -> Void in
            menu.completion()
            self.inDebugMenu = false
        }
    }

}

// MARK: DebugDatePickerViewControllerDelegate

extension DebugConfigurationManager: DebugDatePickerViewControllerDelegate {

    func didUpdateDate(date: NSDate) {
        self.currentDate = date
    }

    func shouldDismissDatePickerView(viewController: UIViewController) {
        self.dismiss(viewController)
    }

}

// MARK: DebugTableViewControllerDelegate

extension DebugConfigurationManager: DebugTableViewControllerDelegate {

    func shouldDismissDebugTableView(viewController: UIViewController) {
        self.dismiss(viewController)
    }
    
}
