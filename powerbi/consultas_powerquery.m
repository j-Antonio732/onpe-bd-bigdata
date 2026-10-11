// D_MIEMBRO
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    D_MIEMBRO_Sheet = Origen{[Item="D_MIEMBRO",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(D_MIEMBRO_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"LISTADO DE MIEMBROS DE MESA - ONPE ERM 2026", type any}, {"Column2", type any}, {"Column3", type text}, {"Column4", type text}, {"Column5", type text}, {"Column6", type text}, {"Column7", type text}}),
    #"Filas superiores quitadas" = Table.Skip(#"Tipo cambiado",1),
    #"Encabezados promovidos1" = Table.PromoteHeaders(#"Filas superiores quitadas", [PromoteAllScalars=true]),
    #"Tipo cambiado1" = Table.TransformColumnTypes(#"Encabezados promovidos1",{{"id_miembro", Int64.Type}, {"dni", type text}, {"nombre_completo", type text}, {"sexo", type text}, {"distrito", type text}, {"provincia", type text}, {"estado_miembro", type text}}),
    #"Personalizada agregada" = Table.AddColumn(#"Tipo cambiado1", "DNI.1", each Text.PadStart(Text.From([dni]),8,"0")),
    #"Columnas quitadas" = Table.RemoveColumns(#"Personalizada agregada",{"dni"}),
    #"Texto recortado" = Table.TransformColumns(#"Columnas quitadas",{{"nombre_completo", Text.Trim, type text}}),
    #"Texto en mayúsculas" = Table.TransformColumns(#"Texto recortado",{{"nombre_completo", Text.Upper, type text}}),
    #"Valor reemplazado" = Table.ReplaceValue(#"Texto en mayúsculas","MASCULINO","M",Replacer.ReplaceText,{"sexo"}),
    #"Valor reemplazado1" = Table.ReplaceValue(#"Valor reemplazado","FEMENINO","F",Replacer.ReplaceText,{"sexo"}),
    #"Valor reemplazado2" = Table.ReplaceValue(#"Valor reemplazado1","Masculino","M",Replacer.ReplaceText,{"sexo"}),
    #"Valor reemplazado3" = Table.ReplaceValue(#"Valor reemplazado2","Femenino","F",Replacer.ReplaceText,{"sexo"}),
    #"Texto en mayúsculas1" = Table.TransformColumns(#"Valor reemplazado3",{{"sexo", Text.Upper, type text}}),
    #"Valor reemplazado4" = Table.ReplaceValue(#"Texto en mayúsculas1","SUPLENTE","Suplente",Replacer.ReplaceText,{"estado_miembro"}),
    #"Valor reemplazado5" = Table.ReplaceValue(#"Valor reemplazado4","Supl.","Suplente",Replacer.ReplaceText,{"estado_miembro"}),
    #"Valor reemplazado6" = Table.ReplaceValue(#"Valor reemplazado5","T","Titular",Replacer.ReplaceValue,{"estado_miembro"}),
    #"Valor reemplazado7" = Table.ReplaceValue(#"Valor reemplazado6","titular","Titular",Replacer.ReplaceValue,{"estado_miembro"}),
    #"Valor reemplazado8" = Table.ReplaceValue(#"Valor reemplazado7","TITULAR","Titular",Replacer.ReplaceValue,{"estado_miembro"}),
    #"Poner En Mayúsculas Cada Palabra" = Table.TransformColumns(#"Valor reemplazado8",{{"estado_miembro", Text.Proper, type text}}),
    #"Valor reemplazado9" = Table.ReplaceValue(#"Poner En Mayúsculas Cada Palabra",null,"LIMA",Replacer.ReplaceValue,{"provincia"}),
    #"Texto recortado1" = Table.TransformColumns(#"Valor reemplazado9",{{"distrito", Text.Trim, type text}}),
    #"Columnas con nombre cambiado" = Table.RenameColumns(#"Texto recortado1",{{"DNI.1", "DNI"}}),
    #"Columnas reordenadas" = Table.ReorderColumns(#"Columnas con nombre cambiado",{"id_miembro", "nombre_completo", "DNI", "sexo", "distrito", "provincia", "estado_miembro"}),
    #"Duplicados quitados" = Table.Distinct(#"Columnas reordenadas", {"id_miembro"})
in
    #"Duplicados quitados"

// H_ASISTENCIA
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    H_ASISTENCIA_Sheet = Origen{[Item="H_ASISTENCIA",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(H_ASISTENCIA_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"id_asistencia", Int64.Type}, {"id_miembro", Int64.Type}, {"id_capacitacion", Int64.Type}, {"id_proceso", Int64.Type}, {"id_local", Int64.Type}, {"id_tiempo", Int64.Type}, {"estado_asistencia", type text}, {"cantidad", Int64.Type}}),
    #"Valor reemplazado" = Table.ReplaceValue(#"Tipo cambiado","asistio","Asistiò",Replacer.ReplaceValue,{"estado_asistencia"}),
    #"Valor reemplazado1" = Table.ReplaceValue(#"Valor reemplazado","No asistio","No Asistió",Replacer.ReplaceText,{"estado_asistencia"}),
    #"Valor reemplazado2" = Table.ReplaceValue(#"Valor reemplazado1","Asistio","Asistió",Replacer.ReplaceText,{"estado_asistencia"}),
    #"Valor reemplazado3" = Table.ReplaceValue(#"Valor reemplazado2","ASISTIO","Asistió",Replacer.ReplaceText,{"estado_asistencia"}),
    #"Valor reemplazado4" = Table.ReplaceValue(#"Valor reemplazado3","NO Asistió","No Asistió",Replacer.ReplaceValue,{"estado_asistencia"}),
    #"Valor reemplazado5" = Table.ReplaceValue(#"Valor reemplazado4","Falto","No Asistió",Replacer.ReplaceValue,{"estado_asistencia"}),
    #"Valor reemplazado6" = Table.ReplaceValue(#"Valor reemplazado5",null,0,Replacer.ReplaceValue,{"cantidad"}),
    #"Duplicados quitados" = Table.Distinct(#"Valor reemplazado6"),
    #"Valor reemplazado7" = Table.ReplaceValue(#"Duplicados quitados","Asistio","Asistió",Replacer.ReplaceValue,{"estado_asistencia"}),
    #"Valor reemplazado8" = Table.ReplaceValue(#"Valor reemplazado7","Asistiò","Asistió",Replacer.ReplaceText,{"estado_asistencia"}),
    #"Valor reemplazado9" = Table.ReplaceValue(#"Valor reemplazado8","No Asistió","No asistió",Replacer.ReplaceText,{"estado_asistencia"})
in
    #"Valor reemplazado9"

// D_LOCAL
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    D_LOCAL_Sheet = Origen{[Item="D_LOCAL",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(D_LOCAL_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"id_local", Int64.Type}, {"nombre_local", type text}, {"direccion", type text}, {"referencia", type text}, {"distrito", type text}, {"provincia", type text}, {"aula", type text}, {"aforo", type text}}),
    #"Valor reemplazado" = Table.ReplaceValue(#"Tipo cambiado"," personas","",Replacer.ReplaceText,{"aforo"}),
    #"Valor reemplazado1" = Table.ReplaceValue(#"Valor reemplazado","aforo ","",Replacer.ReplaceText,{"aforo"}),
    #"Texto recortado" = Table.TransformColumns(#"Valor reemplazado1",{{"aforo", Text.Trim, type text}}),
    #"Valor reemplazado2" = Table.ReplaceValue(#"Texto recortado",null,"0",Replacer.ReplaceValue,{"aforo"}),
    #"Tipo cambiado1" = Table.TransformColumnTypes(#"Valor reemplazado2",{{"aforo", Int64.Type}}),
    #"Texto recortado1" = Table.TransformColumns(#"Tipo cambiado1",{{"nombre_local", Text.Trim, type text}}),
    #"Valor reemplazado3" = Table.ReplaceValue(#"Texto recortado1",null,"SIN REFERENCIA",Replacer.ReplaceValue,{"referencia"})
in
    #"Valor reemplazado3"

// D_CAPACITACION
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    D_CAPACITACION_Sheet = Origen{[Item="D_CAPACITACION",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(D_CAPACITACION_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"id_capacitacion", Int64.Type}, {"tipo", type text}, {"estado", type text}, {"descripcion", type text}, {"hora_inicio", type text}, {"hora_fin", type text}}),
    #"Texto recortado" = Table.TransformColumns(#"Tipo cambiado",{{"estado", Text.Trim, type text}}),
    #"Valor reemplazado" = Table.ReplaceValue(#"Texto recortado","REALIZADA","Realizada",Replacer.ReplaceText,{"estado"})
in
    #"Valor reemplazado"

// D_TIEMPO
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    D_TIEMPO_Sheet = Origen{[Item="D_TIEMPO",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(D_TIEMPO_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"id_tiempo", Int64.Type}, {"fecha", type date}, {"dia", Int64.Type}, {"mes", Int64.Type}, {"nombre_mes", type text}, {"trimestre", Int64.Type}, {"anio", Int64.Type}}),
    #"Tipo cambiado con configuración regional" = Table.TransformColumnTypes(#"Tipo cambiado", {{"fecha", type date}}, "es-PE")
in
    #"Tipo cambiado con configuración regional"

// D_PROCESO
let
    Origen = Excel.Workbook(File.Contents("C:\Users\USUARIO\Downloads\BD_ONPE_CRUDO_para_ETL.xlsx"), null, true),
    D_PROCESO_Sheet = Origen{[Item="D_PROCESO",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(D_PROCESO_Sheet, [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"id_proceso", Int64.Type}, {"nombre_proceso", type text}, {"tipo_proceso", type text}, {"fecha_proceso", type date}})
in
    #"Tipo cambiado"