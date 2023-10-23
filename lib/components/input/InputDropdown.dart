import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputDropdown extends StatelessWidget {
  final List data;
  final String input;
  final String label;
  final double margin;
  final placeholder;
  final bool isError;
  final Color? dropdownColor;
  final Color? fillColor;
  final bool? filled;
  final void Function(dynamic newValue) onChanged;
  const InputDropdown(
      {Key? key,
      required this.input,
      required this.label,
      required this.data,
      this.margin = 10,
      this.placeholder = "Pilih...",
      this.isError = false,
      required this.onChanged,
      this.filled = false,
      this.fillColor,
      this.dropdownColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List _data = [
      {
        'label': placeholder,
        'id': "",
      }
    ];
    _data.addAll(data);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              filled: filled,
              fillColor: fillColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    color: isError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(.1)),
              ),
              label: Text(label),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: const OutlineInputBorder(),
            ),
            child: DropdownButton(
              icon: SvgPicture.asset(
                'assets/icons/icon_chevron_down.svg',
                color: Colors.black45,
                width: 10,
              ),
              dropdownColor:
                  dropdownColor ?? Theme.of(context).colorScheme.surface,
              style: Theme.of(context).textTheme.bodySmall,
              alignment: Alignment.center,
              isExpanded: true,
              underline: const SizedBox(),
              value: input.toString() == 'null' ? "" : input,
              items: List.generate(
                _data.length,
                (index) {
                  final getData = _data[index];
                  return DropdownMenuItem(
                    enabled: getData['id'] != '' ? true : false,
                    value: getData['id'],
                    child: Text(
                      getData['label'],
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: getData['id'] != ''
                              ? Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .color!
                                  .withOpacity(1)
                              : Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .color!
                                  .withOpacity(.3)),
                    ),
                  );
                },
              ),
              onChanged: onChanged,
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 7, top: 7),
              child: Text(
                'Mohon untuk diisi.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
