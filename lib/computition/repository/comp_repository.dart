import 'package:appp/lib.dart';

class ComputationRepo {
  ComputitionProvider compProvider;

  ComputationRepo() : assert(ComputitionProvider != null) {
    ComputitionProvider.getInstance().then((value) {
      this.compProvider = value;
    });
  }

  Future<COmputationPost> createComputation(COmputationPost comp) async {
    return await compProvider.createComputition(comp);
  }

  Future<Computation> showComptition(String id) async {
    return await compProvider.getComputations(id);
  }

  Future<Winners> showwinners(String id) async {
    return await compProvider.winers(id);
  }

  Future<void> deleteComputition(String id) async {
    return await compProvider.deleteComputition(id);
  }

  Future<String> updatejudgepoints(String id, int judgepoints) async {
    return await compProvider.updateJudgePoints(id, judgepoints);
  }
   Future<int> updateLike(String postownerid, String loggedinuser) async {
    return await compProvider.updateLike(postownerid, loggedinuser);
  }

  Future<int> updateDislike(
    String postownerid,
    String loggedinuser,
  ) async {
    return await compProvider.updateDislike(
      postownerid,
      loggedinuser,
    );
  }
}
