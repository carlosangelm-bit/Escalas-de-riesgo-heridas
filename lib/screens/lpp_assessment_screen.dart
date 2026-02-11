import 'package:flutter/material.dart';
import '../models/lpp_criteria.dart';
import '../models/assessment_result.dart';
import 'result_screen.dart';

class LppAssessmentScreen extends StatefulWidget {
  const LppAssessmentScreen({super.key});

  @override
  State<LppAssessmentScreen> createState() => _LppAssessmentScreenState();
}

class _LppAssessmentScreenState extends State<LppAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final LppCriteria _criteria = LppCriteria();
  
  // Controladores para datos del paciente
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  void _submitAssessment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final capacity = _criteria.evaluateHealingCapacity();
      final treatment = _criteria.getTreatment(capacity);
      
      HealingCapacity capacityEnum;
      switch (capacity) {
        case 'Curable':
          capacityEnum = HealingCapacity.curable;
          break;
        case 'Mantenimiento':
          capacityEnum = HealingCapacity.mantenimiento;
          break;
        default:
          capacityEnum = HealingCapacity.noCurable;
      }
      
      final result = AssessmentResult(
        patientName: _nameController.text,
        patientAge: _ageController.text,
        weight: _weightController.text,
        height: _heightController.text,
        diagnosis: _diagnosisController.text,
        assessmentDate: DateTime.now(),
        assessmentType: 'LPP',
        capacity: capacityEnum,
        treatment: treatment,
        criteria: _criteria.toJson(),
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación LPP'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              _submitAssessment();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            Step(
              title: const Text('Datos del Paciente'),
              isActive: _currentStep >= 0,
              content: _buildPatientDataStep(),
            ),
            Step(
              title: const Text('Comorbilidades'),
              isActive: _currentStep >= 1,
              content: _buildComorbiditiesStep(),
            ),
            Step(
              title: const Text('Estado Nutricional'),
              isActive: _currentStep >= 2,
              content: _buildNutritionalStatusStep(),
            ),
            Step(
              title: const Text('Factores Intrínsecos'),
              isActive: _currentStep >= 3,
              content: _buildIntrinsicFactorsStep(),
            ),
            Step(
              title: const Text('Valoración de Herida'),
              isActive: _currentStep >= 4,
              content: _buildWoundAssessmentStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDataStep() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Paciente',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Talla (cm)',
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _diagnosisController,
          decoration: const InputDecoration(
            labelText: 'Diagnóstico',
            prefixIcon: Icon(Icons.medical_services),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el diagnóstico';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildComorbiditiesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seleccione las comorbilidades presentes:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Hipertensión arterial controlada'),
          value: _criteria.hipertensionControlada,
          onChanged: (value) {
            setState(() => _criteria.hipertensionControlada = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Diabetes Mellitus controlada'),
          value: _criteria.diabetesControlada,
          onChanged: (value) {
            setState(() => _criteria.diabetesControlada = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Insuficiencia cardíaca'),
          value: _criteria.insuficienciaCardiaca,
          onChanged: (value) {
            setState(() => _criteria.insuficienciaCardiaca = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Enfermedad Renal G1'),
          value: _criteria.enfermedadRenalG1,
          onChanged: (value) {
            setState(() => _criteria.enfermedadRenalG1 = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Enfermedad Renal G2 y G3'),
          value: _criteria.enfermedadRenalG2G3,
          onChanged: (value) {
            setState(() => _criteria.enfermedadRenalG2G3 = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Enfermedad Renal G3a y G4'),
          value: _criteria.enfermedadRenalG3aG4,
          onChanged: (value) {
            setState(() => _criteria.enfermedadRenalG3aG4 = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Inmunodepresión'),
          value: _criteria.inmunodepresion,
          onChanged: (value) {
            setState(() => _criteria.inmunodepresion = value ?? false);
          },
        ),
      ],
    );
  }

  Widget _buildNutritionalStatusStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingrese los valores de laboratorio:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Albúmina (%)',
            helperText: 'Normal: ≥3.5%',
            prefixIcon: Icon(Icons.science),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.albumina = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Hemoglobina (g/dL)',
            helperText: 'Normal: 13.8-18.5 g/dL',
            prefixIcon: Icon(Icons.science),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.hemoglobina = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Proteínas totales (g/dL)',
            helperText: 'Normal: 5.70-8.20 g/dL',
            prefixIcon: Icon(Icons.science),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.proteinasTotales = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Hematocrito (%)',
            helperText: 'Normal: 35.4-49.4%',
            prefixIcon: Icon(Icons.science),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.hematocrito = double.tryParse(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildIntrinsicFactorsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Factores del paciente:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Escala de Braden (puntos)',
            helperText: 'Rango: 6-23 puntos',
            prefixIcon: Icon(Icons.assessment),
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.bradenScore = int.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _criteria.movilidad,
          decoration: const InputDecoration(
            labelText: 'Movilidad',
            prefixIcon: Icon(Icons.directions_walk),
          ),
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normal')),
            DropdownMenuItem(value: 'limitada', child: Text('Limitada')),
            DropdownMenuItem(value: 'forzada', child: Text('Forzada')),
            DropdownMenuItem(value: 'inmovil', child: Text('Completamente inmóvil')),
          ],
          onChanged: (value) {
            setState(() => _criteria.movilidad = value ?? 'normal');
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _criteria.incontinencia,
          decoration: const InputDecoration(
            labelText: 'Incontinencia',
            prefixIcon: Icon(Icons.water_drop),
          ),
          items: const [
            DropdownMenuItem(value: 'ninguna', child: Text('Ninguna')),
            DropdownMenuItem(value: 'urinaria', child: Text('Urinaria')),
            DropdownMenuItem(value: 'fecal', child: Text('Fecal')),
            DropdownMenuItem(value: 'ambas', child: Text('Ambas')),
          ],
          onChanged: (value) {
            setState(() => _criteria.incontinencia = value ?? 'ninguna');
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'IMC',
            helperText: 'Normal: 18.5-24.9',
            prefixIcon: Icon(Icons.fitness_center),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.imc = double.tryParse(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildWoundAssessmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valoración completa de la herida:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tunelización (cm)',
            helperText: 'Profundidad del túnel',
            prefixIcon: Icon(Icons.straighten),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.tunelizacion = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Socavamiento (cm)',
            helperText: 'Extensión bajo la piel',
            prefixIcon: Icon(Icons.straighten),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.socavamiento = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Profundidad máxima (cm)',
            helperText: 'Profundidad total de la herida',
            prefixIcon: Icon(Icons.straighten),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.profundidadMaxima = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tejido necrótico (%)',
            helperText: 'Porcentaje de tejido muerto',
            prefixIcon: Icon(Icons.healing),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.tejidoNecrotico = double.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Cronicidad (meses)',
            helperText: 'Tiempo desde la aparición',
            prefixIcon: Icon(Icons.calendar_month),
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.cronicidadMeses = int.tryParse(value);
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Signos de infección:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        CheckboxListTile(
          title: const Text('Exudado seropurulento'),
          value: _criteria.exudadoSeropurulento,
          onChanged: (value) {
            setState(() => _criteria.exudadoSeropurulento = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Eritema (enrojecimiento)'),
          value: _criteria.eritema,
          onChanged: (value) {
            setState(() => _criteria.eritema = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Calor local'),
          value: _criteria.calorLocal,
          onChanged: (value) {
            setState(() => _criteria.calorLocal = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Olor fétido'),
          value: _criteria.olorFetido,
          onChanged: (value) {
            setState(() => _criteria.olorFetido = value ?? false);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'PCR (mg/dL)',
            helperText: 'Proteína C Reactiva',
            prefixIcon: Icon(Icons.science),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _criteria.pcr = double.tryParse(value);
            }
          },
        ),
      ],
    );
  }
}
