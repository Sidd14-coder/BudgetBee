import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../widgets/app_drawer.dart';
import '../../services/dream_service.dart';
import '../../models/dream_model.dart';
import 'package:intl/intl.dart';

class DreamEngineScreen extends StatefulWidget {
  const DreamEngineScreen({super.key});

  @override
  State<DreamEngineScreen> createState() => _DreamEngineScreenState();
}

class _DreamEngineScreenState extends State<DreamEngineScreen> {
  List<DreamModel> _dreams = [];

  @override
  void initState() {
    super.initState();
    _loadDreams();
  }

  void _loadDreams() {
    setState(() {
      _dreams = DreamService.getAllDreams();
    });
  }

  final _f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  void _showAddDreamSheet() {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 90));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20, right: 20, top: 30,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎯 Set a New Dream', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E002B))),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Dream Name (e.g., iPhone 16 Pro)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Target Amount (₹)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                
                // Date Picker Block
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)), // up to 10 years
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF0A3622), // header background color
                              onPrimary: Colors.white, // header text color
                              onSurface: Colors.black, // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF0A3622),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setModalState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deadline: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const Icon(Icons.calendar_today, color: Color(0xFF0A3622)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3622)),
                    onPressed: () {
                      final t = double.tryParse(targetCtrl.text);
                      if (nameCtrl.text.isNotEmpty && t != null && t > 0) {
                        DreamService.addDream(DreamModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameCtrl.text,
                          targetAmount: t,
                          savedAmount: 0,
                          deadline: selectedDate,
                        ));
                        Navigator.pop(ctx);
                        _loadDreams();
                      }
                    },
                    child: const Text('Start Tracking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }
      ),
    );
  }

  void _updateProgress(DreamModel dream) {
    final saveCtrl = TextEditingController();
    showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (ctx) => AlertDialog(
        title: Text('Update "${dream.name}"'),
        content: TextField(
          controller: saveCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount to add to savings (₹)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3622)),
            onPressed: () {
              final amt = double.tryParse(saveCtrl.text);
              if (amt != null && amt > 0) {
                DreamService.updateSavedAmount(dream.id, dream.savedAmount + amt);
                Navigator.pop(ctx);
                _loadDreams();
              }
            },
            child: const Text('Save Progress'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        title: const Text('🎯 Dream Engine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE8B923),
        onPressed: _showAddDreamSheet,
        icon: const Icon(Icons.add_task, color: Colors.white),
        label: const Text('New Dream', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _dreams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No Dreams Selected', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
                  const SizedBox(height: 10),
                  const Text('Budgeting is boring. Track your dreams instead!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              itemCount: _dreams.length,
              itemBuilder: (context, index) {
                final dream = _dreams[index];
                final progress = dream.targetAmount > 0 ? (dream.savedAmount / dream.targetAmount).clamp(0.0, 1.0) : 0.0;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE8B923).withOpacity(0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(dream.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E002B))),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                            tooltip: 'Delete Dream',
                            onPressed: () {
                              showModal(
                                context: context,
                                configuration: const FadeScaleTransitionConfiguration(),
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Dream?'),
                                  content: Text('Are you sure you want to delete "${dream.name}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                      onPressed: () {
                                        DreamService.deleteDream(dream.id);
                                        Navigator.pop(ctx);
                                        _loadDreams();
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Target: ${_f.format(dream.targetAmount)}', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      
                      // Progress Bar
                      Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFE8B923), Color(0xFF0A3622)]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Saved so far', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(_f.format(dream.savedAmount), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0A3622))),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E002B),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white, size: 16),
                            label: const Text('Add Funds', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: () => _updateProgress(dream),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
