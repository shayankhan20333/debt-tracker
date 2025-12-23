import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:depth_tracker/DataBase/firebase/firebase_low_level_classes.dart';
import 'package:depth_tracker/DataBase/isar/isar_collections/isar_collections.dart';
import 'package:depth_tracker/model/receivable_model.dart';
import 'package:depth_tracker/providers/receivable_provider.dart';
import 'package:depth_tracker/providers/user_provider.dart';
import 'package:depth_tracker/screens/loading_manager.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:depth_tracker/widgets/subtitle_text.dart';
import 'package:depth_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecievableFormScreen extends StatefulWidget {
  const RecievableFormScreen({super.key});

  static const roatName = '/RecievableFormScreen';

  @override
  State<RecievableFormScreen> createState() => _RecievableFormScreenState();
}

class _RecievableFormScreenState extends State<RecievableFormScreen> {
  late GlobalKey<FormState> _formkey;
  late FocusNode descriptionFocus;

  List<IsarUserProfile> users = [];
  List<String> selectedUsers = [];
  late final TextEditingController descriptionController;
  Map<String, TextEditingController> perHeadControllers = {};

  String selectedValue = "equalDistribution";
  double amount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    descriptionFocus = FocusNode();
    _formkey = GlobalKey<FormState>();
    _loadUsers();
    descriptionController = TextEditingController();
  }

  Future<void> _loadUsers() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final fetchedUsers = await userProvider.getAllUsers(context: context);
      fetchedUsers.removeWhere((element) {
        return element.userId == FirebaseAuthService().getCurrentUserId();
      });
      if (!mounted) return;
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String getUserNameById(String userId) {
    return users
            .firstWhere(
              (u) => u.userId == userId,
              orElse: () => IsarUserProfile(),
            )
            .userName ??
        '';
  }

  void _toggleUserSelection(String userId, bool selected) {
    if (userId.isEmpty) return;
    setState(() {
      if (selected) {
        if (!selectedUsers.contains(userId)) {
          selectedUsers.add(userId);
        }
        if (selectedValue == "perHead") {
          perHeadControllers[userId] = TextEditingController();
        }
      } else {
        selectedUsers.remove(userId);
        perHeadControllers.remove(userId);
      }
    });
  }

  bool _validateForm() {
    if (!(_formkey.currentState?.validate() ?? false)) {
      return false;
    }

    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TitleText(
            title: "Please select at least one user",
            color: Colors.red,
          ),
        ),
      );
      return false;
    }

    if (selectedValue == "equalDistribution") {
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TitleText(
              title: "Please enter a valid amount",
              color: Colors.red,
            ),
          ),
        );
        return false;
      }
    } else {
      for (var userId in selectedUsers) {
        final text = perHeadControllers[userId]?.text ?? '';
        final parsedAmount = double.tryParse(text);
        if (text.isEmpty || parsedAmount == null || parsedAmount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TitleText(
                title: "Enter a valid amount for ${getUserNameById(userId)}",
                color: Colors.red,
              ),
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _submitForm() async {
    if (isLoading) return;
    if (_validateForm()) {
      setState(() {
        isLoading = true;
      });

      try {
        final currentUserId = FirebaseAuthService().getCurrentUserId();
        if (currentUserId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: TitleText(
                  title: "Please sign in to add a receivable",
                  color: Colors.red,
                ),
              ),
            );
          }
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          return;
        }

        final participants = [currentUserId, ...selectedUsers];
        List<double> rates;

        if (selectedValue == "equalDistribution") {
          final totalParticipants = participants.length;
          final equalAmount =
              totalParticipants == 0 ? 0.0 : amount / totalParticipants;
          rates = [
            0.0,
            ...List.filled(selectedUsers.length, equalAmount),
          ];
        } else {
          rates = [
            0.0,
            ...selectedUsers.map(
              (id) => double.tryParse(perHeadControllers[id]?.text ?? '') ?? 0,
            ),
          ];
        }

        if (rates.length != participants.length ||
            rates.skip(1).any((r) => r <= 0)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: TitleText(
                  title: "Please enter valid amounts for all participants",
                  color: Colors.red,
                ),
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
          return;
        }

        final receivable = ReceivableModel(
          id: DateTime.now().millisecondsSinceEpoch,
          description: descriptionController.text,
          participants: participants,
          method: selectedValue,
          rate: rates,
          isReceived: List.filled(participants.length, false),
          isPaid: List.filled(participants.length, false),
          createdAt: firestore.Timestamp.now(),
        );

        final receivableProvider = Provider.of<ReceivableProvider>(
          context,
          listen: false,
        );
        await receivableProvider.createReceivable(
          context: context,
          receivable: receivable,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: TitleText(
                title: "Receivable created successfully",
                color: Colors.green,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Add Recievable",
        hasTitleDecoration: true,
        hasTitleInCenter: true,
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    icon: Icons.description_outlined,
                    title: "Description",
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Describe the receivable",
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      focusNode: descriptionFocus,
                      minLines: 2,
                      maxLines: 5,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                    ),
                  ),
                  _SectionCard(
                    icon: Icons.group_outlined,
                    title: "Participants",
                    subtitle: "Select people who owe you",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedUsers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SubtitleText(
                              title: "No participants selected",
                              color: Colors.grey[500],
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedUsers.map((id) {
                              final name = getUserNameById(id);
                              return Chip(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                label: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  child: Text(
                                    name.isNotEmpty ? name : "User",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    _toggleUserSelection(id, false),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                          constraints: const BoxConstraints(maxHeight: 320),
                          child: isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SingleChildScrollView(
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      childAspectRatio: 3,
                                      children: List.generate(users.length,
                                          (index) {
                                        return UserCheckboxTile(
                                          user: users[index],
                                          isSelected: selectedUsers.contains(
                                            users[index].userId,
                                          ),
                                          onChanged: (val) =>
                                              _toggleUserSelection(
                                            users[index].userId ?? '',
                                            val ?? false,
                                          ),
                                        );
                                      }),
                                    ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  _SectionCard(
                    icon: Icons.calculate_outlined,
                    title: "Amount method",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text("Equal distribution"),
                              selected: selectedValue == "equalDistribution",
                              onSelected: (_) {
                                setState(() {
                                  selectedValue = "equalDistribution";
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text("Per head"),
                              selected: selectedValue == "perHead",
                              onSelected: (_) {
                                setState(() {
                                  selectedValue = "perHead";
                                  for (var id in selectedUsers) {
                                    perHeadControllers[id] ??=
                                        TextEditingController();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SubtitleText(
                          title: selectedValue == "equalDistribution"
                              ? "Total is split among you + selected people"
                              : "Enter amount for each selected person",
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                  _SectionCard(
                    icon: Icons.attach_money,
                    title: "Amount",
                    child: selectedValue == "equalDistribution"
                        ? TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.currency_rupee),
                              hintText: "Total amount",
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              amount = double.tryParse(val) ?? 0;
                            },
                          )
                        : Column(
                            children: selectedUsers.map((id) {
                              final name = getUserNameById(id);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : '?',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        name.isNotEmpty ? name : 'User',
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 120,
                                      child: TextFormField(
                                        controller: perHeadControllers[id],
                                        decoration: InputDecoration(
                                          hintText: "Amount",
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    label: const TitleText(
                      title: "Submit",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SubtitleText(
                    title: "You can edit or remove later.",
                    fontSize: 12,
                    color: Colors.grey[500],
                    textalign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionFocus.dispose();
    descriptionController.dispose();
    for (final controller in perHeadControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

/// ✅ Reusable checkbox tile
class UserCheckboxTile extends StatelessWidget {
  final IsarUserProfile user;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const UserCheckboxTile({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final name = user.userName ?? '';
    return CheckboxListTile.adaptive(
      dense: true,
      title: FittedBox(
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
            ),
            const SizedBox(width: 8),
            FittedBox(
              child: SubtitleText(
                title: name,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      color: Theme.of(context).colorScheme.primary, size: 18),
                ),
                const SizedBox(width: 10),
                TitleText(title: title, fontSize: 16),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              SubtitleText(
                title: subtitle!,
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
