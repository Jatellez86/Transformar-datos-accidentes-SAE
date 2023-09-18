
# **********************************************************************************************
#  @Nombre: Transformacion datos SEGOP
#  @Autor: Javier Tellez
#  @Fecha: 20230311
#  @Cambios:
#  @Ayudas:
# **********************************************************************************************
#----------------------------------------------------------------------------------------------

# cargue librerias
library(data.table)
library(lubridate)
library(tidyverse)
library(readr)
library(readxl)
library(openxlsx)
library(stringr)

# dataframes de infracciones y Dim segop requeridos para la transformacion

# lectura de base de datos de infracciones
infracciones <- read_excel("MODELO BASE INOPERABLES.xlsx", 
                           sheet = "INFRACCIONES") %>% janitor::clean_names()

# validamos lista de infracciones y ajustamos como lista separada con conectores
lista_infracciones <- infracciones %>%
  distinct(tipo_novedad)
patrones <- paste(lista_infracciones$tipo_novedad, collapse = "|")


# ideintifica fechas calendario
fecha_inicio <- as.Date("2023-01-01")
fecha_fin <- Sys.Date() - days(1)
fechas <- seq(from = fecha_inicio, to = fecha_fin, by = "day")
formato_fecha <- "%Y%m%d"
fechas <- format(fechas, formato_fecha)
fechas_calendar <- data.frame("fecha" = fechas, stringsAsFactors = FALSE) 

# identifica fechas del directorio (compara solo con una unidad funcional)
inoperables_list <- 
  list.files("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/15 inoperables SEGOP/", full.names = T)
inoperables_dir <- 
  data.frame("nombre_inoper" = inoperables_list, stringsAsFactors = FALSE) %>% 
  mutate(fecha = str_sub(nombre_inoper, -36L, -29L)) %>%
  distinct(fecha) %>%
  mutate(archivos = "ARCHIVOS OK")

# se establece listado de fechas a recorrer (archivos faltantes)
list_ciclo <- fechas_calendar %>% 
              left_join(inoperables_dir, by = "fecha") %>%
              filter(is.na(archivos))

print(list_ciclo$fecha) # fechas disponibles para correr

# ciclo para completar dias disponibles
for (dia in list_ciclo$fecha) {
  
# carga de data frame de estado conductor UF06 -----------------------------------------------------------------------------------------------------------------------
estado_conductor_UF06 <- read_csv(paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/20 estado conductor/",dia,"_estado_conductor_UF06.csv"), 
                                            skip = 2) %>% janitor::clean_names() 
estado_conductor_UF06_2 <- estado_conductor_UF06 %>%
                                            group_by(cedula, conductor, nombre) %>%
                                            summarise(max_vinculacion = max(vinculacion)) %>%
                                            ungroup()

# carga de data frame de inoperables UF06
inoperables_UF06 <- read_csv(paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/12 inoperables/",dia,"_inoperables_UF06.csv"), 
                                       skip = 2) %>% janitor::clean_names()

# transformamos el data frame de acuerdo a los requerimientos de segop
inoperables_UF06_2 <- inoperables_UF06 %>%
                      left_join(estado_conductor_UF06_2, by = "cedula") %>%
                      mutate(fecha_hora_descarga = now(),
                             fecha_recapacitacion_prog = "",
                             valid_patron = str_extract(desc_novedad, patrones),
                             tipo_novedad = ifelse(is.na(valid_patron), 0, valid_patron)) %>%
                      left_join(infracciones, by =  "tipo_novedad") %>%
                      select(cedula,
                             codigo = conductor,
                             nombre,
                             fecha_creacion,
                             fecha_inicio_inoperable,
                             fecha_recapacitacion_prog,
                             desc_novedad,
                             area_responsable,
                             tipo_novedad,
                             nivel = nivel_greenmovil,
                             puntos)

# carga de data frame de estado conductor UF17 -----------------------------------------------------------------------------------------------------------------------
estado_conductor_UF17 <- read_csv(paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/20 estado conductor/",dia,"_estado_conductor_UF17.csv"), 
                                  skip = 2) %>% janitor::clean_names() 
estado_conductor_UF17_2 <- estado_conductor_UF17 %>%
                            group_by(cedula, conductor, nombre) %>%
                            summarise(max_vinculacion = max(vinculacion)) %>%
                            ungroup()

# carga de data frame de inoperables UF06
inoperables_UF17 <- read_csv(paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/12 inoperables/",dia,"_inoperables_UF17.csv"), 
                             skip = 2) %>% janitor::clean_names()

# transformamos el data frame de acuerdo a los requerimientos de segop
inoperables_UF17_2 <- inoperables_UF17 %>%
                          left_join(estado_conductor_UF17_2, by = "cedula") %>%
                          mutate(fecha_hora_descarga = now(),
                                 fecha_recapacitacion_prog = "",
                                 valid_patron = str_extract(desc_novedad, patrones),
                                 tipo_novedad = ifelse(is.na(valid_patron), 0, valid_patron)) %>%
                          left_join(infracciones, by =  "tipo_novedad") %>%
                          select(cedula,
                                 codigo = conductor,
                                 nombre,
                                 fecha_creacion,
                                 fecha_inicio_inoperable,
                                 fecha_recapacitacion_prog,
                                 desc_novedad,
                                 area_responsable,
                                 tipo_novedad,
                                 nivel = nivel_greenmovil,
                                 puntos)
                               
openxlsx::write.xlsx(inoperables_UF06_2, paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/15 inoperables SEGOP/",dia,"_inoperables_segop_UF06.xlsx"))
openxlsx::write.xlsx(inoperables_UF17_2, paste0("G:/Unidades compartidas/GM_OP_ANALISIS_DE_DATOS/15 inoperables SEGOP/",dia,"_inoperables_segop_UF17.xlsx"))
print(dia)
}




