import SwiftUI

struct GroupView: View {
    @State private var groups: [Group] = []
    @State private var showingAddGroup = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                if groups.isEmpty {
                    VStack {
                        Spacer()
                        Text("你还没有加入任何群组")
                            .foregroundColor(.secondary)
                        Button(action: {
                            showingAddGroup = true
                        }) {
                            Text("创建或加入群组")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(groups) { group in
                            NavigationLink(destination: GroupDetailView(group: group)) {
                                GroupRow(group: group)
                            }
                        }
                    }
                }
            }
            .navigationTitle("群组")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGroup = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView(groups: $groups)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("搜索群组或用户", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct GroupRow: View {
    var group: Group
    
    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                Text("\(group.members.count) 成员")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}

