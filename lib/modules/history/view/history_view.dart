

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/db_helper.dart';
import '../../../utils/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/models/denomination_model.dart';

class HistoryView extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final HomeController homeController = Get.find<HomeController>();

  HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryC,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: whiteC,
            )),
        surfaceTintColor: whiteC,
        title: Text(
          'History',
          style: TextStyle(color: whiteC),
        ),
        backgroundColor: lightBlueC,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getDenominations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved entries found'));
          }

          final entries =
              snapshot.data!.map((e) => DenominationModel.fromMap(e)).toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildSwipeableCard(context, entry);
            },
          );
        },
      ),
    );
  }
Widget _buildSwipeableCard(BuildContext context, DenominationModel entry) {
  return Slidable(
    key: ValueKey(entry.id),
    startActionPane: ActionPane(
      motion: ScrollMotion(), 
      extentRatio: 0.75,
      children: [
        SlidableAction(
          onPressed: (_) => _shareEntry(entry),
          backgroundColor: greenC,
          foregroundColor: whiteC,
          icon: Icons.share,
          
          label: 'Share',
        ),
        SlidableAction(
          onPressed: (_) {
            homeController.loadEntry(entry);
            Get.back();
          },
          backgroundColor: lightBlueC,
          foregroundColor: whiteC,
          icon: Icons.edit,
          label: 'Edit',
        ),
        SlidableAction(
          onPressed: (_) => _showDeleteConfirmation(context, entry),
          backgroundColor: redC,
          foregroundColor: whiteC,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: Card(
      color: lightBlueC,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(entry.title, style: TextStyle(fontWeight: FontWeight.bold,color: whiteC)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${entry.total}', style: TextStyle(color: whiteC,  ),),
            if (entry.remark != null && entry.remark!.isNotEmpty)
              Text('Remark: ${entry.remark}', style: TextStyle(color: whiteC,  ),),
            Text('Date: ${_formatDate(entry.createdAt)}', style: TextStyle(color: whiteC, ),),
          ],
        ),
        trailing: Icon(Icons.swipe_left, color: whiteC),
        onTap: () => _showEntryDetails(context, entry),
      ),
    ),
  );
}

   

  void _shareEntry(DenominationModel entry) {
    final denominationDetails = [
      if (entry.d2000 > 0) '₹2000 × ${entry.d2000} = ₹${entry.d2000 * 2000}',
      if (entry.d500 > 0) '₹500 × ${entry.d500} = ₹${entry.d500 * 500}',
      if (entry.d200 > 0) '₹200 × ${entry.d200} = ₹${entry.d200 * 200}',
      if (entry.d100 > 0) '₹100 × ${entry.d100} = ₹${entry.d100 * 100}',
      if (entry.d50 > 0) '₹50 × ${entry.d50} = ₹${entry.d50 * 50}',
      if (entry.d20 > 0) '₹20 × ${entry.d20} = ₹${entry.d20 * 20}',
      if (entry.d10 > 0) '₹10 × ${entry.d10} = ₹${entry.d10 * 10}',
      if (entry.d5 > 0) '₹5 × ${entry.d5} = ₹${entry.d5 * 5}',
      if (entry.d2 > 0) '₹2 × ${entry.d2} = ₹${entry.d2 * 2}',
      if (entry.d1 > 0) '₹1 × ${entry.d1} = ₹${entry.d1 * 1}',
    ].join('\n');

    final shareText = '''
Denomination Details: ${entry.title}
Total Amount: ₹${entry.total}
${entry.remark != null && entry.remark!.isNotEmpty ? 'Remark: ${entry.remark}\n' : ''}
Date: ${_formatDate(entry.createdAt)}

Denomination Breakdown:
$denominationDetails
''';

    Share.share(shareText);
  }

  String _formatDate(String isoString) {
    final date = DateTime.parse(isoString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmation(BuildContext context, DenominationModel entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: lightBlueC,
        title: Text('Delete Entry', style: TextStyle(color: whiteC, fontWeight: FontWeight.bold),),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: whiteC, fontWeight: FontWeight.bold),),
          ),
          ElevatedButton(
            onPressed: () async {
              await dbHelper.deleteDenomination(entry.id!);
              Navigator.pop(context);
              // Refresh the list
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: redC),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(BuildContext context, DenominationModel entry) {
    showDialog( 
      context: context,
      builder: (context) => AlertDialog(backgroundColor: lightBlueC,
        title: Text(entry.title, style: TextStyle(color: whiteC, fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Amount: ₹${entry.total}'),
              Text('In Words: ${entry.amountText}'),
              if (entry.remark != null && entry.remark!.isNotEmpty)
                Text('Remark: ${entry.remark}'),
              Divider(),
              Text('Denomination Details:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _denominationRow('₹2000', entry.d2000, entry.d2000 * 2000),
              _denominationRow('₹500', entry.d500, entry.d500 * 500),
              _denominationRow('₹200', entry.d200, entry.d200 * 200),
              _denominationRow('₹100', entry.d100, entry.d100 * 100),
              _denominationRow('₹50', entry.d50, entry.d50 * 50),
              _denominationRow('₹20', entry.d20, entry.d20 * 20),
              _denominationRow('₹10', entry.d10, entry.d10 * 10),
              _denominationRow('₹5', entry.d5, entry.d5 * 5),
              _denominationRow('₹2', entry.d2, entry.d2 * 2),
              _denominationRow('₹1', entry.d1, entry.d1 * 1),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: whiteC, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }

  Widget _denominationRow(String denomination, int count, int total) {
    if (count == 0) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(denomination),
          Text(' × $count'),
          Spacer(),
          Text('₹$total'),
        ],
      ),
    );
  }

 
  void setState(VoidCallback fn) {
    Get.forceAppUpdate();
  }
}