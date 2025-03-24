import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var goal: Goal
    
    @State private var title: String
    @State private var divisionType: AddGoalView.DivisionType
    @State private var timeInterval: Int
    @State private var timeUnit: AddGoalView.TimeUnit
    @State private var tasks: [String]
    
    init(goal: Binding<Goal>) {
        self._goal = goal
        _title = State(initialValue: goal.wrappedValue.title)
        _divisionType = State(initialValue: goal.wrappedValue.divisionType)
        _timeInterval = State(initialValue: goal.wrappedValue.timeInterval)
        _timeUnit = State(initialValue: goal.wrappedValue.timeUnit)
        _tasks = State(initialValue: goal.wrappedValue.tasks)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目标信息")) {
                    TextField("目标名称", text: $title)
                    
                    HStack {
                        Text("截止日期")
                        Spacer()
                        Text(formattedDate(goal.deadline))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("划分方式")) {
                    Picker("划分类型", selection: $divisionType) {
                        ForEach(AddGoalView.DivisionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if divisionType == .byTime {
                        HStack {
                            Text("时间间隔")
                            Spacer()
                            TextField("", value: $timeInterval, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                            
                            Picker("", selection: $timeUnit) {
                                ForEach(AddGoalView.TimeUnit.allCases) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)
                        }
                    } else {
                        ForEach(0..<tasks.count, id: \.self) { index in
                            HStack {
                                TextField("任务 \(index + 1)", text: $tasks[index])
                                
                                Button(action: {
                                    if tasks.count > 1 {
                                        tasks.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Button(action: {
                            tasks.append("")
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("添加任务")
                            }
                        }
                    }
                }
            }
            .navigationTitle("编辑目标")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    func saveChanges() {
        goal.title = title
        goal.divisionType = divisionType
        goal.timeInterval = timeInterval
        goal.timeUnit = timeUnit
        goal.tasks = divisionType == .byTask ? tasks.filter { !$0.isEmpty } : []
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

