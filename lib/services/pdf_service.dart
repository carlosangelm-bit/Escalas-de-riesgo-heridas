import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/entities/evaluacion_lpp.dart';

/// Servicio para generar y gestionar PDFs de evaluaciones
class PdfService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  /// Generar PDF de evaluación LPP
  Future<Uint8List> generarPdfEvaluacion(EvaluacionLPP evaluacion) async {
    final pdf = pw.Document();
    
    // Cargar fuente
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Encabezado
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'WOUND CARE PRO',
                    style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.pink700),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Escala Kura+ LPP v2.0',
                    style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey700),
                  ),
                  pw.Divider(color: PdfColors.pink700, thickness: 2),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Información del Paciente
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'DATOS DEL PACIENTE',
                    style: pw.TextStyle(font: fontBold, fontSize: 16),
                  ),
                  pw.SizedBox(height: 8),
                  _buildInfoRow('Nombre', evaluacion.nombrePaciente, font, fontBold),
                  _buildInfoRow('Edad', '${evaluacion.edadPaciente} años', font, fontBold),
                  if (evaluacion.diagnostico != null)
                    _buildInfoRow('Diagnóstico', evaluacion.diagnostico!, font, fontBold),
                  _buildInfoRow(
                    'Fecha de Evaluación',
                    '${evaluacion.fechaEvaluacion.day}/${evaluacion.fechaEvaluacion.month}/${evaluacion.fechaEvaluacion.year}',
                    font,
                    fontBold,
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Resultados Principales
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _getColorForCategoria(evaluacion.escala.categoria),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'RESULTADO GLOBAL',
                    style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Puntaje Total: ${evaluacion.escala.puntajeTotal} / 15',
                        style: pw.TextStyle(font: fontBold, fontSize: 20, color: PdfColors.white),
                      ),
                      pw.Text(
                        evaluacion.escala.categoria.toUpperCase(),
                        style: pw.TextStyle(font: fontBold, fontSize: 20, color: PdfColors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Desglose por Dominios
            pw.Text(
              'DESGLOSE POR DOMINIOS',
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
            pw.SizedBox(height: 12),
            
            _buildDominioCard('NUTRICIÓN', evaluacion.escala.dominioNutricion, 3, font, fontBold),
            pw.SizedBox(height: 8),
            _buildDominioCard('PERFUSIÓN', evaluacion.escala.dominioPerfusion, 3, font, fontBold),
            pw.SizedBox(height: 8),
            _buildDominioCard('HERIDA', evaluacion.escala.dominioHerida, 3, font, fontBold),
            pw.SizedBox(height: 8),
            _buildDominioCard('PRESIÓN', evaluacion.escala.dominioPresion, 3, font, fontBold),
            pw.SizedBox(height: 8),
            _buildDominioCard('CLÍNICO', evaluacion.escala.dominioClinico, 3, font, fontBold),
            
            pw.SizedBox(height: 20),
            
            // Interpretación Clínica
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'INTERPRETACIÓN CLÍNICA',
                    style: pw.TextStyle(font: fontBold, fontSize: 14),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    evaluacion.escala.interpretacionClinica,
                    style: pw.TextStyle(font: font, fontSize: 11),
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 12),
            
            // Tratamiento Recomendado
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'TRATAMIENTO RECOMENDADO',
                    style: pw.TextStyle(font: fontBold, fontSize: 14),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    evaluacion.escala.tratamientoRecomendado,
                    style: pw.TextStyle(font: font, fontSize: 11),
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Pie de página
            pw.Footer(
              margin: const pw.EdgeInsets.only(top: 20),
              decoration: const pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
              ),
              trailing: pw.Text(
                'Generado el ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} a las ${DateTime.now().hour}:${DateTime.now().minute}',
                style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
              ),
            ),
          ];
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Widget helper para filas de información
  pw.Widget _buildInfoRow(String label, String value, pw.Font font, pw.Font fontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: pw.TextStyle(font: fontBold, fontSize: 12)),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: 12)),
        ],
      ),
    );
  }
  
  /// Widget helper para tarjetas de dominio
  pw.Widget _buildDominioCard(String titulo, int puntaje, int max, pw.Font font, pw.Font fontBold) {
    final porcentaje = (puntaje / max * 100).round();
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(titulo, style: pw.TextStyle(font: fontBold, fontSize: 12)),
          pw.Row(
            children: [
              pw.Container(
                width: 100,
                height: 10,
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: porcentaje.toDouble(),
                      decoration: pw.BoxDecoration(
                        color: _getColorForPuntaje(puntaje, max),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text('$puntaje / $max', style: pw.TextStyle(font: fontBold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Obtener color según categoría
  PdfColor _getColorForCategoria(String categoria) {
    switch (categoria) {
      case 'Favorable':
        return PdfColors.green700;
      case 'Intermedio':
        return PdfColors.orange700;
      case 'Desfavorable':
        return PdfColors.red700;
      default:
        return PdfColors.grey700;
    }
  }
  
  /// Obtener color según puntaje
  PdfColor _getColorForPuntaje(int puntaje, int max) {
    final porcentaje = puntaje / max;
    if (porcentaje <= 0.33) {
      return PdfColors.green;
    } else if (porcentaje <= 0.66) {
      return PdfColors.orange;
    } else {
      return PdfColors.red;
    }
  }
  
  /// Subir PDF a Firebase Storage
  Future<String> subirPdfAStorage(Uint8List pdfBytes, String evaluacionId) async {
    try {
      final fileName = 'evaluaciones/$evaluacionId.pdf';
      final ref = _storage.ref().child(fileName);
      
      await ref.putData(
        pdfBytes,
        SettableMetadata(contentType: 'application/pdf'),
      );
      
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Error al subir PDF: $e');
    }
  }
  
  /// Compartir o imprimir PDF
  Future<void> compartirPdf(Uint8List pdfBytes, String nombrePaciente) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Evaluacion_LPP_${nombrePaciente}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
  
  /// Vista previa del PDF
  Future<void> previsualizarPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}
