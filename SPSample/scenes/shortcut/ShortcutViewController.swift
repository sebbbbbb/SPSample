//
//  ShortcutViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 22/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

/// Usefull links :
/// https://nshipster.com/uikeycommand/
/// https://useyourloaf.com/blog/adding-hardware-keyboard-shortcuts/
class ShortcutViewController: UIViewController {
  
  /// List of current screen shortcut
  /// ⚠️ Modifier flags can be empty
  /// ⚠️ When working on simulator some shortcut may not work because they are already mapped to an already macOS existing one
  override var keyCommands: [UIKeyCommand]? {
    return [
      UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(selectTab(sender:)), discoverabilityTitle: "Previous"),
      UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(selectTab(sender:)), discoverabilityTitle: "Next"),
      UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: .command, action: #selector(selectTab(sender:)), discoverabilityTitle: "+ 10s"),
      UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: .command, action: #selector(selectTab(sender:)), discoverabilityTitle: "- 10s"),
      UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(selectTab(sender:)), discoverabilityTitle: "Fermer le player"),
      UIKeyCommand(input: " ", modifierFlags: [], action: #selector(selectTab(sender:)), discoverabilityTitle: "Mettre en pause"),
    ]
  }
  
  /// should be overrided to take into account user shortcut selecition (not needed all th time ...)
  override var canBecomeFirstResponder: Bool { return true }
  
  @objc func selectTab(sender: UIKeyCommand) {
    let selectedTab = sender.input
    debugPrint(sender)
  }
}
