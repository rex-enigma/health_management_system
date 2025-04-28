import 'package:flutter/material.dart';
import 'package:health_managment_system/enums/gender.dart';
import 'package:health_managment_system/ui/reusable_widgets/client_card.dart';
import 'package:health_managment_system/ui/views/clients/clients_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ClientsView extends StackedView<ClientsViewModel> {
  const ClientsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ClientsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClientSearchDelegate(viewModel),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: viewModel.clients.isEmpty && !viewModel.isBusy
            ? const Center(child: Text('No clients available'))
            : ListView.builder(
                controller: viewModel.scrollController,
                itemCount:
                    viewModel.clients.length + (viewModel.hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.clients.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final client = viewModel.clients[index];
                  return ClientCard(
                    firstName: client.firstName,
                    lastName: client.lastName,
                    gender: Gender.fromString(client.gender.name),
                    dateOfBirth: client.dateOfBirth,
                    address: client.address,
                    onTap: () => viewModel.navigateToClientProfile(client.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.navigateToRegisterClient(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  ClientsViewModel viewModelBuilder(BuildContext context) => ClientsViewModel();

  @override
  void onViewModelReady(ClientsViewModel viewModel) {
    print('testsssssssssssssssssssssssssss');

    viewModel.loadClients();
  }
}

class ClientSearchDelegate extends SearchDelegate {
  final ClientsViewModel viewModel;

  ClientSearchDelegate(this.viewModel);

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
    final results = viewModel.searchClients(query);
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
        final client = results[index];
        return ClientCard(
          firstName: client.firstName,
          lastName: client.lastName,
          gender: Gender.fromString(client.gender.name),
          dateOfBirth: client.dateOfBirth,
          address: client.address,
          onTap: () => viewModel.navigateToClientProfile(client.id),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = viewModel.searchClients(query);
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
        final client = suggestions[index];
        return ClientCard(
          firstName: client.firstName,
          lastName: client.lastName,
          gender: Gender.fromString(client.gender.name),
          dateOfBirth: client.dateOfBirth,
          address: client.address,
          onTap: () => viewModel.navigateToClientProfile(client.id),
        );
      },
    );
  }
}
