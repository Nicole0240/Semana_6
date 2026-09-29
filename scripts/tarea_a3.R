 #' A3 - Limpieza de datos reales del INE
 #' Módulo II: Semana 6
 #' Autor: Nicole Jara
 #' Fecha: 29-09-2026
 #' Descripción: Se trabajará con la Encuesta Nacional de Empleo (ENE) para 
 #' analizar la relación entre la categoría de ocupación y las horas efectivamente
 #' trabajadas. Donde se realizará una limpieza de los datos, teniendo en cuenta
 #' los valores faltantes, identificación de las variables a usar y usar el factor
 #' de expansión.
 #' Fuente: Instituto Nacional de Estadísticas (INE)
 #' Encuesta: Encuesta Nacional de Empleo (ENE)
 #' Trimestre móvil: mayo-junio-julio de 2026 (mjj)
 #' Fecha de descarga: 22.09-2026
 #' Fuente: https://www.ine.gob.cl/estadisticas-por-tema/mercado-laboral/ocupacion-y-desocupacion
 #' 
 #' Pregunta: ¿Se asocia la categoría de ocupación con las horas efectivamente 
 #' trabajadas por las personas ocupadas en Chile durante mayo-julio de 2026?
 

# 1. Cargar base de datos
library(tidyr)
library(dplyr)

ene <- read.csv2("data/raw/ene-2026-06-mjj.csv") 

dim(ene)

#' Primero cargué la base con read.csv2() porque al abrirla con read.csv() los datos 
#' no se separaban correctamente ya que deja solo una variable. Esto pasa porque 
#' la base utiliza punto y coma para separar las columnas y coma para los decimales. 
#' Después seleccioné solamente las variables que voy a utilizar en el análisis,
#' manteniendo las 97.946 observaciones de la base original.

# 2. Variables a ocupar

#' Me quedaré con estás 5 variables, porque son las que necesito para responder mi
#' pregunta y realizar mi análisis.

#' categoria_ocupacion: Categoría en la ocupación = 
#' 0: No corresponde; 1: Empleador/a; 2: Cuenta propia; 
#' 3: Asalariado/a del sector privado; 4: Asalariado/a del sector público;
#' 5: Personal de servicio doméstico puertas afuera ; 
#' 6: Personal de servicio doméstico puertas adentro
#' 
#' efectivas: Horas efectivas trabajadas en la semana de referencia = 
#' 0  – 168; 888: No sabe; 999: No responde 
#' 
#' activ: Condición de actividad = 
#' 1: Ocupado/a; 2: Desocupado/a; 3: Fuera de la fuerza de trabajo 
#' 
#' sexo: Sexo = 1: Hombre; 2: Mujer 
#' 
#' fact_cal: Factor de expansión trimestral calibrado = 
#' cuántos chilenos representa esta fila

# 3.1 Revisar nombres de las variables 
names(select(ene, starts_with("cat")))
names(select(ene, starts_with("efec")))
names(select(ene, starts_with("act")))
names(select(ene, starts_with("sex")))
names(select(ene, starts_with("fact")))

# Sirve para buscar las variables que se van a usar por el nombre con el que empiezan 

# 3.2 Reducir la base de datos a las variables a ocupar
empleo <- 
  ene |> 
  select(
    starts_with("efec"), 
    categoria_ocupacion, 
    activ, 
    sexo, 
    fact_cal)

dim(empleo)

#'Se creo empleo donde estan las 5 variables que se ocuparán para responder la pregunta 
#'donde se obtuvo 97946 observaciones con las 5 varibles.

# 3.3 Comprobar las variables seleccionadas
names(empleo)

# Se verifico que realmente empleo contenga las 5 variables necesarias.

# 4. Recodificación de variables categoricas

# 4.1 Recodificar la categoría de ocupación y actividad
empleo <- empleo |>
  mutate(
    categoria_txt = case_when(
      categoria_ocupacion == 0 ~ "No corresponde",
      categoria_ocupacion == 1 ~ "Empleador/a",
      categoria_ocupacion == 2 ~ "Cuenta propia",
      categoria_ocupacion == 3 ~ "Asalariado/a sector privado",
      categoria_ocupacion == 4 ~ "Asalariado/a sector público",
      categoria_ocupacion == 5 ~ "Servicio doméstico puertas afuera",
      categoria_ocupacion == 6 ~ "Servicio doméstico puertas adentro",
      TRUE ~ "Otra categoría"
    ),
    situacion = case_when(
      activ == 1 ~ "Ocupado",
      activ == 2 ~ "Desocupado",
      activ == 3 ~ "Inactivo",
      TRUE       ~ "Fuera de edad de trabajar"    
    )
  )
#' Se crearon dos nuevas variables para la base empleo, las cuales son categoria_txt y situacion
#' ya que ayuda a responder mas facil mi pregunta al ser categoria_ocupacion la principal a responder
#' y actividad permite identificar quien esta ocupado, desocupado, inactivo o fuera de edad de trabajo.

# 4.2 Comprobación de ambas categorias recodificadas
table(empleo$categoria_txt, useNA = "ifany")
table(empleo$situacion, useNA = "ifany")

#' Se revisaron las categorías de ocupación y situación laboral para comprobar
#' que la recodificación quedó correcta y verificar si aparecen valores faltantes.

# 5. Revisar valores faltantes
colSums(is.na(empleo))

#' Se buscaron cuántos valores faltantes tiene cada variable de la base empleo.
#' Se encontraron 56.096 NA en efectivas y 15.305 NA en activ, mientras que
#' las demás variables no presentan valores faltantes.


# 5.1 Revisar los valores faltantes de activ
summary(ene$edad[is.na(ene$activ)])

#' Se revisó la edad de las personas que tienen NA en activ.
#' Estos casos corresponden a personas menores de 15 años, por lo que no
#' les corresponde responder sobre su situación laboral.
#' Por esto, estos NA son estructurales y no se deben completar.

# 5.2 Revisar los valores faltantes de efectivas 

table(empleo$activ, is.na(empleo$efectivas), useNA = "ifany") 

#' Se revisó dónde están los valores faltantes de efectivas según la situación laboral.
#' Las 41.850 personas ocupadas tienen información sobre sus horas efectivamente
#' trabajadas, mientras que para las personas desocupadas y fuera de la fuerza
#' de trabajo esta información no corresponde y aparece como NA.

# 5.3 Comparar la base con y sin los NA

nrow(empleo)
nrow(na.omit(empleo))

#'Se comparó la cantidad de observaciones antes y después de usar na.omit().
#'La base pasa de 97.946 a 41.850 observaciones, ya que se eliminan los casos
#'que tienen algún NA. Esto puede afectar el análisis porque algunos NA aparecen
#'porque la información no corresponde para ciertas personas.

# 6. Revisar valores especiales en efectivas
sum(empleo$efectivas == 888, na.rm = TRUE)
sum(empleo$efectivas == 999, na.rm = TRUE)

#' Se revisó la variable efectivas para buscar valores que no corresponden
#' a horas trabajadas. Se encontraron 103 casos con 888 y 8 casos con 999.
#' Según el manual, 888 significa "No sabe" y 999 significa "No responde".

# 6.1 Revisar los valores altos de efectivas

sort(table(empleo$efectivas[empleo$efectivas > 80]), decreasing = TRUE)

#' Se revisaron los valores mayores a 80 para comprobar si aparecían
#' valores especiales. Se encontraron los códigos 888 y 999, que no
#' corresponden a horas trabajadas.

# 6.2 Revisar los valores altos sin los códigos 888 y 999

empleo |>
  filter(
    efectivas > 80,
    efectivas != 888,
    efectivas != 999) |> 
  group_by(efectivas) |>
  summarise(N = n()) |>
  arrange(desc(N))

#' Se quitaron los valores 888 y 999 de la revisión para comprobar los
#' valores reales de horas trabajadas. El valor más frecuente sobre
#' 80 horas es 84, por lo que 888 y 999 corresponden a códigos y no
#' a horas trabajadas.

# 6.3 Convertir los valores especiales en NA

empleo_limpia <-
  empleo |>
  mutate(
    efectivas_ = na_if(efectivas, 888),
    efectivas_ = na_if(efectivas_, 999)
  )

#' Se cambiaron los valores 888 y 999 por NA, ya que corresponden a
#' "No sabe" y "No responde" y no representan una cantidad de horas.

max(empleo$efectivas, na.rm = TRUE)
max(empleo_limpia$efectivas_, na.rm = TRUE)

#' Antes de limpiar, el valor máximo era 999, pero este corresponde a un
#' código y no a horas trabajadas. Después de limpiar los datos, el máximo
#' es 140 horas, que está dentro del rango posible de 0 a 168 horas.

# 6.4 Comparar el promedio antes y después de limpiarla
mean(empleo$efectivas, na.rm = TRUE)
mean(empleo_limpia$efectivas_, na.rm = TRUE)

#' Se comparó el promedio de horas antes y después de limpiar los valores
#' 888 y 999. El promedio bajó de 37.74 aprox. a 35.45 horas aprox, mostrando que
#' estos valores afectaban el resultado porque no corresponden a horas
#' realmente trabajadas.

# 7. Trabajar con las personas ocupadas

ocupados <- empleo_limpia |>
  filter(situacion == "Ocupado")

dim(ocupados)

#' Se dejaron solamente las personas ocupadas, ya que son las que se
#' necesitan para responder la pregunta. La base quedó con 41.850
#' observaciones y 8 variables.

# 7.1 Promedio de horas según categoría de ocupación sin ponderar
ocupados |>
  group_by(categoria_txt) |>
  summarise(
    promedio_horas = mean(efectivas_, na.rm = TRUE)
  )
#' Se calculó el promedio de horas efectivamente trabajadas para cada
#' categoría de ocupación sin usar el factor de expansión.

# 7.2 Promedio de horas según categoría de ocupación ponderado

ocupados |>
  filter(!is.na(efectivas_)) |>
  group_by(categoria_txt) |>
  summarise(
    promedio_horas = sum(efectivas_ * fact_cal) / sum(fact_cal)
  )
#' Se calculó nuevamente el promedio de horas, esta vez usando fact_cal
#' para considerar el factor de expansión de la encuesta.
#' 
#' Al comparar los resultados sin ponderar y ponderados con fact_cal, se
#' observan algunos cambios en el promedio de horas según la categoría.
#' Por ejemplo, en cuenta propia el promedio pasa de 29.0 a 30.0 horas,
#' mientras que en servicio doméstico puertas afuera pasa de 25.9 a 27.0
#' horas. Por esto, para el análisis se utilizarán los resultados ponderados.

# 8. Comparar las horas según categoría de ocupación

resultado_categoria <- ocupados |>
  filter(!is.na(efectivas_)) |>
  group_by(categoria_txt) |>
  summarise(
    promedio_horas = sum(efectivas_ * fact_cal) / sum(fact_cal)
  )

resultado_categoria

#' Se calcularon los promedios de horas de cada categoría para compararlos
#' y ver si existe una asociación con las horas trabajadas.

# 8.1 Que muestran los resultados de los promedios ponderados de mayor hora a menor hora trabajada
      # según la categoria

#' Servicio doméstico puertas adentro: 45,4 horas
#' Empleador/a: 43,5 horas
#' Asalariado/a sector público: 39,3 horas
#' Asalariado/a sector privado: 37,9 horas
#' Otra categoría: 36,3 horas
#' Cuenta propia: 30,0 horas
#' Servicio doméstico puertas afuera: 27,0 horas

# 8.2 Revisar los códigos de categoría de ocupación

table(ocupados$categoria_ocupacion, useNA = "ifany")

#' Se revisaron las categorías recodificadas y no se encontraron valores NA.
#' También se observó una categoría adicional que aparece como "Otra categoría".

# 8.3 Interpretación de los resultados

#' Los resultados muestran que la categoría de ocupación se asocia con diferencias
#' en las horas efectivamente trabajadas. El promedio más alto fue de 45.4 horas
#'  en servicio doméstico puertas adentro, seguido por empleador/a con 43.5 horas.
#' En el sector público el promedio fue de 39.3 horas y en el sector privado
#' fue de 37.9 horas. Los promedios más bajos fueron 27.0 horas en servicio doméstico
#' puertas afuera y 30.0 horas en cuenta propia.Una limitación es que estos resultados muestran
#' una asociación y no permiten decir que la categoría de ocupación sea la causa de las diferencias en horas.

# 9. Guardar el resultado y escribir bitácora

#' Se guardará la base limpia en data/processed para mantener intacta
#' la base original de data/raw.

dir.create("data/processed", showWarnings = FALSE)

write.csv(
  empleo_limpia,
  "data/processed/ene_a3.csv",
  row.names = FALSE
)

file.exists("data/processed/ene_a3.csv")

#' Se comprobó que el archivo ene_a3.csv fue creado correctamente.

### Bitácora de limpieza ###

#' 1. Lectura: se utilizó read.csv2() porque el archivo utiliza punto y coma
#' como separador y coma para los decimales.

#' 2. Variables conservadas: efectivas, categoria_ocupacion, activ, sexo y
#' fact_cal. Se redujo la base de 222 a 5 variables.

#' 3. Recodificación: se recodificaron categoria_ocupacion y activ mediante
#' case_when() para facilitar el análisis.

#' 4. Faltantes: se encontraron 15.305 NA en activ, correspondientes a
#' personas menores de 15 años, por lo que son faltantes estructurales.
#' En efectivas se encontraron 56.096 NA, principalmente porque las horas
#' trabajadas no corresponden a personas desocupadas o fuera de la fuerza
#' de trabajo.

#' 5. Centinelas: se encontraron 103 valores 888 y 8 valores 999 en
#' efectivas. Se cambiaron por NA, ya que corresponden a "No sabe" y
#' "No responde". El promedio pasó de 37,74 a 35,45 horas.

#' 6. Valores altos restantes: después de quitar los códigos 888 y 999,
#' el valor máximo observado fue de 140 horas, por lo que se mantuvieron
#' los valores dentro del rango posible de 0 a 168 horas.

#' 7. Ponderación: se utilizó fact_cal para calcular los promedios
#' ponderados, ya que este factor permite considerar el peso de cada
#' observación en la población.

#' 8. Resultado principal: los promedios de horas efectivamente trabajadas
#' presentan diferencias según la categoría de ocupación.
