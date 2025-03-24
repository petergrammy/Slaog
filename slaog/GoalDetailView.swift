import SwiftUI

struct GoalDetailView: View {
    @State var goal: Goal
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(goal.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("截止日期: \(formattedDate(goal.deadline))")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("编辑")
                    }
                }
                .padding()
                
                ProgressView(value: goal.progress)
                    .padding(.horizontal)
                
                Text("完成进度: \(Int(goal.progress * 100))%")
                    .padding(.horizontal)
                
                Divider()
                
                if goal.divisionType == .byTime {
                    timeBasedView
                } else {
                    taskBasedView
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditGoalView(goal: $goal)
        }
    }
    
    var timeBasedView: some View {
        VStack(alignment: .leading) {
            Text("按时间划分")
                .font(.headline)
                .padding(.horizontal)
            
            Text("每 \(goal.timeInterval) \(goal.timeUnit.rawValue)检查一次进度")
                .padding(.horizontal)
            
            // Here you would show the time-based milestones
            List {
                ForEach(0..<5) { i in
                    HStack {
                        Text("阶段 \(i + 1)")
                        Spacer()
                        Button(action: {
                            // Mark as complete
                        }) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .frame(height: 250)
        }
    }
    
    var taskBasedView: some View {
        VStack(alignment: .leading) {
            Text("按任务划分")
                .font(.headline)
                .padding(.horizontal)
            
            List {
                ForEach(goal.tasks, id: \.self) { task in
                    HStack {
                        Text(task)
                        Spacer()
                        Button(action: {
                            // Mark as complete
                        }) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .frame(height: 250)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

