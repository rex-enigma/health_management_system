import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/reusable_widgets/health_Program_card.dart';
import 'package:health_managment_system/ui/views/health_programs/health_programs_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HealthProgramsView extends StackedView<HealthProgramsViewModel> {
  const HealthProgramsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HealthProgramsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Programs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: HealthProgramSearchDelegate(viewModel),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: viewModel.healthPrograms.isEmpty && !viewModel.isBusy
            ? const Center(child: Text('No health programs available'))
            : ListView.builder(
                controller: viewModel.scrollController,
                itemCount: viewModel.healthPrograms.length + (viewModel.hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.healthPrograms.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final program = viewModel.healthPrograms.elementAt(index);
                  return HealthProgramCard(
                    name: program.name,
                    description: program.description,
                    startDate: program.startDate,
                    endDate: program.endDate,
                    onTap: () => viewModel.navigateToHealthProgram(program.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.navigateToCreateHealthProgram(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  HealthProgramsViewModel viewModelBuilder(BuildContext context) => HealthProgramsViewModel();

  @override
  void onViewModelReady(HealthProgramsViewModel viewModel) {
    viewModel.loadHealthPrograms();
  }
}

class HealthProgramSearchDelegate extends SearchDelegate {
  final HealthProgramsViewModel viewModel;

  HealthProgramSearchDelegate(this.viewModel);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    viewModel.searchHealthPrograms(query);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.busy('loadSearchPrograms')) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final results = viewModel.filteredPrograms;

        return ListView.builder(
          controller: viewModel.searchScrollController,
          itemCount: results.length + (viewModel.hasMoreSearchData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == results.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final program = results.elementAt(index);

            return HealthProgramCard(
              name: program.name,
              description: program.description,
              startDate: program.startDate,
              endDate: program.endDate,
              onTap: () => viewModel.navigateToHealthProgram(program.id),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = viewModel.filteredPrograms
        .where((program) => program.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      controller: viewModel.searchScrollController,
      itemCount: suggestions.length + (viewModel.hasMoreSearchData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == suggestions.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final program = suggestions[index];
        return HealthProgramCard(
          name: program.name,
          description: program.description,
          startDate: program.startDate,
          endDate: program.endDate,
          onTap: () => viewModel.navigateToHealthProgram(program.id),
        );
      },
    );
  }
}
