import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:live_score/models/score_model.dart';
import 'package:live_score/services/db_services.dart';
import 'package:live_score/widgets/custom_button.dart';
import 'package:live_score/widgets/custom_text_field.dart';
import 'package:live_score/widgets/custo_snk.dart';
import 'package:live_score/widgets/center_circular_indicator.dart';

import '../controllers/match_controller.dart';

class MatchForms extends StatefulWidget {
  final FootballMatch? match;

  const MatchForms({super.key, this.match});

  @override
  State<MatchForms> createState() => _MatchFormsState();
}

class _MatchFormsState extends State<MatchForms> {
  final controller = Get.find<MatchController>();
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  final TextEditingController _team1ScoreController = TextEditingController();
  final TextEditingController _team2ScoreController = TextEditingController();
  final TextEditingController _winnerController = TextEditingController();

  final DbServices _dbServices = DbServices();
  bool _isLoading = false;
  bool _isRunning = true;

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    _winnerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.match != null) {
      _team1Controller.text = widget.match!.team1Name;
      _team2Controller.text = widget.match!.team2Name;
      _team1ScoreController.text = widget.match!.team1Score.toString();
      _team2ScoreController.text = widget.match!.team2Score.toString();
      _isRunning = widget.match!.isRunning;
    }
  }

  Future<void> _saveMatch() async {
    if (_team1Controller.text.isEmpty || _team2Controller.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final ts1 = int.tryParse(_team1ScoreController.text.trim()) ?? 0;
    final ts2 = int.tryParse(_team2ScoreController.text.trim()) ?? 0;

    try {
      final matchs = FootballMatch(
        id: widget.match?.id,
        team1Name: _team1Controller.text.trim(),
        team2Name: _team2Controller.text.trim(),
        team1Score: ts1,
        team2Score: ts2,
        isRunning: _isRunning,
        winnerTeam: ts1 == ts2
            ? 'Draw'
            : (ts1 > ts2
                  ? _team1Controller.text.trim()
                  : _team2Controller.text.trim()),
      );
      //Save And Update Logic
      widget.match == null
          ? await controller.addMatch(matchs)
          : await controller.updateMatch(matchs);
      Get.back();

      Get.snackbar('Success', 'Match Added Successfully');
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.match == null ? "Add Match" : "Update Match"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const CenterCircularProgressIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: _team1Controller,
                    hintText: 'Team 1 Name (e.g. Argentina)',
                    icon: Icons.flag,
                    lableText: 'Team 1',
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    controller: _team2Controller,
                    hintText: 'Team 2 Name (e.g. Brazil)',
                    lableText: 'Team 2',
                    icon: Icons.flag_outlined,
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _team1ScoreController,
                          hintText: '0',
                          lableText: 'Team 2 Score',
                          keyboardType: TextInputType.number,
                          icon: Icons.scoreboard,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: _team2ScoreController,
                          hintText: '0',
                          lableText: 'Team 2 Score',
                          keyboardType: TextInputType.number,
                          icon: Icons.scoreboard_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    controller: _winnerController,
                    hintText: 'Winner Team (Optional)',
                    lableText: 'Winner',
                    icon: Icons.emoji_events,
                  ),
                  const SizedBox(height: 15),

                  CheckboxListTile(
                    title: const Text("Match is Live/Running?"),
                    value: _isRunning,
                    onChanged: (val) {
                      setState(() {
                        _isRunning = val ?? true;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    onPressed: _saveMatch,
                    buttonName: widget.match == null
                        ? 'Add Match'
                        : 'Update Match',
                  ),
                ],
              ),
            ),
    );
  }
}
