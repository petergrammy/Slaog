import SwiftUI

struct GroupDetailView: View {
    var group: Group
    @State private var showingMemberList = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(group.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Button(action: {
                            showingMemberList = true
                        }) {
                            Text("\(group.members.count) 成员")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            // Invite members
                        }) {
                            Label("邀请成员", systemImage: "person.badge.plus")
                        }
                        
                        Button(action: {
                            // Leave group
                        }) {
                            Label("退出群组", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(8)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Divider()
                
                Text("群组目标")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(group.sharedGoals) { goal in
                    GroupGoalCard(goal: goal)
                }
                
                if group.sharedGoals.isEmpty {
                    Text("没有共享的目标")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $showingMemberList) {
            MemberListView(members: group.members)
        }
    }
}

struct GroupGoalCard: View {
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
            
            HStack {
                ForEach(0..<min(3, goal.tasks.count), id: \.self) { index in
                    Text(goal.tasks[index])
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                if goal.tasks.count > 3 {
                    Text("+\(goal.tasks.count - 3)")
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
            }
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

struct MemberListView: View {
    var members: [Member]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(members) { member in
                    HStack {
                        Text(member.name)
                        
                        Spacer()
                        
                        if member.isAdmin {
                            Text("管理员")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("群组成员")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

