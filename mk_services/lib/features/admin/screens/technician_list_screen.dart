import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mk_services/core/services/api_service.dart';

class AllProvidersScreen extends StatefulWidget {
  const AllProvidersScreen({super.key});

  @override
  State<AllProvidersScreen> createState() => _AllProvidersScreenState();
}

class _AllProvidersScreenState extends State<AllProvidersScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> providers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProviders();
  }

  Future<void> fetchProviders() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final data = await _api.getTechnicians();
      if (!mounted) return;
      setState(() {
        providers = data;
      });
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to load providers',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'All Providers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: fetchProviders,
        child: loading
            ? _buildShimmerLoader()
            : providers.isEmpty
            ? const Center(child: Text("No providers found"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade700,
                        child: Text(
                          (provider['name'] ?? 'X')[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        provider['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📧 ${provider['email'] ?? ''}'),
                          Text('📞 ${provider['phone'] ?? ''}'),
                          Text('🛠️ ${provider['specialization'] ?? 'N/A'}'),
                          Text('📍 Zone: ${provider['zone'] ?? 'Unknown'}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
