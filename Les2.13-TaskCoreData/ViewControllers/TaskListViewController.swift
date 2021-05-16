//
//  ViewController.swift
//  Les2.13-TaskCoreData
//
//  Created by Сперанский Никита on 11.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigatorBar()
    }
    
    private func setupNavigatorBar() {
      
        title = "Task List"   //заголовок экрана
        navigationController?.navigationBar.prefersLargeTitles = true  //делаем заголовок большим шрифтом
        
// Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()  // внешний вид НавигейшнБар
        navBarAppearance.configureWithOpaqueBackground()  // делает навиБар прозрачным
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] //цвет для обычного текста
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]  // цвет крупного текста
        navBarAppearance.backgroundColor = UIColor(     // цвет фона голубоватый и слегка прозрачный
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        
        // передача экземпляра - внешний вид НавиБара
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        // вид навиБара в момент скрола (листания) - параметры для каждого настраиваются отдельно
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        //добавляем кнопку на экран
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        //красим кнопку в белый цвет
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
    
////      созданиеНавиБар и настройка внешнего вида
//
//
//
////        кнопка
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .add,
//            target: self,                    //метод будет в самом VC
//            action: #selector(addNewTask)
//        )
//        navigationController?.navigationBar.tintColor = .white
//    }


    
    
    private func save(task: String) {
        StorageManager.shared.save(task) { task in
            self.tasks.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1,
                               section: 0)],
                with: .automatic
            )
        }
    }
    
//    Загрузка данных из базы и передача их в таблВью
    private func getData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):  // если успех то вернет массив задач
                self.tasks = tasks     // берем этот массив и передаем в свойства нашего класса
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        return cell
    }
}

    // MARK: - UITableViewDelegate
extension TaskListViewController {
    
    //Edit Task - didSelectRowAt вызывается когда мы тапаем по строке - затем вызываем АлертКонтр, в которой отображается название текущ задачи
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
}

    // MARK: - Alert Controller
extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {    // comp-on для обновления интерфейса
        
        let title = task != nil ? "Update Task" : "New Task"
        
        let alert = AlertController(  // кастомный алерт с методом action, определяет как будем работать с данными
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert)
        
        alert.action(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: taskName)
                completion()        //обновления интерфейса
            } else {
                self.save(task: taskName)
            }
        }
        present(alert, animated: true)
    }
}
