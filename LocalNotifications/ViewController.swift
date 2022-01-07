//
//  ViewController.swift
//  LocalNotifications
//
//  Created by yasudamasato on 2022/01/02.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

  @IBOutlet private weak var datePicker: UIDatePicker! {
    didSet {
      datePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
      datePicker.locale = Locale(identifier: "ja_JP")
    }
  }

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
    let textInputAction = UNTextInputNotificationAction(
      identifier: "inputAction",
      title: "テキスト入力",
      options: [],
      textInputButtonTitle: "送信",
      textInputPlaceholder: "テキストを入力"
    )
    let category = UNNotificationCategory(
      identifier: "selectCategory",
      actions: [okAction, ngAction, textInputAction],
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

    let components = Calendar.current.dateComponents(in: TimeZone.current, from: datePicker.date)
    let triggerDate = DateComponents(
      month: components.month,
      day: components.day,
      hour: components.hour,
      minute: components.minute,
      second: components.second
    )
    print("components: \(components)")
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
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
      case "inputAction":
        if let response = response as? UNTextInputNotificationResponse {
          print(response.userText)
        }
      default:
        break
      }
      completionHandler()
  }
}
