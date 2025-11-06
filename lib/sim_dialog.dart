// SIM Selection Dialog
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';

class SimSelectionDialog extends StatefulWidget {
  final Function(String) onNumberSelected;

  const SimSelectionDialog({
    Key? key,
    required this.onNumberSelected,
  }) : super(key: key);

  @override
  State<SimSelectionDialog> createState() => _SimSelectionDialogState();
  
}

class _SimSelectionDialogState extends State<SimSelectionDialog> {
  List<SimInfo>? _simInfo;
  final _simCardInfoPlugin = SimCardInfo();
  bool isSupported = true;

  @override
  void initState() {
    super.initState();
    initSimInfoState();
  }



   // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initSimInfoState() async {
    await Permission.phone.request();
    List<SimInfo> simCardInfo;
    
    try {
      simCardInfo = await _simCardInfoPlugin.getSimInfo() ?? [];
    } on PlatformException {
      simCardInfo = [];
      setState(() {
        isSupported = false;
      });
    }
    if (!mounted) return;
    setState(() {
      _simInfo = simCardInfo;
    });
  }

  @override
  Widget build(BuildContext context) {

    
    // Simulated SIM card data
    
    final List<Map<String, String>> simCards = [
      {
        'operator': 'Airtel',
        'number': '+91 98765 43210',
        'icon': '📱',
      },
      {
        'operator': 'Jio',
        'number': '+91 87654 32109',
        'icon': '📞',
      },
    ];

    return 
   Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  child: Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            const Icon(
              Icons.sim_card,
              color: Colors.blue,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'Select SIM',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Content based on state
        if (_simInfo == null) ...[
          // Loading state
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading SIM cards...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else if (_simInfo!.isEmpty) ...[
          // Empty state
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.sim_card_alert,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No SIM cards found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please insert a SIM card',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          // SIM Cards List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _simInfo!.length,
              itemBuilder: (context, index) {
                final sim = _simInfo![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Check if number exists and is not empty
                        if (sim.number?.isNotEmpty ?? false) {
                          widget.onNumberSelected(sim.number!);
                          Navigator.of(context).pop();
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number not available for this SIM'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: index == 0 
                                  ? const Icon(
                                      Icons.looks_one,
                                      color: Colors.blue,
                                      size: 24,
                                    )
                                  : const Icon(
                                      Icons.looks_two,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          sim.carrierName.isNotEmpty
                                              ? sim.carrierName
                                              : 'Unknown Carrier',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'SIM ${index + 1}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    sim.number.isNotEmpty
                                        ? sim.number
                                        : 'Number not available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: (sim.number.isNotEmpty)
                                          ? Colors.grey.shade600
                                          : Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Arrow
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        
        // Error state (add this to your state variables)
        if (!isSupported && _simInfo == null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SIM reading not supported',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This device does not support SIM card reading',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  ),
);
  }
}