//
//  ViewController.swift
//  LocalNotifications
//
//  Created by yasudamasato on 2022/01/02.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func didTapNotification(_ sender: Any) {
    let content = UNMutableNotificationContent()
    content.title = "title"
    content.subtitle = "subtitle"
    content.body = "body"
    content.sound = .default

    let request = UNNotificationRequest(identifier: "testID", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
}
