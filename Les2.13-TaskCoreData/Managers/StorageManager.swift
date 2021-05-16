//
//  StorageManager.swift
//  Les2.13-TaskCoreData
//
//  Created by Сперанский Никита on 12.05.2021.
//

import CoreData

// StorageManager не должен хранить у себя какие массивы данных - данные хранятся в базе данных
class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Les2_13_TaskCoreData")   //название файла кор даты
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Сокращение
    private let viewContext: NSManagedObjectContext  //сделали свойство, чтобы не писать "persistentContainer.viewContext"
    
    private init() {
        viewContext = persistentContainer.viewContext // инициализатор нужен, чтобы инициализировать свойство!
    }
    
    // MARK: - Public Methods
//    должны быть реализованы все методы по управлению данными в базе - загрузка/удаление/редактирование/сохранение данных
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {   // type Result это перечисление(2 case), кот-е позволяет возвращать данные ассинхронно!
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()    // создаем запрос
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)     //формируем данные на основе запроса
            completion(.success(tasks))     // помещаем массив двнных в comp-tion, при успехе вернет массив задач
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)   // создаем экземпляр модели
        task.name = taskName
        
        completion(task)    // чтобы при вызове метода передать строку для отображения на экране
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    //MARK: - Core Data Saving support
    func saveContext() {        //должен быть публичным так как вызывается в AppDeligate в методе ApplicationWillTerminate
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


