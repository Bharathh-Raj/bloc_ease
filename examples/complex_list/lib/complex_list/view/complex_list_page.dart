import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository.dart';
import '../cubit/complex_list_cubit.dart';
import '../models/item.dart';

class ComplexListPage extends StatelessWidget {
  const ComplexListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complex List')),
      body: BlocProvider(
        create: (_) => ComplexListCubit(
          repository: context.read<Repository>(),
        )..fetchList(),
        child: const ComplexListView(),
      ),
    );
  }
}

class ComplexListView extends StatelessWidget {
  const ComplexListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FourStateBuilder<ComplexListCubit, List<Item>>(
      succeedBuilder: (items) => ItemView(items: items),
    );
  }
}

class ItemView extends StatelessWidget {
  const ItemView({required this.items, super.key});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const Center(child: Text('no content'))
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ItemTile(
                item: items[index],
                onDeletePressed: (id) {
                  context.read<ComplexListCubit>().deleteItem(id);
                },
              );
            },
            itemCount: items.length,
          );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.item,
    required this.onDeletePressed,
    super.key,
  });

  final Item item;
  final ValueSetter<String> onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text('#${item.id}'),
        title: Text(item.value),
        trailing: item.isDeleting
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDeletePressed(item.id),
              ),
      ),
    );
  }
}
