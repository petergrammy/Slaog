import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var goals: [Goal]
    
    @State private var title = ""
    @State private var deadline = Date()
    @State private var divisionType = DivisionType.byTime
    @State private var timeInterval = 1
    @State private var timeUnit = TimeUnit.day
    @State private var tasks: [String] = [""]
    
    enum DivisionType: String, CaseIterable, Identifiable {
        case byTime = "按时间划分"
        case byTask = "按任务划分"
        
        var id: String { self.rawValue }
    }
    
    enum TimeUnit: String, CaseIterable, Identifiable {
        case hour = "小时"
        case day = "天"
        case week = "周"
        case month = "月"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目标信息")) {
                    TextField("目标名称", text: $title)
                    DatePicker("截止日期", selection: $deadline, displayedComponents: .date)
                }
                
                Section(header: Text("划分方式")) {
                    Picker("划分类型", selection: $divisionType) {
                        ForEach(DivisionType.allCases) { type in
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
                                ForEach(TimeUnit.allCases) { unit in
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
            .navigationTitle("创建目标")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveGoal()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    func saveGoal() {
        let newGoal = Goal(
            id: UUID(),
            title: title,
            deadline: deadline,
            divisionType: divisionType,
            timeInterval: timeInterval,
            timeUnit: timeUnit,
            tasks: divisionType == .byTask ? tasks.filter { !$0.isEmpty } : [],
            progress: 0.0
        )
        
        goals.append(newGoal)
    }
}

