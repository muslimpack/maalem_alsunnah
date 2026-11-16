import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/safe_padding_extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';

/// Pick a target content with the slider, the number field or First/Last,
/// then press Go. Nothing navigates until Go (or keyboard submit).
class ContentJumpSheet extends StatefulWidget {
  const ContentJumpSheet({super.key, required this.state});

  final ContentViewerLoadedState state;

  static Future<void> show(BuildContext context, ContentViewerLoadedState state) {
    final cubit = context.read<ContentViewerCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: Padding(
          padding: EdgeInsets.only(bottom: sheetBottomInset(context)),
          child: ContentJumpSheet(state: state),
        ),
      ),
    );
  }

  @override
  State<ContentJumpSheet> createState() => _ContentJumpSheetState();
}

class _ContentJumpSheetState extends State<ContentJumpSheet> {
  late final int _min = widget.state.contentRange.start.toInt();
  late final int _max = widget.state.contentRange.end.toInt();
  late int _target = widget.state.content.orderId.clamp(_min, _max);
  late final TextEditingController _field = TextEditingController(text: '$_target');
  bool _outOfRange = false;

  /// Title of the content at [_target], so the user sees where Go will land.
  late String _targetTitle = widget.state.title.name;
  Timer? _titleDebounce;
  int _titleRequest = 0;

  @override
  void dispose() {
    _titleDebounce?.cancel();
    _field.dispose();
    super.dispose();
  }

  /// Looks up the target's title once the slider/field settles for a moment,
  /// ignoring replies to older requests.
  void _updateTargetTitle() {
    _titleDebounce?.cancel();
    if (_target == widget.state.content.orderId) {
      _titleRequest++;
      setState(() => _targetTitle = widget.state.title.name);
      return;
    }
    _titleDebounce = Timer(const Duration(milliseconds: 150), () async {
      final request = ++_titleRequest;
      final db = context.read<ContentViewerCubit>().hadithDbHelper;
      final content = await db.getContentByOrderId(_target);
      final title = await db.getTitleById(content.titleId);
      if (!mounted || request != _titleRequest || title == null) return;
      setState(() => _targetTitle = title.name);
    });
  }

  void _setTarget(int value) {
    setState(() {
      _target = value.clamp(_min, _max);
      _outOfRange = false;
      _field.value = TextEditingValue(
        text: '$_target',
        selection: TextSelection.collapsed(offset: '$_target'.length),
      );
    });
    _updateTargetTitle();
  }

  void _onFieldChanged(String text) {
    final parsed = int.tryParse(text);
    setState(() {
      _outOfRange = parsed == null || parsed < _min || parsed > _max;
      if (!_outOfRange) _target = parsed!;
    });
    if (!_outOfRange) _updateTargetTitle();
  }

  void _go() {
    if (_outOfRange) return;
    context.read<ContentViewerCubit>().goToContent(_target);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            layoutBuilder: (current, previous) => Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [...previous, if (current != null) current],
            ),
            child: Text(
              _targetTitle,
              key: ValueKey(_targetTitle),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            s.contentXofY(_target, _max),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Slider(
            min: _min.toDouble(),
            max: _max.toDouble(),
            divisions: _max > _min ? _max - _min : null,
            value: _target.toDouble(),
            label: '$_target',
            onChanged: (v) => _setTarget(v.round()),
          ),
          Row(
            children: [
              TextButton(onPressed: () => _setTarget(_min), child: Text(s.first)),
              const Spacer(),
              TextButton(onPressed: () => _setTarget(_max), child: Text(s.last)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _field,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.go,
                  textAlign: TextAlign.center,
                  inputFormatters: [_DigitsFormatter()],
                  decoration: InputDecoration(
                    labelText: s.contentNumber,
                    errorText: _outOfRange ? s.outOfRange(_min, _max) : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: _onFieldChanged,
                  onSubmitted: (_) => _go(),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _outOfRange ? null : _go,
                  child: Text(s.goTo),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Keeps only digits and converts Arabic-Indic (٠-٩) and Persian (۰-۹)
/// digits to Latin so [int.tryParse] works with Arabic keyboards.
class _DigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final buffer = StringBuffer();
    for (final c in newValue.text.runes) {
      if (c >= 0x30 && c <= 0x39) {
        buffer.writeCharCode(c);
      } else if (c >= 0x660 && c <= 0x669) {
        buffer.writeCharCode(c - 0x660 + 0x30);
      } else if (c >= 0x6F0 && c <= 0x6F9) {
        buffer.writeCharCode(c - 0x6F0 + 0x30);
      }
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
