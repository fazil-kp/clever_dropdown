import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:moon_design/moon_design.dart';

class CustomMoonDropdownNew<T> extends StatefulWidget {
  final List<T>? items;
  final T? value;
  final List<T>? values;
  final void Function(T? value)? onChanged;
  final void Function(List<T>? value)? onListChanged;
  final Function(String? value)? onCreateTap;
  final bool isMultiple;
  final bool showMultipleCount;
  final String hintText;
  final String? errorMessage;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final Color? hoverBorderColor;
  final Color? arrowColor;
  final bool? readOnly;
  final BorderRadiusGeometry? borderRadius;
  final bool? enableArrow;
  final Widget? trailing;
  final Function(T)? itemAsString;
  final List<TextInputFormatter>? inputFormatters;
  final Future<List<T>> Function(String)? asyncItems;
  final bool createOnEnter;
  final Widget? leading;
  final bool? showDropdownOnlyOnSearch;
  final double? height;
  final Color? backgroundColor;

  const CustomMoonDropdownNew({super.key, this.items, this.borderRadius, this.backgroundColor, this.readOnly = false, this.showDropdownOnlyOnSearch = false, this.activeBorderColor, this.arrowColor, this.height, this.value, this.enableArrow = true, this.inactiveBorderColor, this.hoverBorderColor, this.errorMessage, this.values, this.onChanged, this.onListChanged, this.isMultiple = false, this.showMultipleCount = true, required this.hintText, this.trailing, this.itemAsString, this.asyncItems, this.inputFormatters, this.onCreateTap, this.createOnEnter = true, this.leading});

  @override
  _CustomMoonDropdownNewState<T> createState() => _CustomMoonDropdownNewState<T>();
}

class _CustomMoonDropdownNewState<T> extends State<CustomMoonDropdownNew<T>> {
  late TextEditingController searchController;
  late List<T> filteredOptionsList;
  late bool showDropdown;
  late Map<T, bool> selectedOptions;
  late bool isLoading;
  late int highlightedIndex;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.value != null ? widget.itemAsString?.call(widget.value!).toString() ?? widget.value.toString() : '');
    filteredOptionsList = widget.items ?? [];
    showDropdown = false;
    selectedOptions = {for (T item in widget.values ?? []) item: true};
    isLoading = false;
    highlightedIndex = 0;
    scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(CustomMoonDropdownNew<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      searchController.text = widget.value != null ? widget.itemAsString?.call(widget.value!) ?? widget.value.toString() : '';
    }
    if (widget.values != oldWidget.values) {
      selectedOptions = {for (T item in widget.values ?? []) item: true};
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void performSearch() async {
    final String inputValue = searchController.text.trim().toLowerCase();
    if (inputValue.isEmpty) {
      if (!widget.isMultiple) {
        setState(() {
          selectedOptions.clear();
          widget.onChanged?.call(null);
        });
      }
      if (widget.asyncItems != null) {
        try {
          setState(() => isLoading = true);
          final asyncOptions = await widget.asyncItems!('');
          setState(() {
            filteredOptionsList = asyncOptions;
            showDropdown = widget.showDropdownOnlyOnSearch == false;
          });
        } catch (e) {
          setState(() {
            filteredOptionsList = [];
            showDropdown = widget.showDropdownOnlyOnSearch == false;
          });
        } finally {
          setState(() => isLoading = false);
        }
      } else {
        setState(() {
          filteredOptionsList = widget.items ?? [];
          showDropdown = widget.showDropdownOnlyOnSearch == false;
        });
      }
    } else {
      if (widget.asyncItems != null) {
        setState(() => isLoading = true);
        try {
          final asyncOptions = await widget.asyncItems!(inputValue);
          setState(() {
            filteredOptionsList = asyncOptions.where((T option) {
              final String optionName = widget.itemAsString?.call(option).toString().toLowerCase() ?? "";
              return optionName.contains(inputValue);
            }).toList();
            showDropdown = true;
          });
        } catch (e) {
          setState(() {
            filteredOptionsList = [];
            showDropdown = true;
          });
        } finally {
          setState(() => isLoading = false);
        }
      } else {
        setState(() {
          filteredOptionsList =
              widget.items?.where((T option) {
                final String optionName = widget.itemAsString?.call(option).toString().toLowerCase() ?? "";
                return optionName.contains(inputValue);
              }).toList() ??
              [];
          showDropdown = true;
        });
      }
    }
  }

  void handleSelect(T option) {
    setState(() {
      if (widget.isMultiple) {
        selectedOptions[option] = !(selectedOptions[option] ?? false);
        widget.onListChanged?.call(selectedOptions.entries.where((entry) => entry.value).map((entry) => entry.key).toList());
      } else {
        selectedOptions.clear;
        selectedOptions[option] = true;
        widget.onChanged?.call(option);
        showDropdown = false;
      }
    });
  }

  void clearSelections() {
    setState(() {
      selectedOptions.clear();
      widget.onChanged?.call(null);
      widget.onListChanged?.call([]);
    });
  }

  void showAllOptionsList() async {
    if (widget.asyncItems != null) {
      final asyncOptions = await widget.asyncItems!('');
      final List<T> localFilteredList = asyncOptions.where((T option) {
        final String optionName = widget.itemAsString?.call(option).toString().toLowerCase() ?? "";
        return optionName.contains('');
      }).toList();
      setState(() {
        filteredOptionsList = localFilteredList;
        selectedOptions = {for (T item in widget.values ?? []) item: true};
        showDropdown = !showDropdown;
      });
    } else {
      setState(() {
        filteredOptionsList = widget.items ?? [];
        selectedOptions = {for (T item in widget.values ?? []) item: true};
        showDropdown = !showDropdown;
      });
    }
  }

  void scrollToHighlightedItem() {
    final index = highlightedIndex;
    if (index == -1) return;

    const itemHeight = 23.0;
    final targetOffset = itemHeight * index;

    scrollController.animateTo(targetOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void handleKeyboardNavigation(RawKeyEvent event) {
    if (filteredOptionsList.isEmpty) return;

    if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      setState(() {
        highlightedIndex = (highlightedIndex + 1) % filteredOptionsList.length;
        scrollToHighlightedItem();
      });
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      setState(() {
        highlightedIndex = (highlightedIndex - 1 + filteredOptionsList.length) % filteredOptionsList.length;
        scrollToHighlightedItem();
      });
    } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      final T selectedOption = filteredOptionsList[highlightedIndex];
      setState(() {
        if (widget.isMultiple) {
          selectedOptions[selectedOption] = !(selectedOptions[selectedOption] ?? false);
          widget.onListChanged?.call(selectedOptions.entries.where((entry) => entry.value).map((entry) => entry.key).toList());
        } else {
          selectedOptions.clear();
          selectedOptions[selectedOption] = true;
          widget.onChanged?.call(selectedOption);
          showDropdown = false;
        }
      });
    }
  }

  void handleDropdownTapOutside({bool? notClose}) {
    if (notClose != true) {
      FocusScope.of(context).unfocus();
      setState(() => showDropdown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = widget.values != null ? Set<T>.from(widget.values!).length : 0;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: handleKeyboardNavigation,
      child: MoonDropdown(
        show: showDropdown,
        constrainWidthToChild: true,
        onTapOutside: handleDropdownTapOutside,
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredOptionsList.isEmpty
              ? MoonMenuItem(
                  menuItemPadding: const EdgeInsets.all(0),
                  onTap: () {
                    if (widget.onCreateTap != null) {
                      widget.onCreateTap!(searchController.text)?.then((_) {
                        setState(() => showDropdown = false);
                      });
                    }
                  },
                  label: (widget.onCreateTap == null)
                      ? Center(
                          child: Text(
                            widget.errorMessage ?? 'No results found.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                        )
                      : Container(
                          height: 40,
                          width: MediaQuery.sizeOf(context).width,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Create "${searchController.text}"',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                          ),
                        ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: filteredOptionsList.length,
                  controller: scrollController,
                  itemBuilder: (BuildContext _, int index) {
                    final T option = filteredOptionsList[index];
                    final bool isSelected = selectedOptions[option] ?? false;
                    final bool isHighlighted = index == highlightedIndex;
                    return ClipSmoothRect(
                      radius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
                      child: Container(
                        color: isHighlighted ? Colors.grey.withOpacity(0.1) : null,
                        child: MoonMenuItem(
                          onTap: () => handleSelect(option),
                          label: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.itemAsString?.call(option) ?? option.toString(),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black, fontSize: 12, fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          trailing: widget.isMultiple
                              ? SizedBox(
                                  height: 15,
                                  child: MoonCheckbox(value: isSelected, onChanged: (bool? _) => handleSelect(option)),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
        ),
        child: MoonTextInput(
          backgroundColor: widget.backgroundColor,
          readOnly: widget.readOnly ?? false,
          inputFormatters: [...widget.inputFormatters ?? []],
          activeBorderColor: widget.activeBorderColor ?? Colors.red,
          height: widget.height ?? 45,
          borderRadius: widget.borderRadius,
          inactiveBorderColor: widget.inactiveBorderColor ?? MoonColors.light.beerus,
          hoverBorderColor: widget.hoverBorderColor ?? MoonColors.light.beerus,
          hintText: widget.hintText,
          hintTextColor: Colors.grey,
          leading: widget.leading,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          controller: searchController,
          onEditingComplete: () {
            if (filteredOptionsList.isNotEmpty != true && widget.createOnEnter == true) {
              widget.onCreateTap?.call(searchController.text);
              setState(() => showDropdown = false);
            }
          },
          onTap: () {
            if (widget.showDropdownOnlyOnSearch == true) {
              final text = searchController.text.trim();
              if (text.isNotEmpty) {
                performSearch();
              }
            } else {
              showAllOptionsList();
            }
          },
          onChanged: widget.readOnly == true ? null : (_) => performSearch(),
          onTapOutside: (PointerDownEvent _) => handleDropdownTapOutside,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.trailing ?? const SizedBox.shrink(),
              if (widget.showMultipleCount && widget.isMultiple && selectedCount != 0) ...[
                Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Text(
                        '$selectedCount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => clearSelections(),
                        child: const Icon(Icons.clear, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
              if (widget.enableArrow == true)
                MoonButton.icon(
                  buttonSize: MoonButtonSize.xs,
                  hoverEffectColor: Colors.transparent,
                  onTap: showAllOptionsList,
                  icon: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: showDropdown ? -0.5 : 0,
                    child: Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: widget.arrowColor ?? Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
