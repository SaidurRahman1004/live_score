import 'package:flutter/material.dart';
import 'package:live_score/models/score_model.dart';
import 'package:live_score/services/db_services.dart';
import 'package:live_score/widgets/custo_snk.dart';

import 'add_score_scrren.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbServices = DbServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Score'), centerTitle: true),
      body: StreamBuilder<List<FootballMatch>>(
        stream: _dbServices.getFootballMatchData(),
        builder: (_, asyncSnapshoot) {
          if (asyncSnapshoot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshoot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshoot.error}'));
          }

          if (!asyncSnapshoot.hasData || asyncSnapshoot.data!.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }
          final matchData = asyncSnapshoot.data!;
          return ListView.separated(
            itemCount: matchData.length,
            itemBuilder: (context, index) {
              final match = matchData[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor: match.isRunning ? Colors.green : Colors.grey,
                ),
                title: Text('${match.team1Name} vs ${match.team2Name}'),
                subtitle: Text('Winner Team: ${match.winnerTeam}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${match.team1Score}:${match.team2Score}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async{
                        if (match.id == null) {
                          mySnkmsg('Error: Match ID not found, cannot delete!', context);
                          return;
                        }
                        final bool? _confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(' Delete Match'),
                            content: Text('Are you sure you want to delete this Match?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (_confirmDelete == true) {
                          try {
                            await _dbServices.deleteFootballMatchData(match.id!);
                            if (mounted) {
                              mySnkmsg('Trip Deleted Successfully', context);
                            }
                          } catch (e) {
                            if (mounted) {
                              mySnkmsg(e.toString(), context);
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {

                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddScoreScreen()),
          );
        },
      ),
    );
  }

  //delete
  Future<void> _showDeleteDialog(context, String id) async {
    final bool? _confirmDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Trip'),
        content: Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (_confirmDelete == true) {
      try {
        await _dbServices.deleteFootballMatchData(id);
        if (mounted) {
          mySnkmsg('Trip Deleted Successfully', context);
        }
      } catch (e) {
        if (mounted) {
          mySnkmsg(e.toString(), context);
        }
      }
    }
  }
}
