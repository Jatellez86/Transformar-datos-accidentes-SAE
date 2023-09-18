# Transformar-datos-accidentes-SAE
Este escript toma datos del sae y una tabla dimesional para extraer informacion accionable de infracciones por accidentes de transito

# 📊 Transformación de Datos SEGOP

## 📝 Descripción

Este script de R 📊 se utiliza para transformar y preparar datos relacionados con conductores y sus infracciones para SEGOP. Realiza la extracción, transformación y carga (ETL) de varios archivos `.csv` y `.xlsx`.

## 🛠️ Dependencias

- R 📊
- data.table 📋
- lubridate 📅
- tidyverse 🛠️
- readr 📑
- readxl 📊
- openxlsx 📊
- stringr 🔍

## 🔄 Funcionamiento

1. **📋 Carga de Librerías**: Utiliza múltiples librerías de R para manejar dataframes, fechas y archivos.
2. **📜 Lectura de Archivos**: Lee archivos `.xlsx` y `.csv` de diferentes ubicaciones en el sistema.
3. **🔍 Filtros y Transformaciones**: Limpia y transforma los datos para adaptarlos a los requisitos de SEGOP.
4. **🔄 Ciclo de Fechas**: Realiza un ciclo para procesar archivos de diferentes fechas.
5. **💾 Exportar Archivos**: Guarda los dataframes transformados en archivos `.xlsx`.

## 🚀 Cómo usar

1. Instale todas las dependencias 🛠️.
2. Actualice las rutas de los archivos y directorios para adaptarlas a su sistema 💾.
3. Ejecute el script 🚀.

## ⚠️ Nota

- Asegúrese de que los archivos y directorios a los que hace referencia el script existan en la ubicación especificada.
- Este script fue creado por Javier Tellez y la última actualización fue en marzo de 2023.
