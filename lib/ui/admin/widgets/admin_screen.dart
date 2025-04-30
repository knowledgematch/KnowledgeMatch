import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/admin/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/keyword.dart';
import '../../../domain/models/topic.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Admin Screen')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage Keywords',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: viewModel.keywordController,
              decoration: InputDecoration(labelText: 'Enter new Keyword'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.keywordDescController,
              decoration: InputDecoration(labelText: 'Enter a Description'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: viewModel.addKeyword,
                  child: Text(viewModel.state.editingKeyword == null
                      ? 'Add Keyword'
                      : 'Update Keyword'),
                ),
                ElevatedButton(
                    onPressed: viewModel.loadKeywords,
                    child: Icon(Icons.refresh)
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Keyword')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: viewModel.state.keywords.map<DataRow>((keyword) {
                  return DataRow(cells: [
                    DataCell(Text(keyword.id.toString())),
                    DataCell(Text(keyword.name)),
                    DataCell(Text(keyword.description)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              viewModel.startEditingKeyword(keyword),
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
            ),
            SizedBox(height: 20),
            Text('Manage Topics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: viewModel.topicController,
              decoration: InputDecoration(labelText: 'Enter new Topic'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.topicDescController,
              decoration: InputDecoration(labelText: 'Enter a Description'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: viewModel.addTopic,
                  child: Text(viewModel.state.editingTopic == null
                      ? 'Add Topic'
                      : 'Update Topic'),
                ),
                ElevatedButton(
                    onPressed: viewModel.loadTopics,
                    child: Icon(Icons.refresh)
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Topic')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: viewModel.state.topics.map<DataRow>((topic) {
                  return DataRow(cells: [
                    DataCell(Text(topic.id.toString())),
                    DataCell(Text(topic.name)),
                    DataCell(Text(topic.description)),
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
            ),
            SizedBox(height: 20),
            Text('Map Keyword to Topic',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButton<Keyword>(
              value: viewModel.state.selectedKeyword,
              hint: Text('Select Keyword'),
              onChanged: (Keyword? newValue) {
                viewModel.updateSelectedKeyword(newValue);
              },
              items: viewModel.state.keywords.map((Keyword keyword) {
                return DropdownMenuItem<Keyword>(
                  value: keyword,
                  child: Text(keyword.name),
                );
              }).toList(),
            ),
            DropdownButton<Topic>(
              value: viewModel.state.selectedTopic,
              hint: Text('Select Topic'),
              onChanged: (Topic? newValue) {
                viewModel.updateSelectedTopic(newValue);
              },
              items: viewModel.state.topics.map((Topic topic) {
                return DropdownMenuItem<Topic>(
                  value: topic,
                  child: Text(topic.name),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: viewModel.mapKeywordToTopic,
              child: Text('Map Keyword to Topic'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('K_ID')),
                  DataColumn(label: Text('Keyword')),
                  DataColumn(label: Text('T_ID')),
                  DataColumn(label: Text('Topic')),
                  DataColumn(label: Text('Delete'))
                ],
                rows: viewModel.state.keyword2topic.map<DataRow>((k2t) {
                  return DataRow(cells: [
                    DataCell(Text(k2t.keyword.id.toString())),
                    DataCell(Text(k2t.keyword.name)),
                    DataCell(Text(k2t.topic.id.toString())),
                    DataCell(Text(k2t.topic.name)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => viewModel.deleteKeywordToTopic(k2t),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
