//
//  ViewController.swift
//  LocalNotifications
//
//  Created by yasudamasato on 2022/01/02.
//

import UIKit
import UserNotifications

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
    content.categoryIdentifier = "selectCategory"

    let okAction = UNNotificationAction(identifier: "okAction", title: "OK", options: [.foreground])
    let ngAction = UNNotificationAction(identifier: "ngAction", title: "NG", options: [.destructive, .foreground])
    let category = UNNotificationCategory(
      identifier: "selectCategory",
      actions: [okAction, ngAction],
      intentIdentifiers: [],
      options: []
    )

    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories([category])
    center.delegate = self
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        print("通知許可")
      } else {
        print("通知拒否")
      }
    }

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: "testID", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
}

extension ViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {

      switch response.actionIdentifier {
      case "okAction":
        print("did tap ok")
      case "ngAction":
        print("did tap ng")
      default:
        break
      }
      completionHandler()
  }
}
