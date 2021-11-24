import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompBloc extends Bloc<CompEvent, CompState> {
  
  final ComputationRepo comprepository;

  CompBloc({@required this.comprepository})
      : assert(comprepository != null),
        super(CompLoading());

  @override
  Stream<CompState> mapEventToState(CompEvent event) async* {
    if (event is CompCreate) {
      try {
        await comprepository.createComputation(event.comp);

        yield CompLoadSuccess();
      } catch (_) {
        yield CompOperationFailure();
      }
    }

    if (event is CompLoad) {
      yield CompLoading();
      try {
        final comps = await comprepository.showComptition(event.id);
        yield CompLoadSuccess(comps);
      } catch (e) {
        yield CompOperationFailure();
      }
    }
    if (event is WinnersLoad) {
      yield CompLoading();
      try {
        final comps = await comprepository.showwinners(event.id);

        yield WinnersLoadSuccess(comps);
      } catch (e) {
        yield CompOperationFailure();
      }
    }

    if (event is CompDelete) {
      try {
        await comprepository.deleteComputition(event.comp);
        final comp = await comprepository.showComptition(event.id);
        yield CompLoadSuccess(comp);
      } catch (e) {
        print(e);
        yield CompOperationFailure();
      }
    }
    if (event is UpdateJudgePoint) {
      try {
        await comprepository.updatejudgepoints(event.id, event.judgePoints);
        
      } catch (e) {
        print(e);
        yield CompOperationFailure();
      }
    }
  }
}
