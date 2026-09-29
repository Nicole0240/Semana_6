# tarea_a3-fundamentos
Tarea A3: Limpieza de datos reales del INE
Autor: Nicole Jara
Fecha: 29-09-2026

Pregunta: ¿Se asocia la categoría de ocupación con las horas efectivamente trabajadas 
por las personas ocupadas en Chile durante mayo-julio de 2026?

En los datos analizados, los promedios de horas efectivamente trabajadas presentan 
diferencias según la categoría de ocupación. El promedio ponderado más alto corresponde 
a servicio doméstico puertas adentro, con 45.4 horas, seguido por empleador/a con 43.5 horas. 
En el sector público el promedio fue de 39.3 horas y en el sector privado de 37.9 horas. Los 
promedios más bajos fueron 27.0 horas en servicio doméstico puertas afuera y 30.0 horas en 
cuenta propia. Estos resultados muestran una asociación, pero no permiten afirmar que la 
categoría de ocupación sea la causa de las diferencias en las horas trabajadas.

Fuente: Instituto Nacional de Estadísticas (INE)
Encuesta: Encuesta Nacional de Empleo (ENE)
Trimestre móvil: mayo-junio-julio de 2026 (mjj)
Fecha de descarga: 22-09-2026
Fuente: https://www.ine.gob.cl/estadisticas-por-tema/mercado-laboral/ocupacion-y-desocupacion

Variables utilizadas:
 -categoria_ocupacion: categoría de ocupación.
 -efectivas: horas efectivamente trabajadas en la semana de referencia.
 -activ: condición de actividad.
 -sexo: sexo de la persona.
 -fact_cal: factor de expansión trimestral calibrado. 
 -También se crearon las variables categoria_txt y situacion mediante case_when() para 
 ayudar en el análisis.
 
Cómo correr el script: Abrir el proyecto en RStudio y ejecutar el archivo scripts/tarea_a3.R 
desde la carpeta principal del repositorio. 

## Declaración de autoría y uso de IA

- Herramienta utilizada: ChatGPT
- Para qué la usé: Para comprender las instrucciones de la actividad, resolver dudas sobre 
la limpieza de los datos, consultar cómo tratar los valores 888 y 999 de las horas efectivamente 
trabajadas y cómo incorporar fact_cal en los resultados ponderados. También la utilicé para 
revisar si el código cumplía con los puntos solicitados en la tarea.
- Qué hice yo: Revisé la información de la encuesta y el significado de las variables, 
planteé la pregunta de investigación, seleccioné las variables, ejecuté y revisé el código 
en el R y decidí qué datos mantener o transformar. También revisé los resultados obtenidos y 
redacté la interpretación y la bitácora de limpieza.
- Verificación: Confirmo que entiendo y puedo explicar todo lo que entrego.