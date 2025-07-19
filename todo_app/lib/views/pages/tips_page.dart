import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/views/services/api.dart';

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  bool loading = true, showForm = false;
  String searchTerm = '';
  List<Tip> tips = [];
  String newTitle = '', newContent = '';

  @override
  void initState() {
    super.initState();
    fetchTips();
  }

  final apiService = ApiService();
  Future fetchTips() async {
    setState(() => loading = true);
    try {
      final resp = await apiService.getAllTips();
      final fetched = (resp['tips'] as List)
          .map((j) => Tip.fromJson(j))
          .where((t) => t.status == 'APPROVED')
          .toList();
      setState(() {
        tips = fetched;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error loading tips');
    } finally {
      setState(() => loading = false);
    }
  }

  // Future submitTip() async {
  //   if (newTitle.length <10 || newContent.length<10){
  //     return Fluttertoast.showToast(msg:'Min 10 chars each');
  //   }
  //   try {
  //     await apiService.createTip({'title':newTitle,'content':newContent});
  //     Fluttertoast.showToast(msg:'Submitted');
  //     setState((){ showForm=false; newTitle=''; newContent=''; });
  //     fetchTips();
  //   } catch(e){
  //     Fluttertoast.showToast(msg:'Submission failed');
  //   }
  // }

  @override
  Widget build(BuildContext c) {
    final displayed = tips
        .where(
          (t) =>
              t.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
              t.content.toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList();

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Study Tips'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => showForm = true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tips...',
              ),
              onChanged: (v) => setState(() => searchTerm = v),
            ),
          ),

          // Tip cards
          Expanded(
            child: displayed.isEmpty
                ? Center(
                    child: Text(
                      searchTerm.isEmpty
                          ? 'Share the first tip!'
                          : 'No tips found',
                    ),
                  )
                : ListView.builder(
                    itemCount: displayed.length,
                    itemBuilder: (ctx, i) {
                      final t = displayed[i];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(c, '/tip/${t.id}'),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Study Tip',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    Text(
                                      t.createdAt.substring(0, 10),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  t.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  t.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'By ${t.uploaderName}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.favorite_border),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.bookmark_border),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.remove_red_eye),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Tip creation overlay
      floatingActionButton: showForm
          ? null
          : FloatingActionButton(
              onPressed: () => setState(() => showForm = true),
              child: Icon(Icons.lightbulb),
            ),
      bottomSheet: showForm
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Tip title'),
                    onChanged: (v) => newTitle = v,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Tip content'),
                    onChanged: (v) => newContent = v,
                    maxLines: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => showForm = false),
                        child: Text('Cancel'),
                      ),
                      // ElevatedButton(
                      //   onPressed: ,
                      //   child: Text('Submit'),
                      // ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class Tip {
  final String id, title, content, status, createdAt, uploaderName;
  Tip({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.uploaderName,
  });
  factory Tip.fromJson(Map<String, dynamic> j) {
    return Tip(
      id: j['id'],
      title: j['title'],
      content: j['content'],
      status: j['status'],
      createdAt: j['createdAt'],
      uploaderName: (j['uploadedBy']?['name'] ?? 'Anonymous'),
    );
  }
}
