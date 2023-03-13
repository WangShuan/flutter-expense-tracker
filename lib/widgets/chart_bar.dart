import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final int dayAmount;
  final double amountPtcOfTotal;

  const ChartBar(this.label, this.dayAmount, this.amountPtcOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Column(
        children: [
          Container(
            height: constraint.maxHeight * 0.1,
            child: FittedBox(
              child: Text(
                '\$ ${dayAmount.toString()}',
              ),
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.7,
            width: 8,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: amountPtcOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      );
    });
  }
}
