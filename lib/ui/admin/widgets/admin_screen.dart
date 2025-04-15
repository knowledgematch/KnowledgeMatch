import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/admin/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Admin Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manage Keywords Section
            Text('Manage Keywords', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: viewModel.keywordController,
              decoration: InputDecoration(labelText: 'Enter new Keyword'),
            ),
            ElevatedButton(
              onPressed: viewModel.addKeyword,
              child: Text(viewModel.state.editingKeyword == null ? 'Add Keyword' : 'Update Keyword'),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Keyword')),
                DataColumn(label: Text('Actions')),
              ],
              rows: viewModel.state.keywords.map<DataRow>((keyword) {
                return DataRow(cells: [
                  DataCell(Text(keyword)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => viewModel.startEditingKeyword(keyword),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => viewModel.deleteKeyword(keyword),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),

            SizedBox(height: 20),

            // Manage Topics Section
            Text('Manage Topics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: viewModel.topicController,
              decoration: InputDecoration(labelText: 'Enter new Topic'),
            ),
            ElevatedButton(
              onPressed: viewModel.addTopic,
              child: Text(viewModel.state.editingTopic == null ? 'Add Topic' : 'Update Topic'),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Topic')),
                DataColumn(label: Text('Actions')),
              ],
              rows: viewModel.state.topics.map<DataRow>((topic) {
                return DataRow(cells: [
                  DataCell(Text(topic)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => viewModel.startEditingTopic(topic),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => viewModel.deleteTopic(topic),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),

            SizedBox(height: 20),

            // Map Keyword to Topic
            Text('Map Keyword to Topic', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: viewModel.state.selectedKeyword.isEmpty ? null : viewModel.state.selectedKeyword,
              hint: Text('Select Keyword'),
              onChanged: (String? newValue) {
                setState(() {
                  viewModel.state.selectedKeyword = newValue ?? '';
                });
              },
              items: viewModel.state.keywords.map<DropdownMenuItem<String>>((String keyword) {
                return DropdownMenuItem<String>(
                  value: keyword,
                  child: Text(keyword),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: viewModel.state.selectedTopic.isEmpty ? null : viewModel.state.selectedTopic,
              hint: Text('Select Topic'),
              onChanged: (String? newValue) {
                setState(() {
                  viewModel.state.selectedTopic = newValue ?? '';
                });
              },
              items: viewModel.state.topics.map<DropdownMenuItem<String>>((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: viewModel.mapKeywordToTopic,
              child: Text('Map Keyword to Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
