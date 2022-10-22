import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      this.onTap,
      required this.object,
      this.index,
      this.title,
      this.subtitle,
      this.button1,
      this.button2,
      this.color});
  final Object object;
  final Widget? title;
  final int? index;
  final Widget? subtitle;

  final void Function()? button1;
  final void Function()? button2;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[900],
              child: Text(
                "$index",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          title: title,
          subtitle: subtitle,
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: button1,
                  icon: const Icon(Icons.edit),
                  color: Colors.orange,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          // ignore: prefer_const_constructors
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: const Text('ATENÇÃO'),
                            content: const Text(
                              'Deseja realmente excluir este cliente ?',
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                  onPressed: button2, child: const Text('SIM')),
                              const SizedBox(
                                width: 20,
                                height: 20,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('NÃO'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                )
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
