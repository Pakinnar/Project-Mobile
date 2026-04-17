import 'package:flutter/material.dart';
import '../services/profile_api_service.dart';
import '../services/auth_service.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  late Future<List<PortfolioItem>> _future;
  late int userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = _loadPortfolios();
  }

  Future<List<PortfolioItem>> _loadPortfolios() async {
    final routeUserId = ModalRoute.of(context)?.settings.arguments as int?;
    userId = routeUserId ?? await AuthService.getCurrentUserId();
    return ProfileApiService.getPortfolios(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ผลงานของฉัน',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<List<PortfolioItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('โหลดผลงานไม่สำเร็จ\n${snapshot.error}'),
            );
          }

          final portfolioItems = snapshot.data ?? [];

          if (portfolioItems.isEmpty) {
            return const Center(child: Text('ยังไม่มีรูปผลงานในระบบ'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: portfolioItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = portfolioItems[index];
              final imageUrl = item.imageUrl ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImagePage(
                        imageUrl: imageUrl,
                        heroTag: 'portfolio_$index',
                        description: item.description,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'portfolio_$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final String description;

  const FullScreenImagePage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.contain)
                      : const Icon(Icons.image_not_supported, color: Colors.white),
                ),
              ),
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
