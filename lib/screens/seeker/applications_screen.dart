import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application_model.dart';
import '../../providers/app_state.dart';
import '../../widgets/application_card.dart';
import '../../widgets/empty_state.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) => Consumer<AppState>(
        builder: (context, state, _) {
          final items = List<ApplicationModel>.of(state.applications)
            ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
          if (items.isEmpty) {
            return const EmptyState(
                icon: Icons.description_outlined,
                title: 'No applications yet',
                subtitle: 'Jobs you apply to will show up here.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) =>
                ApplicationCard(application: items[index]),
          );
        },
      );
}
