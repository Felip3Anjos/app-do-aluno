import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme_provider.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class CadernoEnem {
  final String nome; // "Caderno 1 - Azul" "Caderno 2 - Amarelo" e etc...
  final String url;
  CadernoEnem({required this.nome, required this.url});
}

class DiaEnem {
  final String nome; // "1º Dia", "2º Dia" e etc...
  final List<CadernoEnem> cadernos;
  DiaEnem({required this.nome, required this.cadernos});
}

class AnoEnem {
  final String ano;
  final List<DiaEnem> dias;
  AnoEnem({required this.ano, required this.dias});
}

class PaginaProvasEnem extends StatefulWidget {
  const PaginaProvasEnem({super.key});

  @override
  State<PaginaProvasEnem> createState() => _PaginaProvasEnemState();
}

class _PaginaProvasEnemState extends State<PaginaProvasEnem> {
  final Dio _dio = Dio();
  bool _downloading = false;

  //LISTA DE PROVAS DO ENEM
  final List<AnoEnem> _dadosEnem = [
    AnoEnem(
      ano: '2024',
      dias: [
        DiaEnem(
          nome: '1º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Azul',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D1_CD1.pdf',
            ),
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D1_CD2.pdf',
            ),
            CadernoEnem(
              nome: 'Branco',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D1_CD3.pdf',
            ),
          ],
        ),
        DiaEnem(
          nome: '2º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Azul',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D2_CD7.pdf',
            ),
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D2_CD5.pdf',
            ),
            CadernoEnem(
              nome: 'Cinza',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2024_PV_impresso_D2_CD6.pdf',
            ),
          ],
        ),
      ],
    ),
    AnoEnem(
      ano: '2023',
      dias: [
        DiaEnem(
          nome: '1º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Azul',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D1_CD1.pdf',
            ),
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D1_CD2.pdf',
            ),
            CadernoEnem(
              nome: 'Rosa',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D1_CD4.pdf',
            ),
            CadernoEnem(
              nome: 'Branco',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D1_CD3.pdf',
            ),
          ],
        ),
        DiaEnem(
          nome: '2º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D2_CD8.pdf',
            ),
            CadernoEnem(
              nome: 'Cinza',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D2_CD7.pdf',
            ),
            CadernoEnem(
              nome: 'Azul',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D2_CD9.pdf',
            ),
            CadernoEnem(
              nome: 'Rosa',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2023_PV_impresso_D2_CD10.pdf',
            ),
          ],
        ),
      ],
    ),
    AnoEnem(
      ano: '2022',
      dias: [
        DiaEnem(
          nome: '1º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Azul',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2022_PV_impresso_D1_CD1.pdf',
            ),
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2022_PV_impresso_D1_CD2.pdf',
            ),
          ],
        ),
        DiaEnem(
          nome: '2º Dia',
          cadernos: [
            CadernoEnem(
              nome: 'Cinza',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2022_PV_impresso_D2_CD5.pdf',
            ),
            CadernoEnem(
              nome: 'Amarelo',
              url:
                  'https://download.inep.gov.br/enem/provas_e_gabaritos/2022_PV_impresso_D2_CD6.pdf',
            ),
          ],
        ),
      ],
    ),
    //preciso adicionar os anos 2021, 2020, 2019, 2018 aqui 
  ];

  Future<void> _handleProvaClick(CadernoEnem caderno, String ano) async {
    if (_downloading) return;

    if (kIsWeb) {
      final uri = Uri.parse(caderno.url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print('Não foi possível abrir $uri');
      }
    } else {
      //download para mobile
      setState(() {
        _downloading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2.0,
        shadowColor: Colors.black,
        title: Text(
          "Vestibulares Anteriores",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF002F5A), const Color(0xFF335D9B)]
                : [
                    const Color.fromARGB(255, 0, 52, 80),
                    const Color(0xFF5B73FF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _dadosEnem.length,
          itemBuilder: (context, index) {
            final ano = _dadosEnem[index];
            return Card(
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ExpansionTile(
                title: Text(
                  'ENEM ${ano.ano}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                iconColor: Colors.white70,
                collapsedIconColor: Colors.white70,
                children: ano.dias.map((dia) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
 
                        Text(
                          dia.nome,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // BOTÕES DOS CADERNOS
                        Wrap(
                          spacing: 8.0, 
                          runSpacing:
                              8.0, 
                          children: dia.cadernos.map((caderno) {
                            return ElevatedButton(
                              onPressed: () =>
                                  _handleProvaClick(caderno, ano.ano),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(caderno.nome),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
