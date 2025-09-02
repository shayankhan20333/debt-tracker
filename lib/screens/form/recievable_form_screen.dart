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
  late TextEditingController? descriptionController;
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final fetchedUsers = await userProvider.getAllUsers(context: context);
    fetchedUsers.removeWhere((element) {
      return element.userId == FirebaseAuthService().getCurrentUserId();
    });
    setState(() {
      users = fetchedUsers;
      isLoading = false;
    });
  }

  String getUserNameById(String userId) {
    return users.firstWhere((u) => u.userId == userId).userName ?? '';
  }

  void _toggleUserSelection(String userId, bool selected) {
    setState(() {
      if (selected) {
        selectedUsers.add(userId);
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
    if (!_formkey.currentState!.validate()) {
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
        if (text.isEmpty || double.tryParse(text) == null) {
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
    if (_validateForm()) {
      setState(() {
        isLoading = true;
      });

      try {
        final currentUserId = FirebaseAuthService().getCurrentUserId();
        final participants = [currentUserId!, ...selectedUsers];
        List<double> rates;

        if (selectedValue == "equalDistribution") {
          final equalAmount = amount / participants.length;
          rates = List.filled(participants.length, equalAmount);
        } else {
          rates = [
            0.0,
            ...selectedUsers.map(
              (id) => double.parse(perHeadControllers[id]!.text),
            ),
          ];
        }

        final receivable = ReceivableModel(
          id: DateTime.now().millisecondsSinceEpoch,
          description: descriptionController!.text,
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Form(
              key: _formkey,
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                    focusNode: descriptionFocus,
                    maxLines: 5,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                  ),
                  const TitleText(title: "Hostlers"),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: SingleChildScrollView(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        children: List.generate(users.length, (index) {
                          return UserCheckboxTile(
                            user: users[index],
                            isSelected: selectedUsers.contains(
                              users[index].userId,
                            ),
                            onChanged: (val) => _toggleUserSelection(
                              users[index].userId ?? '',
                              val ?? false,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const TitleText(title: "Amount Method"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value: selectedValue,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(76, 61, 54, 54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: const Color.fromARGB(255, 85, 85, 85),
                      borderRadius: BorderRadius.circular(20),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "equalDistribution",
                          child: Center(child: Text("Equal Distribution")),
                        ),
                        DropdownMenuItem(
                          value: "perHead",
                          child: Center(child: Text("Per Person Distribution")),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                          if (selectedValue == "perHead") {
                            for (var id in selectedUsers) {
                              perHeadControllers[id] ??=
                                  TextEditingController();
                            }
                          }
                        });
                      },
                    ),
                  ),

                  const TitleText(title: "Amount"),
                  selectedValue == "equalDistribution"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Amount",
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              amount = double.tryParse(val) ?? 0;
                            },
                          ),
                        )
                      : Column(
                          children: selectedUsers.map((id) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(title: getUserNameById(id)),
                                  TextFormField(
                                    controller: perHeadControllers[id],
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          Size(double.infinity, 50),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: TitleText(title: "Submit", color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    return CheckboxListTile.adaptive(
      dense: true,
      title: SubtitleText(title: user.userName ?? "", fontSize: 15),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}
