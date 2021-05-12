//
//  ViewController.swift
//  Les2.13-TaskCoreData
//
//  Created by Сперанский Никита on 11.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()

    }

//      созданиеНавиБар и настройка внешнего вида
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        
//        кнопка
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,                    //метод будет в самом VC
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }

//    реализация действия кнопки
    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        present(taskVC, animated: true)
    }
    
    
}

