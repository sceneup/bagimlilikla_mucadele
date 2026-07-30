import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/secim_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TetikleyiciAdimi extends ConsumerWidget {
  const TetikleyiciAdimi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(odakKontroluViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SecimGrid(
        ogeler: viewModel.tetikleyiciler,
        onSecildi: viewModel.tetikleyiciSec,
      ),
    );
  }
}
