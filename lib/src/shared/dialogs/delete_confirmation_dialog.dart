import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Voulez vous vraiment faire ça ?"),
            Row(
              children: [
                Expanded(child: Container()),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Annuler"),
                ),
                Button(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  text: "Supprimer",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}