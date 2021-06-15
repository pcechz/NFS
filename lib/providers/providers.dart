import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/network.dart';
import 'package:app/data/repositories/pokemon_repository.dart';
import 'package:app/data/source/github/github_datasource.dart';
import 'package:app/data/source/local/local_datasource.dart';
import 'package:app/domain/usecases/pokemon_usecases.dart';
import 'package:app/states/states.dart';

part 'data_sources.dart';
part 'repositories.dart';
part 'services.dart';
part 'states.dart';
part 'use_cases.dart';
