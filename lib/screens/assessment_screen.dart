import 'package:flutter/material.dart';
import '../models/pressure_injury_scales.dart';
import '../models/infection_scales.dart';
import '../utils/app_theme.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final String assessmentType;
  final String scaleId;
  final Map<String, String> eligibilityAnswers;

  const AssessmentScreen({
    super.key,
    required this.assessmentType,
    required this.scaleId,
    required this.eligibilityAnswers,
  });

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final Map<String, dynamic> _answers = {};
  final _patientNameController = TextEditingController();
  final _patientIdController = TextEditingController();
  
  String get scaleName {
    final scales = {
      'braden': 'Escala de Braden',
      'evaruci': 'Escala EVARUCI',
      'norton': 'Escala de Norton',
      'nnis': 'Índice NNIS',
      'senic': 'Índice SENIC',
      'rac': 'Escala RAC',
      'cpis': 'Escala CPIS',
    };
    return scales[widget.scaleId] ?? widget.scaleId;
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientIdController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    if (_patientNameController.text.isEmpty || _patientIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete los datos del paciente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calcular puntuación según la escala
    dynamic totalScore;
    String riskLevel;

    switch (widget.scaleId) {
      case 'braden':
        totalScore = _calculateBradenScore();
        riskLevel = BradenScale.interpretRisk(totalScore);
        break;
      case 'evaruci':
        totalScore = _calculateEVARUCIScore();
        riskLevel = EVARUCIScale.interpretRisk(totalScore);
        break;
      case 'norton':
        totalScore = _calculateNortonScore();
        riskLevel = NortonScale.interpretRisk(totalScore);
        break;
      case 'nnis':
        totalScore = _calculateNNISScore();
        riskLevel = NNISScale.interpretRisk(totalScore);
        break;
      case 'senic':
        totalScore = _calculateSENICScore();
        riskLevel = SENICScale.interpretRisk(totalScore);
        break;
      case 'rac':
        totalScore = _calculateRACScore();
        riskLevel = RACScale.interpretRisk(totalScore);
        break;
      case 'cpis':
        totalScore = _calculateCPISScore();
        riskLevel = CPISScale.interpretRisk(totalScore);
        break;
      default:
        totalScore = 0;
        riskLevel = 'desconocido';
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          assessmentType: widget.assessmentType,
          scaleId: widget.scaleId,
          scaleName: scaleName,
          patientName: _patientNameController.text,
          patientId: _patientIdController.text,
          totalScore: totalScore,
          riskLevel: riskLevel,
          answers: _answers,
        ),
      ),
    );
  }

  int _calculateBradenScore() {
    int total = 0;
    for (var answer in _answers.values) {
      if (answer is int) total += answer;
    }
    return total;
  }

  double _calculateEVARUCIScore() {
    double total = 0;
    for (var answer in _answers.values) {
      if (answer is double) {
        total += answer;
      } else if (answer is int) {
        total += answer.toDouble();
      }
    }
    return total;
  }

  int _calculateNortonScore() {
    int total = 0;
    for (var answer in _answers.values) {
      if (answer is int) total += answer;
    }
    return total;
  }

  int _calculateNNISScore() {
    int total = 0;
    for (var answer in _answers.values) {
      if (answer is int) total += answer;
    }
    return total;
  }

  int _calculateSENICScore() {
    int total = 0;
    for (var answer in _answers.values) {
      if (answer is int) total += answer;
    }
    return total;
  }

  int _calculateRACScore() {
    // Simplificado: cada factor presente suma puntos
    int total = 0;
    for (var answer in _answers.values) {
      if (answer == true) total += 3; // Estimación simplificada
    }
    return total;
  }

  int _calculateCPISScore() {
    int total = 0;
    for (var answer in _answers.values) {
      if (answer is int) total += answer;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scaleName),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: widget.assessmentType == 'pressure_injury'
                ? AppTheme.pressureInjuryGradient
                : AppTheme.surgicalInfectionGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Datos del paciente
          const Text(
            'Datos del Paciente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _patientNameController,
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _patientIdController,
            decoration: InputDecoration(
              labelText: 'ID del paciente',
              prefixIcon: const Icon(Icons.badge),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Parámetros de evaluación
          const Text(
            'Evaluación',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ..._buildScaleParameters(),

          const SizedBox(height: 32),

          // Botón calcular
          ElevatedButton(
            onPressed: _calculateAndNavigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.assessmentType == 'pressure_injury'
                  ? AppTheme.pressureStart
                  : AppTheme.infectionStart,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Calcular Riesgo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScaleParameters() {
    switch (widget.scaleId) {
      case 'braden':
        return _buildBradenParameters();
      case 'evaruci':
        return _buildEVARUCIParameters();
      case 'norton':
        return _buildNortonParameters();
      case 'nnis':
        return _buildNNISParameters();
      case 'senic':
        return _buildSENICParameters();
      case 'rac':
        return _buildRACParameters();
      case 'cpis':
        return _buildCPISParameters();
      default:
        return [const Text('Escala no implementada')];
    }
  }

  List<Widget> _buildBradenParameters() {
    final parameters = BradenScale.getParameters();
    return parameters.map((param) {
      return _buildParameterCard(
        title: param.name,
        description: param.description,
        options: param.options.map((opt) => {
          'text': opt.text,
          'value': opt.points,
        }).toList(),
        parameterId: param.id,
      );
    }).toList();
  }

  List<Widget> _buildEVARUCIParameters() {
    final parameters = EVARUCIScale.getParameters();
    final additionalFactors = EVARUCIScale.getAdditionalFactors();
    
    List<Widget> widgets = parameters.map((param) {
      return _buildParameterCard(
        title: param.name,
        description: param.description,
        options: param.options.map((opt) => {
          'text': opt.text,
          'value': opt.points,
        }).toList(),
        parameterId: param.id,
      );
    }).toList();

    // Factores adicionales
    widgets.add(const SizedBox(height: 16));
    widgets.add(const Text(
      'Factores Adicionales (0.5 puntos cada uno)',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ));
    widgets.add(const SizedBox(height: 12));

    for (var factor in additionalFactors) {
      widgets.add(_buildCheckboxFactor(
        factor.id,
        factor.description,
        factor.points,
      ));
    }

    return widgets;
  }

  List<Widget> _buildNortonParameters() {
    final parameters = NortonScale.getParameters();
    return parameters.map((param) {
      return _buildParameterCard(
        title: param.name,
        description: param.description,
        options: param.options.map((opt) => {
          'text': opt.text,
          'value': opt.points,
        }).toList(),
        parameterId: param.id,
      );
    }).toList();
  }

  List<Widget> _buildNNISParameters() {
    final parameters = NNISScale.getParameters();
    List<Widget> widgets = [];
    
    for (var param in parameters) {
      widgets.add(_buildNNISParameterCard(
        parameter: param,
        parameterId: param.id,
      ));
    }
    
    return widgets;
  }

  List<Widget> _buildSENICParameters() {
    final parameters = SENICScale.getParameters();
    return parameters.map((param) {
      return _buildParameterCard(
        title: param.name,
        description: param.description,
        options: param.options.map((opt) => {
          'text': opt.text,
          'value': opt.points,
        }).toList(),
        parameterId: param.id,
      );
    }).toList();
  }

  List<Widget> _buildRACParameters() {
    final factors = RACScale.getMainFactors();
    List<Widget> widgets = [];

    for (var factor in factors) {
      widgets.add(_buildCheckboxFactor(
        factor.id,
        '${factor.name}: ${factor.description}',
        3.0, // Puntos simplificados
      ));
    }

    return widgets;
  }

  List<Widget> _buildCPISParameters() {
    final parameters = CPISScale.getParameters();
    return parameters.map((param) {
      return _buildParameterCard(
        title: param.name,
        description: param.description,
        options: param.options.map((opt) => {
          'text': opt.text,
          'value': opt.points,
        }).toList(),
        parameterId: param.id,
      );
    }).toList();
  }

  Widget _buildParameterCard({
    required String title,
    required String description,
    required List<Map<String, dynamic>> options,
    required String parameterId,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((option) {
              final isSelected = _answers[parameterId] == option['value'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _answers[parameterId] = option['value'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (widget.assessmentType == 'pressure_injury'
                            ? AppTheme.pressureStart.withOpacity( 0.1)
                            : AppTheme.infectionStart.withOpacity( 0.1))
                        : Colors.grey.withOpacity( 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? (widget.assessmentType == 'pressure_injury'
                              ? AppTheme.pressureStart
                              : AppTheme.infectionStart)
                          : Colors.grey.withOpacity( 0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected
                            ? (widget.assessmentType == 'pressure_injury'
                                ? AppTheme.pressureStart
                                : AppTheme.infectionStart)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option['text'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '${option['value']} pts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? (widget.assessmentType == 'pressure_injury'
                                  ? AppTheme.pressureStart
                                  : AppTheme.infectionStart)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxFactor(String id, String description, double points) {
    // Verificar si el factor está marcado comprobando si existe en _answers
    final isChecked = _answers.containsKey(id) && _answers[id] != null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _answers[id] = points;
            } else {
              _answers.remove(id);
            }
          });
        },
        title: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '+$points puntos',
          style: TextStyle(
            color: isChecked ? AppTheme.infectionStart : Colors.black54,
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppTheme.infectionStart,
        checkColor: Colors.white,
        dense: true,
      ),
    );
  }
  
  Widget _buildNNISParameterCard({
    required NNISParameter parameter,
    required String parameterId,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parameter.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        parameter.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (parameter.helpText != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.help_outline, color: AppTheme.infectionStart),
                    onPressed: () {
                      _showNNISHelp(parameter);
                    },
                    tooltip: 'Ver guía detallada',
                  ),
                ],
              ],
            ),
            
            // Botones especiales para ASA y Duración
            if (parameterId == 'asa_classification') ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _showASACompleteGuide();
                },
                icon: const Icon(Icons.book),
                label: const Text('Ver Guía ASA Completa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.infectionStart,
                ),
              ),
            ],
            
            if (parameterId == 'surgery_duration') ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _showSurgeryDurationTable();
                },
                icon: const Icon(Icons.access_time),
                label: const Text('Ver Tabla de Tiempos por Procedimiento'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.infectionStart,
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            ...parameter.options.map((option) {
              final isSelected = _answers[parameterId] == option.points;
              return InkWell(
                onTap: () {
                  setState(() {
                    _answers[parameterId] = option.points;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.infectionStart.withOpacity( 0.1)
                        : Colors.grey.withOpacity( 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.infectionStart
                          : Colors.grey.withOpacity( 0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppTheme.infectionStart : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.text,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (option.explanation.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                option.explanation,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  void _showNNISHelp(NNISParameter parameter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(parameter.name),
        content: SingleChildScrollView(
          child: Text(
            parameter.helpText ?? '',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
  
  void _showASACompleteGuide() {
    final guide = NNISScale.getASADetailedGuide();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.surgicalInfectionGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_information, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Guía Completa ASA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    guide,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSurgeryDurationTable() {
    final table = NNISScale.getSurgeryDurationReference();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.surgicalInfectionGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tiempos Quirúrgicos (Percentil 75)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Procedimientos Quirúrgicos Comunes:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...table.entries.map((entry) {
                        if (entry.key == 'Nota') {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity( 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.withOpacity( 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.infectionStart.withOpacity( 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.infectionStart,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
