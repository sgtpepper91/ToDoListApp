//
//  EditTaskView.swift
//  ToDoListApp
//
//  Created by Héctor Roberto López Velasco on 23/11/24.
//


import SwiftUI

struct EditTaskView: View {
    @State private var title: String
    let onSave: (Task) -> Void
    let onCancel: () -> Void
    
    var task: Task
    
    init(task: Task, onSave: @escaping (Task) -> Void, onCancel: @escaping () -> Void) {
        self.task = task
        self._title = State(initialValue: task.title)
        self.onSave = onSave
        self.onCancel = onCancel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Editar Tarea")) {
                    TextField("Título", text: $title)
                }
            }
            .navigationTitle("Editar Tarea")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        var updatedTask = task
                        updatedTask.title = title
                        onSave(updatedTask)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        onCancel()
                    }
                }
            }
        }
    }
}
