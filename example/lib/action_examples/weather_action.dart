import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Example weather action demonstrating AiAction usage
class WeatherActions {
  /// Get current weather for a location
  static AiAction getCurrentWeather() {
    return AiAction(
      name: 'get_current_weather',
      description: 'Get the current weather conditions for a specified location',
      parameters: [
        ActionParameter.string(
          name: 'location',
          description: 'The city and state/country (e.g., "San Francisco, CA")',
          required: true,
          validator: (value) => value != null && value.toString().trim().isNotEmpty,
        ),
        ActionParameter.string(
          name: 'units',
          description: 'Temperature units (celsius or fahrenheit)',
          required: false,
          defaultValue: 'celsius',
          enumValues: ['celsius', 'fahrenheit'],
        ),
      ],
      handler: (parameters) async {
        final location = parameters['location'] as String;
        final units = parameters['units'] as String? ?? 'celsius';

        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 2));

        // Mock weather data
        final weatherData = {
          'location': location,
          'temperature': units == 'celsius' ? 22 : 72,
          'units': units,
          'condition': 'Partly cloudy',
          'humidity': 65,
          'windSpeed': 12,
          'timestamp': DateTime.now().toIso8601String(),
        };

        return ActionResult.createSuccess(weatherData);
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Weather Information',
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
                      Text('Fetching weather data...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  _buildWeatherDisplay(context, result!.data as Map<String, dynamic>),
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
                            'Failed to get weather: ${error ?? 'Unknown error'}',
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
      },
      confirmationConfig: const ActionConfirmationConfig(
        title: 'Get Weather Information',
        message: 'This will fetch current weather data for the specified location.',
        required: false, // No confirmation needed for weather
      ),
    );
  }

  /// Set weather alerts for a location
  static AiAction setWeatherAlert() {
    return AiAction(
      name: 'set_weather_alert',
      description: 'Set up weather alerts for a specific location and conditions',
      parameters: [
        ActionParameter.string(
          name: 'location',
          description: 'The city and state/country for weather alerts',
          required: true,
        ),
        ActionParameter.array(
          name: 'conditions',
          description: 'Weather conditions to alert for (rain, snow, storm, etc.)',
          required: true,
          validator: (value) => value is List && value.isNotEmpty,
        ),
        ActionParameter.number(
          name: 'temperature_threshold',
          description: 'Temperature threshold for alerts (in Celsius)',
          required: false,
        ),
        ActionParameter.boolean(
          name: 'email_notifications',
          description: 'Send email notifications',
          required: false,
          defaultValue: true,
        ),
      ],
      handler: (parameters) async {
        final location = parameters['location'] as String;
        final conditions = parameters['conditions'] as List;
        final tempThreshold = parameters['temperature_threshold'] as num?;
        final emailNotifications = parameters['email_notifications'] as bool? ?? true;

        // Simulate setting up alerts
        await Future.delayed(const Duration(seconds: 1));

        final alertId = 'alert_${DateTime.now().millisecondsSinceEpoch}';
        
        return ActionResult.createSuccess({
          'alertId': alertId,
          'location': location,
          'conditions': conditions,
          'temperatureThreshold': tempThreshold,
          'emailNotifications': emailNotifications,
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
        });
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Weather Alert Setup',
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
                      Text('Setting up weather alert...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Weather alert created successfully!',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Alert ID: ${result!.data['alertId']}'),
                        Text('Location: ${result.data['location']}'),
                        Text('Conditions: ${result.data['conditions'].join(', ')}'),
                        if (result.data['temperatureThreshold'] != null)
                          Text('Temperature threshold: ${result.data['temperatureThreshold']}°C'),
                        Text('Email notifications: ${result.data['emailNotifications'] ? 'Enabled' : 'Disabled'}'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      confirmationConfig: const ActionConfirmationConfig(
        title: 'Create Weather Alert',
        message: 'This will create a new weather alert that may send you notifications.',
        required: true, // Confirmation required for alert setup
      ),
    );
  }

  static Widget _buildWeatherDisplay(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final temp = data['temperature'];
    final units = data['units'];
    final unitSymbol = units == 'celsius' ? '°C' : '°F';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['location'],
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temp$unitSymbol',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['condition'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Humidity: ${data['humidity']}%'),
                    Text('Wind: ${data['windSpeed']} km/h'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: ${DateTime.parse(data['timestamp']).toLocal().toString().split('.')[0]}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }
}