import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:live_score/controllers/match_controller.dart';
import 'package:live_score/models/score_model.dart';
import 'package:live_score/services/db_services.dart';
import 'package:live_score/widgets/custo_snk.dart';

import 'add_score_scrren.dart';

class HomeScreen extends StatelessWidget {
  final _dbServices = DbServices();
  final MatchController _matchController = Get.put(MatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Score'), centerTitle: true),
      body: Obx((){
        if(_matchController.matchList.isEmpty){
          return const Center(child: Text('No Data Found / Loading...'));
        }

        return ListView.separated(
          itemCount: _matchController.matchList.length,
          itemBuilder: (context, index) {
            final match = _matchController.matchList[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 8,
                backgroundColor: match.isRunning ? Colors.green : Colors.grey,
              ),
              title: Row(
                children: [
                  Text('${match.team1Name} vs ${match.team2Name}'),
                  Badge(
                    child: IconButton(
                      onPressed: () {
                        Get.to(()=>MatchForms(match: match));

                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
              subtitle: Text('Winner Team: ${match.winnerTeam}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${match.team1Score}:${match.team2Score}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              onLongPress: () async {
                if (match.id == null) {
                  Get.snackbar('Error', 'Match ID not found, cannot delete!');
                  return;
                }
                Get.defaultDialog(
                  title: 'Delete Match',
                  middleText: 'Are you sure you want to delete this match?',
                  textCancel: 'Cancel',
                  textConfirm: 'Delete',
                  buttonColor: Colors.red,
                  confirmTextColor: Colors.white,
                  onCancel: (){},
                  onConfirm: () async {
                    _matchController.deleteMatch(match.id!);
                    Get.back();
                  }



                );

              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(()=>MatchForms());
        },
      ),
    );
  }
}
