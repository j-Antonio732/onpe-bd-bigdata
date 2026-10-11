import random, os

random.seed(42)

# Distritos representativos (mismo campo UBIGEO del modelo relacional)
distritos = ['LIMA', 'AREQUIPA', 'CUSCO', 'LORETO', 'PIURA', 'LA LIBERTAD',
             'PUNO', 'JUNIN', 'CAJAMARCA', 'ANCASH', 'SAN MARTIN', 'ICA']

procesos = [
    ('EG-2016', 'Elecciones Generales'),
    ('EG-2020', 'Elecciones Generales'),
    ('EG-2021', 'Elecciones Generales'),
    ('ERM-2018', 'Elecciones Regionales y Municipales'),
    ('ERM-2022', 'Elecciones Regionales y Municipales'),
    ('REF-2018', 'Referéndum'),
]

os.makedirs('datalake/onpe/participacion_historica', exist_ok=True)

rows = []
id_proceso = 1
for ubigeo in distritos:
    # cada distrito tiene una tendencia base de participación distinta
    base = random.uniform(60, 85)
    for cod_proceso, nombre_proceso in procesos:
        variacion = random.uniform(-6, 6)
        participacion = max(35, min(95, base + variacion))
        rows.append({
            'id_proceso': id_proceso,
            'ubigeo': ubigeo,
            'proceso_electoral': nombre_proceso,
            'codigo_proceso': cod_proceso,
            'porcentaje_participacion': round(participacion, 2)
        })
        id_proceso += 1

import csv
with open('datalake/onpe/participacion_historica/participacion.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=['id_proceso','ubigeo','proceso_electoral','codigo_proceso','porcentaje_participacion'])
    w.writeheader()
    w.writerows(rows)

print(f'Generados {len(rows)} registros de prueba en datalake/onpe/participacion_historica/participacion.csv')
