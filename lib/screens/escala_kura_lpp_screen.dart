import 'package:flutter/material.dart';
import '../models/escala_kura_lpp.dart';
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
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Albúmina sérica (g/dL)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.albuminaSerica = double.tryParse(v)),
        ),
        const SizedBox(height: 16),
        const Text('Historia clínica (30 días):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Pérdida de peso (%)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.perdidaPesoInvoluntaria = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Ingesta proteica (g/kg/día)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.ingestaProteica = double.tryParse(v)),
        ),
        const SizedBox(height: 16),
        _buildDomainScore('Nutrición', _escala.dominioNutricion, 3),
      ],
    );
  }
  
  Widget _buildPerfusionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Doppler/Vascular (30 días):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'ITB/ABI (ratio)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.indiceTobilloBrazo = double.tryParse(v)),
        ),
        const SizedBox(height: 16),
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
        TextField(
          decoration: const InputDecoration(labelText: 'Cronicidad (meses)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.cronicidadMeses = int.tryParse(v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: '% Granulación'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.porcentajeGranulacion = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: '% Fibrina/esfacelos'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.porcentajeFibrina = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 16),
        _buildDomainScore('Herida', _escala.dominioHerida, 3),
      ],
    );
  }
  
  Widget _buildPressureForm() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Adherencia alivio presión (%)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.adherenciaAlivioPresion = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Frecuencia cambios (horas)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.frecuenciaCambiosPosturales = double.tryParse(v)),
        ),
        const SizedBox(height: 16),
        Text('Braden Movilidad: ${_escala.bradenMovilidad}'),
        Slider(
          value: _escala.bradenMovilidad.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '${_escala.bradenMovilidad}',
          onChanged: (v) => setState(() => _escala.bradenMovilidad = v.toInt()),
        ),
        Text('Braden Humedad: ${_escala.bradenHumedad}'),
        Slider(
          value: _escala.bradenHumedad.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '${_escala.bradenHumedad}',
          onChanged: (v) => setState(() => _escala.bradenHumedad = v.toInt()),
        ),
        const SizedBox(height: 16),
        _buildDomainScore('Presión', _escala.dominioPresion, 3),
      ],
    );
  }
  
  Widget _buildClinicalForm() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'HbA1c (%)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.hba1c = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Hemoglobina (g/dL)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => _escala.hemoglobina = double.tryParse(v)),
        ),
        const SizedBox(height: 12),
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
