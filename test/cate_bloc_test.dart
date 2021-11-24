import 'package:appp/category/cat_repository/category_repo.dart';
import 'package:appp/lib.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:bloc_test/bloc_test.dart';

class CityMockRepository extends Mock implements CatRepo {}

void main() {
  CityMockRepository cityMockRepository;
  setUp(() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await pathProvider.getTemporaryDirectory(),
    );

    cityMockRepository = CityMockRepository();
  });

  group('get category', () {
    final city = [Category(name: "model", id: "123")];

    blocTest("get category",
        build: () {
          when(cityMockRepository.getCategory()).thenAnswer((_) async => city);
          return CatBloc(catrepository: cityMockRepository);
        },
        act: (bloc) => bloc.add(CategoryLoad()),
        expect: () => [
              CategoryLoading(),
              CategoryLoadSuccess(city),
            ]);
  });
}
