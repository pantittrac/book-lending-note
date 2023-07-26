part of 'delete_confirmation_bloc.dart';

@immutable
abstract class DeleteConfirmationEvent {}

class ConfirmDeleteEvent extends DeleteConfirmationEvent {}

class CancelDeleteEvent extends DeleteConfirmationEvent {}