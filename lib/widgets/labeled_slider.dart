import 'package:flutter/material.dart';

/// Widget de Slider personalizado con etiqueta y valor visible
class LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String? unit;
  final bool showValue;
  final Color? activeColor;
  final String? tooltip;
  
  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.unit,
    this.showValue = true,
    this.activeColor,
    this.tooltip,
  });
  
  /// Obtener color según el valor (semáforo)
  Color _getColorForValue() {
    if (activeColor != null) return activeColor!;
    
    final percentage = (value - min) / (max - min);
    if (percentage <= 0.33) {
      return Colors.green;
    } else if (percentage <= 0.66) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  String _formatValue() {
    if (divisions != null) {
      return value.toStringAsFixed(0);
    } else {
      return value.toStringAsFixed(1);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (tooltip != null) ...[
                    const SizedBox(width: 4),
                    Tooltip(
                      message: tooltip!,
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showValue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getColorForValue().withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getColorForValue().withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${_formatValue()}${unit ?? ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getColorForValue(),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              min.toStringAsFixed(divisions != null ? 0 : 1),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _getColorForValue(),
                  inactiveTrackColor: _getColorForValue().withValues(alpha: 0.2),
                  thumbColor: _getColorForValue(),
                  overlayColor: _getColorForValue().withValues(alpha: 0.2),
                  valueIndicatorColor: _getColorForValue(),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: '${_formatValue()}${unit ?? ''}',
                  onChanged: onChanged,
                ),
              ),
            ),
            Text(
              max.toStringAsFixed(divisions != null ? 0 : 1),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget de Slider para porcentajes (0-100%)
class PercentageSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String? tooltip;
  
  const PercentageSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.tooltip,
  });
  
  @override
  Widget build(BuildContext context) {
    return LabeledSlider(
      label: label,
      value: value,
      min: 0,
      max: 100,
      divisions: 20, // Incrementos de 5%
      unit: '%',
      onChanged: onChanged,
      tooltip: tooltip,
    );
  }
}

/// Widget de Slider para valores de laboratorio
class LabValueSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;
  final double? normalMin;
  final double? normalMax;
  final String? tooltip;
  
  const LabValueSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    this.normalMin,
    this.normalMax,
    this.tooltip,
  });
  
  Color _getColorForLabValue() {
    if (normalMin != null && normalMax != null) {
      if (value >= normalMin! && value <= normalMax!) {
        return Colors.green;
      } else if (value < normalMin! * 0.8 || value > normalMax! * 1.2) {
        return Colors.red;
      } else {
        return Colors.orange;
      }
    }
    return Colors.blue;
  }
  
  @override
  Widget build(BuildContext context) {
    return LabeledSlider(
      label: label,
      value: value,
      min: min,
      max: max,
      unit: ' $unit',
      onChanged: onChanged,
      activeColor: _getColorForLabValue(),
      tooltip: tooltip,
    );
  }
}
