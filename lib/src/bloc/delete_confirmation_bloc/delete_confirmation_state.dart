part of 'delete_confirmation_bloc.dart';

@immutable
abstract class DeleteConfirmationState {}

class DeleteConfirmationInitial extends DeleteConfirmationState {}

class LoadingState extends DeleteConfirmationState {}

class CompleteState extends DeleteConfirmationState {}

class ErrorState extends DeleteConfirmationState {}
