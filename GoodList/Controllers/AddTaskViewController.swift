//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by Nurtugan Nuraly on 10/1/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController {
    
    @IBOutlet private weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var taskTitleTextField: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        taskSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func save(_ sender: UIBarButtonItem) {
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
            let title = taskTitleTextField.text else {
                return
        }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        dismiss(animated: true)
    }
}
