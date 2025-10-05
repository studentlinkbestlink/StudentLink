import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/api_service.dart';

import './widgets/modern_concern_card_widget.dart';
import './widgets/enhanced_concern_details_modal.dart';
import './widgets/modern_context_menu_widget.dart';
import './widgets/modern_empty_state_widget.dart';
import './widgets/modern_filter_chips_widget.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class MyConcerns extends StatefulWidget {
  const MyConcerns({Key? key}) : super(key: key);

  @override
  State<MyConcerns> createState() => _MyConcernsState();
}

class _MyConcernsState extends State<MyConcerns> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  String _statusFilter = 'All';
  bool _isLoadingMore = false;
  OverlayEntry? _overlayEntry;

  // Concerns will be loaded from API
  List<Map<String, dynamic>> _allConcerns = [];
  List<Map<String, dynamic>> _archivedConcerns = [];

  // All data now loaded from backend API

  List<Map<String, dynamic>> _filteredConcerns = [];
  List<Map<String, dynamic>> _filteredArchivedConcerns = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.text = _searchQuery;
    _loadConcerns(); // Load from API
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadConcerns() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading concerns from API...');
      // Load concerns from API service
      final concerns = await apiService.getConcerns(perPage: 50);
      print('Received ${concerns.length} concerns from API');
      print('Concerns data: $concerns');
      
      // Separate active and archived concerns
      final activeConcerns = concerns.where((c) => c['archived_at'] == null).toList();
      final archivedConcerns = concerns.where((c) => c['archived_at'] != null).toList();
      
      setState(() {
        _allConcerns = activeConcerns;
        _archivedConcerns = archivedConcerns;
        _filteredConcerns = List.from(activeConcerns);
        _filteredArchivedConcerns = List.from(archivedConcerns);
      });
    } catch (e) {
      print('Error loading concerns: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load concerns: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
      // Keep empty state on error
      setState(() {
        _allConcerns = [];
        _archivedConcerns = [];
        _filteredConcerns = [];
        _filteredArchivedConcerns = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreConcerns();
    }
  }

  Future<void> _loadMoreConcerns() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshConcerns() async {
    HapticFeedback.lightImpact();

    // Reload concerns from API
    await _loadConcerns();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }


  void _applyFilters() {
    // Apply filters to active concerns
    List<Map<String, dynamic>> filteredActive = List.from(_allConcerns);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredActive = filteredActive.where((concern) {
        final title = (concern['title'] as String).toLowerCase();
        final description = (concern['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_statusFilter != 'All') {
      filteredActive = filteredActive
          .where((concern) => concern['status'] == _statusFilter)
          .toList();
    }

    // Apply filters to archived concerns
    List<Map<String, dynamic>> filteredArchived = List.from(_archivedConcerns);
    
    // Apply search filter to archived
    if (_searchQuery.isNotEmpty) {
      filteredArchived = filteredArchived.where((concern) {
        final title = (concern['title'] as String).toLowerCase();
        final description = (concern['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply status filter to archived
    if (_statusFilter != 'All') {
      filteredArchived = filteredArchived
          .where((concern) => concern['status'] == _statusFilter)
          .toList();
    }

    setState(() {
      _filteredConcerns = filteredActive;
      _filteredArchivedConcerns = filteredArchived;
    });
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: ResponsiveDesign.getPadding(all: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter by Status',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ResponsiveSpacing(height: 16),
            ...['All', 'Received', 'In Process', 'Resolved'].map((status) {
              return ListTile(
                title: Text(status),
                leading: Radio<String>(
                  value: status,
                  groupValue: _statusFilter,
                  onChanged: (value) {
                    setState(() {
                      _statusFilter = value!;
                    });
                    _applyFilters();
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _statusFilter = 'All';
      _searchQuery = '';
    });
    _searchController.clear();
    _applyFilters();
  }

  void _showEnhancedConcernDetailsModal(Map<String, dynamic> concern, {bool autoOpenChat = false}) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EnhancedConcernDetailsModal(
        concern: concern,
        autoOpenChat: autoOpenChat,
        onResolutionUpdated: () {
          // Refresh the concerns list when resolution is updated
          _loadConcerns();
        },
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'student_confirmed':
        return 'Confirmed';
      case 'closed':
        return 'Closed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      case 'escalated':
        return 'Escalated';
      default:
        return 'Unknown';
    }
  }

  void _showContextMenu(Map<String, dynamic> concern, Offset position) {
    print('Showing context menu for concern: ${concern['title']} at position: $position');
    _removeOverlay();

    // Calculate better positioning for the context menu
    final screenSize = MediaQuery.of(context).size;
    final menuWidth = screenSize.width * 0.7;
    final menuHeight = screenSize.height * 0.4; // Approximate height
    
    double left = position.dx - (menuWidth / 2);
    double top = position.dy - menuHeight;
    
    // Ensure menu stays within screen bounds
    if (left < 0) left = 8.0;
    if (left + menuWidth > screenSize.width) left = screenSize.width - menuWidth - 8.0;
    if (top < 0) top = position.dy + 8.0;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: menuWidth,
            child: ModernContextMenuWidget(
              concern: concern,
              onShareStatus: () {
                _removeOverlay();
                _shareStatus(concern);
              },
              onDownloadPdf: () {
                _removeOverlay();
                _downloadPdf(concern);
              },
              onSetNotifications: () {
                _removeOverlay();
                _setNotifications(concern);
              },
              onDelete: () {
                _removeOverlay();
                _showDeleteConfirmation(concern);
              },
              onClose: _removeOverlay,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _shareStatus(Map<String, dynamic> concern) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing status for: ${concern['title']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadPdf(Map<String, dynamic> concern) {
    // Implement PDF download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading PDF for: ${concern['title']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setNotifications(Map<String, dynamic> concern) {
    // Implement notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Setting notifications for: ${concern['title']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> concern) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Concern',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this concern?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ResponsiveSpacing(height: 16),
              Container(
                padding: ResponsiveDesign.getPadding(all: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF100100100).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      concern['title'] ?? 'Untitled Concern',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ResponsiveSpacing(height: 4),
                    Text(
                      'Status: ${concern['status'] ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveSpacing(height: 8),
              Text(
                'This action cannot be undone.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteConcern(concern);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteConcern(Map<String, dynamic> concern) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: ResponsiveDesign.getPadding(all: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  ResponsiveSpacing(height: 16),
                  Text(
                    'Deleting concern...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Call API to delete concern
      await apiService.deleteConcern(concern['id']);
      
      // Remove from local lists
      setState(() {
        _allConcerns.removeWhere((item) => item['id'] == concern['id']);
        _filteredConcerns.removeWhere((item) => item['id'] == concern['id']);
      });

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Concern deleted successfully'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete concern: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Theme-aware background
      appBar: _buildModernAppBar(),
      body: GestureDetector(
        onTap: _removeOverlay,
        child: Column(
          children: [
            // Modern Search Bar
            _buildModernSearchBar(),

            // Modern Filter Chips
            if (_statusFilter != 'All')
              ModernFilterChipsWidget(
                statusFilter: _statusFilter,
                onClearAll: _clearAllFilters,
              ),

            // Tab Bar
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 3,
                labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: ResponsiveDesign.getIconSize(18),
                        ),
                        ResponsiveSpacing(height: 0, width: 8),
                        Text('Active'),
                        if (_allConcerns.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_allConcerns.length}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.archive_rounded,
                          size: ResponsiveDesign.getIconSize(18),
                        ),
                        ResponsiveSpacing(height: 0, width: 8),
                        Text('Archived'),
                        if (_archivedConcerns.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_archivedConcerns.length}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content with TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Active Concerns Tab
                  _buildConcernsList(_filteredConcerns, _allConcerns.isEmpty),
                  
                  // Archived Concerns Tab
                  _buildConcernsList(_filteredArchivedConcerns, _archivedConcerns.isEmpty, isArchived: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConcernsList(List<Map<String, dynamic>> concerns, bool isEmpty, {bool isArchived = false}) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      );
    }

    if (isEmpty) {
      return _buildEmptyState(isArchived);
    }

    return RefreshIndicator(
      onRefresh: _refreshConcerns,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
        itemCount: concerns.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == concerns.length) {
            return Container(
              padding: ResponsiveDesign.getPadding(all: 16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            );
          }

          final concern = concerns[index];
          return ModernConcernCardWidget(
            concern: concern,
            onViewDetails: () {
              _showEnhancedConcernDetailsModal(concern);
            },
            onAddReply: () {
              if (isArchived) {
                // For archived concerns, show a message that chat is not available
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat is not available for archived concerns'),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                _showEnhancedConcernDetailsModal(concern, autoOpenChat: true);
              }
            },
            onDelete: () {
              _showDeleteConfirmationDialog(concern);
            },
            onLongPress: () {
              print('Long press detected for concern: ${concern['title']}');
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              _showContextMenu(concern, position);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isArchived) {
    if (isArchived) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_rounded,
              size: ResponsiveDesign.getIconSize(64),
              color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
            ),
            ResponsiveSpacing(height: 16),
            Text(
              'No Archived Concerns',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF300300300),
              ),
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Resolved concerns will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      );
    } else {
      return ModernEmptyStateWidget(
        onSubmitConcern: () => Navigator.pushNamed(context, '/submit-concern'),
      );
    }
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: Text(
        'My Concerns',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search concerns...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  border: InputBorder.none,
                  contentPadding: ResponsiveDesign.getPadding(horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: _showStatusFilter,
              icon: Icon(
                Icons.filter_list_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(20),
              ),
              tooltip: 'Filter concerns',
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmationDialog(Map<String, dynamic> concern) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Theme.of(context).colorScheme.error,
                size: ResponsiveDesign.getIconSize(28),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              const Text('Delete Concern'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this concern?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ResponsiveSpacing(height: 12),
              Container(
                padding: ResponsiveDesign.getPadding(all: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    ResponsiveSpacing(height: 4),
                    Text(
                      concern['title'] ?? 'Untitled Concern',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ResponsiveSpacing(height: 8),
                    Text(
                      'Status:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    ResponsiveSpacing(height: 4),
                    Text(
                      _getStatusLabel(concern['status'] ?? 'pending'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveSpacing(height: 12),
              Text(
                'This action cannot be undone. All messages and replies associated with this concern will be permanently deleted.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button - White with black border and text
            Container(
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
                  side: BorderSide(color: Theme.of(context).textTheme.titleMedium?.color ?? Theme.of(context).colorScheme.outline, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
                  ),
                  padding: ResponsiveDesign.getPadding(horizontal: 24, vertical: 8),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveDesign.getFontSize(14),
                  ),
                ),
              ),
            ),
            ResponsiveSpacing(height: 0, width: 12),
            // Confirm Button - Red with white text
            Container(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteConcern(concern);
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
                  ),
                  padding: ResponsiveDesign.getPadding(horizontal: 24, vertical: 8),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveDesign.getFontSize(14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    }
  }
