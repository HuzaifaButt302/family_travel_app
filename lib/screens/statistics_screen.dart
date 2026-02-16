import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../models/member_model.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildStatistics(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '📊 Family Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final provider = context.watch<FamilyProvider>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(provider),
            const SizedBox(height: 30),

            // Document Status Section
            _buildSectionTitle('📄 Document Status Overview'),
            const SizedBox(height: 16),
            _buildDocumentStatusCards(provider),
            const SizedBox(height: 30),

            // Members with Issues
            if (provider.membersWithExpiredDocs.isNotEmpty ||
                provider.membersWithExpiringSoonDocs.isNotEmpty) ...[
              _buildSectionTitle('⚠️ Members Needing Attention'),
              const SizedBox(height: 16),
              _buildMembersWithIssues(provider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(FamilyProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Family Members',
            value: provider.totalMembers.toString(),
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Total Documents',
            value: provider.totalDocuments.toString(),
            icon: Icons.description,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentStatusCards(FamilyProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Valid Documents',
                value: (provider.totalDocuments -
                        provider.totalExpiredDocuments -
                        provider.totalExpiringSoonDocuments)
                    .toString(),
                icon: Icons.check_circle,
                color: Colors.green,
                isSmall: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Expiring Soon',
                value: provider.totalExpiringSoonDocuments.toString(),
                icon: Icons.warning,
                color: Colors.orange,
                isSmall: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Expired',
                value: provider.totalExpiredDocuments.toString(),
                icon: Icons.error,
                color: Colors.red,
                isSmall: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersWithIssues(FamilyProvider provider) {
    return Column(
      children: [
        // Expired Documents Members
        if (provider.membersWithExpiredDocs.isNotEmpty) ...[
          _buildIssueSection(
            title: 'Members with Expired Documents',
            members: provider.membersWithExpiredDocs,
            color: Colors.red,
            icon: Icons.error,
          ),
          const SizedBox(height: 16),
        ],

        // Expiring Soon Members
        if (provider.membersWithExpiringSoonDocs.isNotEmpty)
          _buildIssueSection(
            title: 'Members with Expiring Documents',
            members: provider.membersWithExpiringSoonDocs,
            color: Colors.orange,
            icon: Icons.warning,
          ),
      ],
    );
  }

  Widget _buildIssueSection({
    required String title,
    required List<FamilyMember> members,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...members.map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                        member.fullName[0],
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        member.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${color == Colors.red ? member.expiredDocumentsCount : member.expiringSoonCount} docs',
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isSmall = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: isSmall ? 24 : 28,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmall ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmall ? 8 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmall ? 12 : 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }
}
