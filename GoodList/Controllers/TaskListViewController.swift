//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Nurtugan Nuraly on 10/1/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController {
    @IBOutlet private weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("Controller not found")
        }
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { task in
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                let tasks = self.tasks.value + [task]
                self.tasks.accept(tasks)
                self.filterTask(by: priority)
            }).disposed(by: disposeBag)
    }
    
    @IBAction private func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTask(by: priority)
    }
    
    private func filterTask(by priority: Priority?) {
        guard let priority = priority else {
            filteredTasks = tasks.value
            updateTableView()
            return
        }
        tasks
            .map { tasks in
                return tasks.filter { $0.priority == priority }
            }
            .subscribe(onNext: { [unowned self] tasks in
                self.filteredTasks = tasks
                self.updateTableView()
            }).disposed(by: disposeBag)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {}
