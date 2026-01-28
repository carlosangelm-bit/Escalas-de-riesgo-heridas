import 'package:flutter/material.dart';
import '../models/eligibility_questions.dart';
import '../utils/app_theme.dart';
import 'scale_selection_screen.dart';

class EligibilityScreen extends StatefulWidget {
  final String assessmentType; // 'pressure_injury' o 'surgical_infection'

  const EligibilityScreen({
    super.key,
    required this.assessmentType,
  });

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  final Map<String, String> _answers = {};
  int _currentQuestionIndex = 0;
  List<EligibilityQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    if (widget.assessmentType == 'pressure_injury') {
      _questions = PressureInjuryEligibility.getQuestions();
    } else {
      _questions = SurgicalInfectionEligibility.getQuestions();
    }
  }

  void _answerQuestion(String answer) {
    setState(() {
      _answers[_questions[_currentQuestionIndex].id] = answer;
      
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Completado, navegar a selección de escala
        _navigateToScaleSelection();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _navigateToScaleSelection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScaleSelectionScreen(
          assessmentType: widget.assessmentType,
          eligibilityAnswers: _answers,
        ),
      ),
    );
  }

  LinearGradient _getGradient() {
    return widget.assessmentType == 'pressure_injury'
        ? AppTheme.pressureInjuryGradient
        : AppTheme.surgicalInfectionGradient;
  }

  String _getTitle() {
    return widget.assessmentType == 'pressure_injury'
        ? 'Evaluación de Lesiones por Presión'
        : 'Evaluación de Infección Quirúrgica';
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            if (_currentQuestionIndex > 0) {
                              _previousQuestion();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getTitle(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Barra de progreso
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pregunta ${_currentQuestionIndex + 1} de ${_questions.length}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Contenido de la pregunta
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Pregunta
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      if (question.helpText != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity( 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity( 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.helpText!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Opciones
                      ...question.options.map((option) {
                        final isSelected = _answers[question.id] == option.value;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _answerQuestion(option.value),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (widget.assessmentType == 'pressure_injury'
                                          ? AppTheme.pressureStart
                                          : AppTheme.infectionStart)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.withOpacity( 0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity( 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: widget.assessmentType == 'pressure_injury'
                                                      ? AppTheme.pressureStart
                                                      : AppTheme.infectionStart,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option.text,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
