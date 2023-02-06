import 'package:flutter/material.dart';

export 'job_model_widgets.dart';
export 'job_detail_section.dart';
export 'job_list_retriever.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
