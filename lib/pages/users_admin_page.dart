import 'package:flutter/material.dart';
import 'user_detail_page.dart';
import '../services/user_service.dart';
import 'dashboard_admin_page.dart';
import 'verify_admin_page.dart';
import 'chat_list_admin_page.dart';
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const Color _green = Color(0xFF00C853);

  final TextEditingController _searchController = TextEditingController();

  int _filterIndex = 0;
  int _currentPage = 1;
  final int _totalPages = 12;

  final List<String> _filterLabels = const [
    'ทั้งหมด',
    'ใช้งานอยู่',
    'รอตรวจสอบ',
  ];

  List<UserItem> _allUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';

  List<UserItem> get _filteredUsers => _allUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String status = 'all';
      if (_filterIndex == 1) status = 'active';
      if (_filterIndex == 2) status = 'pending';

      final data = await UserService.getUsers(
        search: _searchQuery,
        status: status,
      );

      final users = data.map<UserItem>((json) {
        return UserItem(
          id: json['id'],
          name: json['name'] ?? '',
          email: json['email'] ?? '',
          registeredDate: _formatRegisteredDate(json['registeredDate']),
          status: _mapStatus(json['status']),
          isOnline: json['isOnline'] ?? false,
          phone: json['phone'],
          rating: (json['rating'] ?? 0).toDouble(),
          totalJobs: json['totalJobs'] ?? 0,
          isVerified: json['isVerified'] ?? false,
          bio: json['bio'],
        );
      }).toList();

      setState(() {
        _allUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _formatRegisteredDate(dynamic rawDate) {
    if (rawDate == null) return 'สมัครเมื่อ -';
    return 'สมัครเมื่อ $rawDate';
  }

  UserStatus _mapStatus(String? status) {
    switch (status) {
      case 'pending':
        return UserStatus.pending;
      case 'suspended':
        return UserStatus.suspended;
      case 'active':
      default:
        return UserStatus.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadUsers,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'จัดการบัญชีผู้ใช้งาน',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildStatRow(),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 12),
                      _buildFilterChips(),
                      const SizedBox(height: 16),

                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_errorMessage != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _loadUsers,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _green,
                                  ),
                                  child: const Text(
                                    'ลองใหม่',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_filteredUsers.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text('ไม่พบผู้ใช้งาน'),
                          ),
                        )
                      else
                        ..._filteredUsers.map((u) => _buildUserCard(u)),

                      const SizedBox(height: 8),
                      _buildPagination(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_activity_outlined,
              color: _green,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              children: [
                TextSpan(
                  text: 'Local Job Hub ',
                  style: TextStyle(color: Color(0xFF1A1A2E)),
                ),
                TextSpan(
                  text: 'Admin',
                  style: TextStyle(color: _green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    final totalUsers = _allUsers.length;
    final activeUsers = _allUsers
        .where((u) => u.status == UserStatus.active)
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'ผู้ใช้ทั้งหมด',
            value: '$totalUsers',
            valueColor: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'ใช้งานอยู่',
            value: '$activeUsers',
            valueColor: _green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (v) async {
        _searchQuery = v;
        await _loadUsers();
      },
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'ค้นหาชื่อผู้ใช้งาน อีเมล หรือเบอร์โทรศัพท์...',
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFFBDBDBD),
          size: 22,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final selected = _filterIndex == i;
          return GestureDetector(
            onTap: () async {
              setState(() => _filterIndex = i);
              await _loadUsers();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? _green : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: selected ? _green : const Color(0xFFE0E0E0),
                ),
              ),
              child: Row(
                children: [
                  if (selected) ...[
                    const Icon(Icons.tune, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    _filterLabels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserCard(UserItem user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFE0E0E0),
                    child: Text(
                      user.name.isNotEmpty ? user.name.characters.first : '?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: user.isOnline ? _green : const Color(0xFFBDBDBD),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.email} • ${user.registeredDate}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildStatusBadge(user.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _goToDetail(user),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 16,
                          color: Color(0xFF555555),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'รายละเอียด',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleSuspend(user),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: user.status == UserStatus.suspended
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Icon(
                    user.status == UserStatus.suspended
                        ? Icons.check_circle_outline
                        : Icons.block_outlined,
                    size: 18,
                    color: user.status == UserStatus.suspended
                        ? _green
                        : const Color(0xFF757575),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _confirmDelete(user),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(UserStatus status) {
    late String label;
    late Color bg;
    late Color text;

    switch (status) {
      case UserStatus.active:
        label = 'ใช้งานอยู่';
        bg = const Color(0xFFE8F5E9);
        text = const Color(0xFF2E7D32);
        break;
      case UserStatus.pending:
        label = 'รอตรวจสอบ';
        bg = const Color(0xFFFFF9C4);
        text = const Color(0xFFF57F17);
        break;
      case UserStatus.suspended:
        label = 'ระงับการใช้งาน';
        bg = const Color(0xFFFFEBEE);
        text = const Color(0xFFE53935);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final pages = [1, 2, 3];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageBtn(
          child: const Icon(
            Icons.chevron_left,
            size: 20,
            color: Color(0xFF555555),
          ),
          onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        const SizedBox(width: 6),
        ...pages.map(
          (p) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _pageBtn(
              label: '$p',
              selected: _currentPage == p,
              onTap: () => setState(() => _currentPage = p),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 6),
          child: Text(
            '...',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: _pageBtn(
            label: '$_totalPages',
            selected: _currentPage == _totalPages,
            onTap: () => setState(() => _currentPage = _totalPages),
          ),
        ),
        _pageBtn(
          child: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Color(0xFF555555),
          ),
          onTap: _currentPage < _totalPages
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }

  Widget _pageBtn({
    String? label,
    Widget? child,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? _green : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? _green : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child:
              child ??
              Text(
                label ?? '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF555555),
                ),
              ),
        ),
      ),
    );
  }

  void _goToDetail(UserItem user) {
    Navigator.pushNamed(context, '/user-detail', arguments: user);
  }

  Future<void> _toggleSuspend(UserItem user) async {
    try {
      final newStatus = user.status == UserStatus.suspended
          ? 'active'
          : 'suspended';

      await UserService.updateUserStatus(id: user.id, status: newStatus);

      await _loadUsers();

      if (!mounted) return;

      final msg = user.status == UserStatus.suspended
          ? 'ปลดระงับ "${user.name}" แล้ว'
          : 'ระงับ "${user.name}" แล้ว';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: user.status == UserStatus.suspended
              ? _green
              : const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _confirmDelete(UserItem user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ยืนยันการลบ',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text('คุณต้องการลบบัญชี "${user.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ยกเลิก',
              style: TextStyle(color: Color(0xFF757575)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                await UserService.deleteUser(user.id);
                await _loadUsers();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบ "${user.name}" แล้ว'),
                    backgroundColor: const Color(0xFFE53935),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString().replaceFirst('Exception: ', '')),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

Widget _buildBottomNav() {
  return BottomNavigationBar(
    currentIndex: 2,
    onTap: (index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VerifyPage()),
        );
      } else if (index == 2) {
        return;
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatListPage()),
        );
      }
    },
    type: BottomNavigationBarType.fixed,
    selectedItemColor: _green,
    unselectedItemColor: const Color(0xFF9E9E9E),
    backgroundColor: Colors.white,
    elevation: 8,
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.grid_view_rounded),
        label: 'แดชบอร์ด',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shield_outlined),
        label: 'ตรวจสอบ',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        label: 'ผู้ใช้',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline),
        label: 'แชท',
      ),
    ],
  );
}


}
