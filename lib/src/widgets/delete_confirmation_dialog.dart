import 'package:book_lending_note/src/bloc/delete_confirmation_bloc/delete_confirmation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String type;
  final dynamic id; // book use isbn(String), note/news use id(int)
  final Function deleteFunc;

  const DeleteConfirmationDialog(
      {Key? key, required this.type, required this.id, required this.deleteFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteConfirmationBloc(
          id: id,
          deleteFunc: deleteFunc),
      child: BlocListener<DeleteConfirmationBloc, DeleteConfirmationState>(
        listener: (context, state) {
          if (state is CompleteState) {
            Navigator.pop(context, true);
          }
        },
        child: AlertDialog(
          title: Text('Delete $type'),
          content: Text('Are you sure you want to delete this $type'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      context
                          .read<DeleteConfirmationBloc>()
                          .add(ConfirmDeleteEvent());
                    },
                    child: const Text('Confirm'));
              }
            )
          ],
        ),
      ),
    );
  }
}
