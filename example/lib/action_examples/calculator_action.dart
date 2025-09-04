import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Calculator actions demonstrating various mathematical operations
class CalculatorActions {
  /// Basic arithmetic calculator
  static AiAction basicCalculator() {
    return AiAction(
      name: 'calculate',
      description:
          'Perform basic mathematical calculations (add, subtract, multiply, divide)',
      parameters: [
        ActionParameter.number(
          name: 'a',
          description: 'First number',
          required: true,
        ),
        ActionParameter.number(
          name: 'b',
          description: 'Second number',
          required: true,
        ),
        ActionParameter.string(
          name: 'operation',
          description: 'Mathematical operation to perform',
          required: true,
          enumValues: ['add', 'subtract', 'multiply', 'divide'],
        ),
      ],
      handler: (parameters) async {
        final a = parameters['a'] as num;
        final b = parameters['b'] as num;
        final operation = parameters['operation'] as String;

        // Simulate calculation delay
        await Future.delayed(const Duration(milliseconds: 500));

        double result;
        String operationSymbol;

        switch (operation) {
          case 'add':
            result = (a + b).toDouble();
            operationSymbol = '+';
            break;
          case 'subtract':
            result = (a - b).toDouble();
            operationSymbol = '-';
            break;
          case 'multiply':
            result = (a * b).toDouble();
            operationSymbol = '×';
            break;
          case 'divide':
            if (b == 0) {
              return ActionResult.createFailure('Cannot divide by zero');
            }
            result = a / b;
            operationSymbol = '÷';
            break;
          default:
            return ActionResult.createFailure('Unknown operation: $operation');
        }

        return ActionResult.createSuccess({
          'result': result,
          'equation': '$a $operationSymbol $b = $result',
          'operands': {'a': a, 'b': b},
          'operation': operation,
          'operationSymbol': operationSymbol,
        });
      },
      render: (context, status, parameters, {result, error}) {
        return _buildCalculatorResult(
          context,
          'Basic Calculator',
          Icons.calculate,
          status,
          parameters,
          result: result,
          error: error,
        );
      },
    );
  }

  /// Advanced mathematical functions
  static AiAction advancedMath() {
    return AiAction(
      name: 'advanced_math',
      description:
          'Perform advanced mathematical calculations (sin, cos, log, sqrt, power)',
      parameters: [
        ActionParameter.number(
          name: 'value',
          description: 'Input value for the mathematical function',
          required: true,
        ),
        ActionParameter.string(
          name: 'function',
          description: 'Mathematical function to apply',
          required: true,
          enumValues: [
            'sin',
            'cos',
            'tan',
            'log',
            'ln',
            'sqrt',
            'abs',
            'round',
            'floor',
            'ceil'
          ],
        ),
        ActionParameter.number(
          name: 'power',
          description: 'Power to raise the value to (only for power function)',
          required: false,
        ),
      ],
      handler: (parameters) async {
        final value = parameters['value'] as num;
        final function = parameters['function'] as String;
        final power = parameters['power'] as num?;

        await Future.delayed(const Duration(milliseconds: 300));

        double result;
        String expression;

        try {
          switch (function) {
            case 'sin':
              result = math.sin(value.toDouble());
              expression = 'sin($value)';
              break;
            case 'cos':
              result = math.cos(value.toDouble());
              expression = 'cos($value)';
              break;
            case 'tan':
              result = math.tan(value.toDouble());
              expression = 'tan($value)';
              break;
            case 'log':
              if (value <= 0) {
                return ActionResult.createFailure(
                    'Logarithm undefined for non-positive numbers');
              }
              result = math.log(value.toDouble()) / math.log(10);
              expression = 'log₁₀($value)';
              break;
            case 'ln':
              if (value <= 0) {
                return ActionResult.createFailure(
                    'Natural logarithm undefined for non-positive numbers');
              }
              result = math.log(value.toDouble());
              expression = 'ln($value)';
              break;
            case 'sqrt':
              if (value < 0) {
                return ActionResult.createFailure(
                    'Square root undefined for negative numbers');
              }
              result = math.sqrt(value.toDouble());
              expression = '√$value';
              break;
            case 'abs':
              result = value.abs().toDouble();
              expression = '|$value|';
              break;
            case 'round':
              result = value.round().toDouble();
              expression = 'round($value)';
              break;
            case 'floor':
              result = value.floor().toDouble();
              expression = 'floor($value)';
              break;
            case 'ceil':
              result = value.ceil().toDouble();
              expression = 'ceil($value)';
              break;
            case 'power':
              if (power == null) {
                return ActionResult.createFailure(
                    'Power parameter required for power function');
              }
              result = math.pow(value.toDouble(), power.toDouble()).toDouble();
              expression = '$value^$power';
              break;
            default:
              return ActionResult.createFailure('Unknown function: $function');
          }

          return ActionResult.createSuccess({
            'result': result,
            'expression': expression,
            'input': value,
            'function': function,
            if (power != null) 'power': power,
          });
        } catch (e) {
          return ActionResult.createFailure(
              'Calculation error: ${e.toString()}');
        }
      },
      render: (context, status, parameters, {result, error}) {
        return _buildCalculatorResult(
          context,
          'Advanced Math',
          Icons.functions,
          status,
          parameters,
          result: result,
          error: error,
        );
      },
    );
  }

  /// Unit converter
  static AiAction unitConverter() {
    return AiAction(
      name: 'convert_units',
      description: 'Convert between different units of measurement',
      parameters: [
        ActionParameter.number(
          name: 'value',
          description: 'Value to convert',
          required: true,
        ),
        ActionParameter.string(
          name: 'from_unit',
          description: 'Unit to convert from',
          required: true,
          enumValues: [
            'celsius',
            'fahrenheit',
            'kelvin',
            'meters',
            'feet',
            'inches',
            'km',
            'miles',
            'kg',
            'pounds'
          ],
        ),
        ActionParameter.string(
          name: 'to_unit',
          description: 'Unit to convert to',
          required: true,
          enumValues: [
            'celsius',
            'fahrenheit',
            'kelvin',
            'meters',
            'feet',
            'inches',
            'km',
            'miles',
            'kg',
            'pounds'
          ],
        ),
      ],
      handler: (parameters) async {
        final value = parameters['value'] as num;
        final fromUnit = parameters['from_unit'] as String;
        final toUnit = parameters['to_unit'] as String;

        await Future.delayed(const Duration(milliseconds: 400));

        try {
          final result = _convertUnits(value, fromUnit, toUnit);

          return ActionResult.createSuccess({
            'result': result,
            'conversion': '$value $fromUnit = $result $toUnit',
            'originalValue': value,
            'fromUnit': fromUnit,
            'toUnit': toUnit,
          });
        } catch (e) {
          return ActionResult.createFailure(
              'Conversion error: ${e.toString()}');
        }
      },
      render: (context, status, parameters, {result, error}) {
        return _buildCalculatorResult(
          context,
          'Unit Converter',
          Icons.swap_horiz,
          status,
          parameters,
          result: result,
          error: error,
        );
      },
      confirmationConfig: const ActionConfirmationConfig(
        title: 'Convert Units',
        message: 'This will perform a unit conversion calculation.',
        required: false,
      ),
    );
  }

  static Widget _buildCalculatorResult(
    BuildContext context,
    String title,
    IconData icon,
    ActionStatus status,
    Map<String, dynamic> parameters, {
    ActionResult? result,
    String? error,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (status == ActionStatus.executing) ...[
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Calculating...'),
                ],
              ),
            ] else if (status == ActionStatus.completed &&
                result?.data != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (result!.data.containsKey('equation')) ...[
                      Text(
                        result.data['equation'],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (result.data.containsKey('expression')) ...[
                      Text(
                        '${result.data['expression']} = ${result.data['result']}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (result.data.containsKey('conversion')) ...[
                      Text(
                        result.data['conversion'],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Result: ${result.data['result']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (status == ActionStatus.failed) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Calculation failed: ${error ?? 'Unknown error'}',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static double _convertUnits(num value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value.toDouble();

    // Temperature conversions
    if (_isTemperatureUnit(fromUnit) && _isTemperatureUnit(toUnit)) {
      return _convertTemperature(value, fromUnit, toUnit);
    }

    // Length conversions
    if (_isLengthUnit(fromUnit) && _isLengthUnit(toUnit)) {
      return _convertLength(value, fromUnit, toUnit);
    }

    // Weight conversions
    if (_isWeightUnit(fromUnit) && _isWeightUnit(toUnit)) {
      return _convertWeight(value, fromUnit, toUnit);
    }

    throw Exception(
        'Cannot convert between $fromUnit and $toUnit - incompatible unit types');
  }

  static bool _isTemperatureUnit(String unit) =>
      ['celsius', 'fahrenheit', 'kelvin'].contains(unit);

  static bool _isLengthUnit(String unit) =>
      ['meters', 'feet', 'inches', 'km', 'miles'].contains(unit);

  static bool _isWeightUnit(String unit) => ['kg', 'pounds'].contains(unit);

  static double _convertTemperature(num value, String from, String to) {
    double celsius;

    // Convert to Celsius first
    switch (from) {
      case 'celsius':
        celsius = value.toDouble();
        break;
      case 'fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        throw Exception('Unknown temperature unit: $from');
    }

    // Convert from Celsius to target
    switch (to) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        throw Exception('Unknown temperature unit: $to');
    }
  }

  static double _convertLength(num value, String from, String to) {
    double meters;

    // Convert to meters first
    switch (from) {
      case 'meters':
        meters = value.toDouble();
        break;
      case 'feet':
        meters = value * 0.3048;
        break;
      case 'inches':
        meters = value * 0.0254;
        break;
      case 'km':
        meters = value * 1000;
        break;
      case 'miles':
        meters = value * 1609.344;
        break;
      default:
        throw Exception('Unknown length unit: $from');
    }

    // Convert from meters to target
    switch (to) {
      case 'meters':
        return meters;
      case 'feet':
        return meters / 0.3048;
      case 'inches':
        return meters / 0.0254;
      case 'km':
        return meters / 1000;
      case 'miles':
        return meters / 1609.344;
      default:
        throw Exception('Unknown length unit: $to');
    }
  }

  static double _convertWeight(num value, String from, String to) {
    double kg;

    // Convert to kg first
    switch (from) {
      case 'kg':
        kg = value.toDouble();
        break;
      case 'pounds':
        kg = value * 0.453592;
        break;
      default:
        throw Exception('Unknown weight unit: $from');
    }

    // Convert from kg to target
    switch (to) {
      case 'kg':
        return kg;
      case 'pounds':
        return kg / 0.453592;
      default:
        throw Exception('Unknown weight unit: $to');
    }
  }
}
