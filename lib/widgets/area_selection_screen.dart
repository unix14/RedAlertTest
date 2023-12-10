import 'package:flutter/material.dart';
import 'package:red_alert_test_android/models/area.dart';

import '../common/extensions.dart';
import '../common/styles.dart';
import 'home_screen.dart';

class AreaSelectionScreen extends StatefulWidget {
  final List<Area> areas;
  late final List<Area> selected;

  AreaSelectionScreen({required this.areas, List<Area>? selectedAreas}) {
    selected = selectedAreas ?? [];
  }

  @override
  _AreaSelectionScreenState createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen> {
  late Set<Area> selectedAreas;
  late List<Area> filteredAreas;

  @override
  void initState() {
    super.initState();
    selectedAreas = Set<Area>();
    filteredAreas = widget.areas;
    selectedAreas.addAll(widget.selected);
  }

  void updateSelectedAreas(Set<Area> areas) {
    setState(() {
      selectedAreas = areas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('בחירת איזורי התראה'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: AreaSearchDelegate(
                      widget.areas, selectedAreas, updateSelectedAreas),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: filteredAreas.length,
          itemBuilder: (context, index) {
            final area = filteredAreas[index];
            final isSelected = selectedAreas.contains(area);

            return ListTile(
              title: Text(area.labelHe ?? area.label ?? area.areaName),
              onTap: () {
                updateSelectedAreas(Set.from(selectedAreas)..toggle(area));
              },
              tileColor: isSelected ? Colors.blue.withOpacity(0.3) : null,
            );
          },
        ),
        bottomNavigationBar: buildBottomAppBar(context, selectedAreas, (area) {
          updateSelectedAreas(Set.from(selectedAreas)..toggle(area));
        }),
      ),
    );
  }
}

BottomAppBar buildBottomAppBar(
    BuildContext context,
    Set<Area> selectedAreas,
    AreaCallback onDelete,
    {bool finishButtonIsVisible = true}
    ) {
  return BottomAppBar(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (final area in selectedAreas) createAreaChip(area, onDelete),
          const Spacer(),
          finishButtonIsVisible ? TextButton(
            onPressed: selectedAreas.isNotEmpty
                ? () {
                    // Navigate to HomeScreen with selected areas
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(selectedAreas.toList()),
                      ),
                    );
                  }
                : null, // Disable the button if selectedAreas is empty
            style:
                selectedAreas.isNotEmpty ? kBlueButtonStyle : kGreyButtonStyle,
            child: const Text('סיום'),
          ) : Container(),
        ],
      ),
    ),
  );
}

class AreaSearchDelegate extends SearchDelegate<Area?> {
  final List<Area> areas;
  final Set<Area> selectedAreas;
  final Function(Set<Area>) updateSelectedAreas;

  AreaSearchDelegate(this.areas, this.selectedAreas, this.updateSelectedAreas);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context, query);
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    final filteredResults = areas.where((area) =>
        area.labelHe.toLowerCase().contains(query.toLowerCase()) ||
        area.label.toLowerCase().contains(query.toLowerCase()) ||
        area.areaName.toLowerCase().contains(query.toLowerCase()));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final area = filteredResults.elementAt(index);
                final isSelected = selectedAreas.contains(area);

                return ListTile(
                  title: Text(area.labelHe ?? area.label ?? area.areaName),
                  onTap: () {
                    updateSelectedAreas(Set.from(selectedAreas)..toggle(area));
                    close(context, area);
                  },
                  tileColor: isSelected ? Colors.blue.withOpacity(0.3) : null,
                );
              },
            ),
          ),
          buildBottomAppBar(context, selectedAreas, (area) {
            updateSelectedAreas(Set.from(selectedAreas)..toggle(area));
            close(context, null);
          }, finishButtonIsVisible: false)
        ],
      ),
    );
  }
}
