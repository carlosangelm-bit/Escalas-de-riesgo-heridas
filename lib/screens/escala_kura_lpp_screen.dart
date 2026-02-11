import 'package:flutter/material.dart';
import '../models/escala_kura_lpp.dart';
import '../widgets/labeled_slider.dart';
import 'escala_kura_result_screen.dart';

class EscalaKuraLppScreen extends StatefulWidget {
  const EscalaKuraLppScreen({super.key});

  @override
  State<EscalaKuraLppScreen> createState() => _EscalaKuraLppScreenState();
}

class _EscalaKuraLppScreenState extends State<EscalaKuraLppScreen> {
  final _formKey = GlobalKey<FormState>();
  final EscalaKuraLpp _escala = EscalaKuraLpp();
  
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  
  int _currentStep = 0;
  
  final List<String> _stepTitles = [
    'Datos del Paciente',
    '1. NUTRICIÓN (0-3)',
    '2. PERFUSIÓN (0-3)',
    '3. HERIDA (0-3)',
    '4. PRESIÓN (0-3)',
    '5. CLÍNICO (0-3)',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }
  
  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_currentStep < 5) {
        setState(() => _currentStep++);
      } else {
        _submitAssessment();
      }
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  void _submitAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscalaKuraResultScreen(
          escala: _escala,
          nombrePaciente: _nombreController.text,
          edad: _edadController.text,
          diagnosis: _diagnosisController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escala Kura+ LPP v2.0'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(theme),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildStepContent(),
                ),
              ),
            ),
            _buildNavigationButtons(theme),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(6, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? theme.colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ['P', 'N', 'Pf', 'H', 'Pr', 'C'][index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted || isActive
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            _stepTitles[_currentStep],
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_currentStep > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Total: ${_escala.puntajeTotal}/15 | ${_escala.categoria}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPatientDataForm();
      case 1:
        return _buildNutritionForm();
      case 2:
        return _buildPerfusionForm();
      case 3:
        return _buildWoundForm();
      case 4:
        return _buildPressureForm();
      case 5:
        return _buildClinicalForm();
      default:
        return const SizedBox();
    }
  }
  
  Widget _buildPatientDataForm() {
    return Column(
      children: [
        TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Paciente *',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _edadController,
          decoration: const InputDecoration(
            labelText: 'Edad *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _diagnosisController,
          decoration: const InputDecoration(
            labelText: 'Diagnóstico Principal',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
  
  Widget _buildNutritionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Laboratorios (últimos 7 días):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        LabValueSlider(
          label: 'Albúmina sérica',
          value: _escala.albuminaSerica ?? 3.5,
          min: 1.0,
          max: 5.0,
          unit: 'g/dL',
          normalMin: 3.5,
          normalMax: 5.0,
          onChanged: (v) => setState(() => _escala.albuminaSerica = v),
          tooltip: 'Normal: 3.5-5.0 g/dL',
        ),
        const SizedBox(height: 20),
        const Text('Historia clínica (30 días):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        PercentageSlider(
          label: 'Pérdida de peso involuntaria',
          value: _escala.perdidaPesoInvoluntaria ?? 0,
          onChanged: (v) => setState(() => _escala.perdidaPesoInvoluntaria = v),
          tooltip: '% peso perdido últimos 30 días',
        ),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'Ingesta proteica',
          value: _escala.ingestaProteica ?? 1.0,
          min: 0.0,
          max: 2.5,
          unit: ' g/kg/día',
          onChanged: (v) => setState(() => _escala.ingestaProteica = v),
          tooltip: 'Recomendado: 1.2-1.5 g/kg/día',
        ),
        const SizedBox(height: 20),
        _buildDomainScore('Nutrición', _escala.dominioNutricion, 3),
      ],
    );
  }
  
  Widget _buildPerfusionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Doppler/Vascular (30 días):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'ITB/ABI (Índice Tobillo-Brazo)',
          value: _escala.indiceTobilloBrazo ?? 1.0,
          min: 0.0,
          max: 1.5,
          onChanged: (v) => setState(() => _escala.indiceTobilloBrazo = v),
          tooltip: 'Normal: 0.9-1.3. <0.9 indica enfermedad arterial',
        ),
        const SizedBox(height: 20),
        const Text('Exploración física:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Llenado capilar'),
          items: ['Normal', 'Leve', 'Moderada', 'Severa'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.llenadoCapilar = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Edema periférico'),
          items: ['0', '+1', '+2', '+3/+4'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.edemaPeriferico = v),
        ),
        const SizedBox(height: 16),
        _buildDomainScore('Perfusión', _escala.dominioPerfusion, 3),
      ],
    );
  }
  
  Widget _buildWoundForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledSlider(
          label: 'Cronicidad de la lesión',
          value: (_escala.cronicidadMeses ?? 0).toDouble(),
          min: 0,
          max: 24,
          divisions: 24,
          unit: ' meses',
          onChanged: (v) => setState(() => _escala.cronicidadMeses = v.round()),
          tooltip: 'Tiempo desde aparición de la lesión',
        ),
        const SizedBox(height: 16),
        PercentageSlider(
          label: 'Tejido de granulación',
          value: _escala.porcentajeGranulacion ?? 0,
          onChanged: (v) => setState(() => _escala.porcentajeGranulacion = v),
          tooltip: 'Porcentaje de tejido de granulación saludable',
        ),
        const SizedBox(height: 16),
        PercentageSlider(
          label: 'Fibrina/esfacelos',
          value: _escala.porcentajeFibrina ?? 0,
          onChanged: (v) => setState(() => _escala.porcentajeFibrina = v),
          tooltip: 'Porcentaje de tejido desvitalizado',
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Necrosis presente'),
          value: _escala.necrosisPresente,
          onChanged: (v) => setState(() => _escala.necrosisPresente = v!),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Infección crónica'),
          items: ['No', 'Biopelícula', 'Celulitis', 'Osteomielitis'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.infeccionCronica = v),
        ),
        const SizedBox(height: 20),
        _buildDomainScore('Herida', _escala.dominioHerida, 3),
      ],
    );
  }
  
  Widget _buildPressureForm() {
    return Column(
      children: [
        PercentageSlider(
          label: 'Adherencia al alivio de presión',
          value: _escala.adherenciaAlivioPresion ?? 80,
          onChanged: (v) => setState(() => _escala.adherenciaAlivioPresion = v),
          tooltip: 'Cumplimiento del plan de alivio de presión',
        ),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'Frecuencia cambios posturales',
          value: _escala.frecuenciaCambiosPosturales ?? 2,
          min: 0.5,
          max: 6,
          unit: ' horas',
          divisions: 11, // Incrementos de 0.5
          onChanged: (v) => setState(() => _escala.frecuenciaCambiosPosturales = v),
          tooltip: 'Cada cuántas horas se realizan cambios',
        ),
        const SizedBox(height: 20),
        const Text('Braden Movilidad:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Valor: ${_escala.bradenMovilidad}', style: TextStyle(color: Colors.grey[700])),
        Slider(
          value: _escala.bradenMovilidad.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '${_escala.bradenMovilidad}',
          onChanged: (v) => setState(() => _escala.bradenMovilidad = v.round()),
        ),
        const SizedBox(height: 12),
        const Text('Braden Humedad:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Valor: ${_escala.bradenHumedad}', style: TextStyle(color: Colors.grey[700])),
        Slider(
          value: _escala.bradenHumedad.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '${_escala.bradenHumedad}',
          onChanged: (v) => setState(() => _escala.bradenHumedad = v.round()),
        ),
        const SizedBox(height: 20),
        _buildDomainScore('Presión', _escala.dominioPresion, 3),
      ],
    );
  }
  
  Widget _buildClinicalForm() {
    return Column(
      children: [
        LabValueSlider(
          label: 'HbA1c (Hemoglobina glucosilada)',
          value: _escala.hba1c ?? 5.5,
          min: 4.0,
          max: 14.0,
          unit: '%',
          normalMin: 4.0,
          normalMax: 5.7,
          onChanged: (v) => setState(() => _escala.hba1c = v),
          tooltip: 'Normal: <5.7%. Pre-diabetes: 5.7-6.4%. Diabetes: ≥6.5%',
        ),
        const SizedBox(height: 16),
        LabValueSlider(
          label: 'Hemoglobina',
          value: _escala.hemoglobina ?? 13.0,
          min: 6.0,
          max: 18.0,
          unit: 'g/dL',
          normalMin: 12.0,
          normalMax: 16.0,
          onChanged: (v) => setState(() => _escala.hemoglobina = v),
          tooltip: 'Normal: 12-16 g/dL. Anemia: <12',
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Antecedentes LPP'),
          items: ['No', 'Estadio III', 'Estadio IV', 'Ambos'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.antecedentesLpp = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Toxicomanías'),
          items: ['No', 'Alcoholismo', 'Tabaquismo', 'Ambas'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.toxicomanias = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Comorbilidades'),
          items: ['No', 'Impacto menor', 'Impacto moderado', 'Alto impacto'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.comorbilidades = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Función renal'),
          items: ['Normal', 'ERC G1', 'ERC G2-G3', 'ERC G3a-G4'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _escala.funcionRenal = v),
        ),
        const SizedBox(height: 16),
        _buildDomainScore('Clínico', _escala.dominioClinico, 3),
      ],
    );
  }
  
  Widget _buildDomainScore(String label, int score, int max) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$score / $max', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
        ],
      ),
    );
  }
  
  Widget _buildNavigationButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Anterior'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep < 5 ? 'Siguiente' : 'Ver Resultados'),
            ),
          ),
        ],
      ),
    );
  }
}
