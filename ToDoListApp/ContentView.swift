//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Héctor Roberto López Velasco on 23/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = [] // Lista de tareas
    @State private var newTask: String = "" // Nueva tarea que el usuario ingresa
    @State private var isEditing: Bool = false  // Controla si el formulario de edición está visible
    @State private var taskToEdit: Task? = nil // La tarea que se está editando
    
    var body: some View {
        NavigationView {
            VStack {
                // Campo para ingresar nueva tarea
                HStack {
                    TextField("Nueva tarea", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: addTask) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                // Lista de tareas
                List {
                    ForEach(tasks) { task in
                        HStack {
                            // Botón para marcar como completada
                            Button(action: {
                                toggleTaskCompletion(task)
                            }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            //Texto de la tarea
                            Text(task.title)
                                .strikethrough(task.isCompleted, color: .gray)
                                .foregroundColor(task.isCompleted ? .gray : Color("PrimaryColor"))

                            Spacer()
                            
                            //Botón para editar
                            Button(action: {
                                taskToEdit = task
                                isEditing = true
                            }) {
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask) // Para eliminar tareas
                }
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Lista de tareas")
            .onAppear {
                loadTasks() // Cargar tareas al iniciar
            }
            .onChange(of: tasks) {
                saveTasks() // Guardar tareas cuando cambien
            }
            .sheet(isPresented: $isEditing) {
                if let taskToEdit = taskToEdit {
                    EditTaskView(task: taskToEdit, onSave: { updatedTask in
                        updateTask(updatedTask)
                    }, onCancel: {
                        isEditing = false
                    })
                }
            }
        }
    }
    
    // Función para agregar una nueva tarea
    func addTask() {
        guard !newTask.isEmpty else { return }
        let task = Task(id: UUID(), title: newTask, isCompleted: false)
        tasks.append(task)
        newTask = ""
    }
    
    // Función para alternar el estado de una tarea
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: {$0.id == task.id}) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    // Función para eliminar una tarea
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // Guardar tareas en UserDefaults
    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    // Cargar tareas desde UserDefaults
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            let decoded = try? JSONDecoder().decode([Task].self, from: data)
            tasks = decoded ?? []
        }
    }
    
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask // Actualiza toda la tarea
        }
        isEditing = false // Cierra el formulario de edición
    }

}

struct Task: Identifiable, Equatable, Encodable, Decodable {
    let id: UUID
    var title: String
    var isCompleted: Bool = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
