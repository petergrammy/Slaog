import SwiftUI

struct SlaogView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(goals) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        GoalRow(goal: goal)
                    }
                }
                .onDelete(perform: deleteGoal)
            }
            .navigationTitle("我的目标")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGoal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals)
            }
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }
}

struct GoalRow: View {
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(goal.title)
                .font(.headline)
            
            HStack {
                Text("截止日期: \(formattedDate(goal.deadline))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                ProgressView(value: goal.progress)
                    .frame(width: 100)
            }
        }
        .padding(.vertical, 8)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct SlaogView_Previews: PreviewProvider {
    static var previews: some View {
        SlaogView()
    }
}

