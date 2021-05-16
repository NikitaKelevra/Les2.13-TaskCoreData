//
//  AppDelegate.swift
//  Les2.13-TaskCoreData
//
//  Created by Сперанский Никита on 11.05.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)  // инициализация границ экрана Виндоу
        window?.makeKeyAndVisible()
        //определяем СТАРТОВЫЙ контроллер через Навигейшен контроллер
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}
