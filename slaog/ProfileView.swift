import SwiftUI

struct ProfileView: View {
    @State private var showingSettings = false
    @State private var selectedFilter = GoalFilter.inProgress
    
    enum GoalFilter: String, CaseIterable, Identifiable {
        case inProgress = "进行中"
        case completed = "已完成"
        
        var id: String { self.rawValue }
    }
    
    // Mock data
    let inProgressGoals: [Goal] = []
    let completedGoals: [Goal] = []
    
    var filteredGoals: [Goal] {
        switch selectedFilter {
        case .inProgress:
            return inProgressGoals
        case .completed:
            return completedGoals
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileHeader()
                    
                    Picker("目标筛选", selection: $selectedFilter) {
                        ForEach(GoalFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if filteredGoals.isEmpty {
                        VStack {
                            Spacer()
                            Text(selectedFilter == .inProgress ? "没有进行中的目标" : "没有已完成的目标")
                                .foregroundColor(.secondary)
                                .padding(.top, 50)
                            Spacer()
                        }
                        .frame(height: 200)
                    } else {
                        ForEach(filteredGoals) { goal in
                            ProfileGoalCard(goal: goal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("个人中心")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct ProfileHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            Text("用户名")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("用户ID: 123456")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                VStack {
                    Text("5")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("目标")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("2")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("群组")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("3")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("已完成")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ProfileGoalCard: View {
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                
                Spacer()
                
                Text("截止日期: \(formattedDate(goal.deadline))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: goal.progress)
                .padding(.vertical, 4)
            
            Text("完成进度: \(Int(goal.progress * 100))%")
                .font(.caption)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = "用户名"
    @State private var notifications = true
    @State private var darkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("个人信息")) {
                    TextField("用户名", text: $username)
                }
                
                Section(header: Text("应用设置")) {
                    Toggle("通知", isOn: $notifications)
                    Toggle("深色模式", isOn: $darkMode)
                }
                
                Section {
                    Button(action: {
                        // Log out
                    }) {
                        Text("退出登录")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

