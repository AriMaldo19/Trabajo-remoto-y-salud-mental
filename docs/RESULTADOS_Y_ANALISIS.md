# Resultados y analisis del proyecto

Documento generado automaticamente a partir del dataset de 5.000 empleados.

## Resumen ejecutivo

- **Total de registros analizados:** 5,000
- **Edad promedio:** 41.0 anos
- **Experiencia promedio:** 17.8 anos
- **Empleados con estres alto:** 1,686 (33.7%)
- **Empleados en modalidad remota:** 1,714 (34.3%)

### Hallazgos principales

1. La muestra esta balanceada entre modalidades de trabajo.
| Ubicacion_de_Trabajo | Total | Porcentaje |
| --- | --- | --- |
| Remoto | 1714 | 34.3 |
| Hibrido | 1649 | 33.0 |
| Presencial | 1637 | 32.7 |

2. El estres alto se distribuye de forma relativamente pareja entre modalidades.
| Ubicacion_de_Trabajo | Estres_Alto | Estres_Medio | Estres_Bajo |
| --- | --- | --- | --- |
| Remoto | 590 | 577 | 547 |
| Hibrido | 561 | 545 | 543 |
| Presencial | 535 | 547 | 555 |

3. Depresion, ansiedad y agotamiento son las condiciones mas frecuentes en las tres modalidades.
| Ubicacion_de_Trabajo | Depresion | Ansiedad | Agotamiento | Ninguna |
| --- | --- | --- | --- | --- |
| Hibrido | 421 | 428 | 400 | 400 |
| Presencial | 412 | 407 | 442 | 376 |
| Remoto | 413 | 443 | 438 | 420 |

4. La calidad del sueno varia levemente por genero.
| Genero | Porc_Sueno_Pobre | Porc_Sueno_Bueno |
| --- | --- | --- |
| Male | 35.3 | 31.6 |
| Prefer not to say | 34.2 | 34.2 |
| Non-binary | 34.0 | 33.3 |
| Female | 31.3 | 35.9 |

5. Oceania y Africa concentran la mayor cantidad de registros.
| Region | TotalEmpleados |
| --- | --- |
| Oceania | 867 |
| Africa | 860 |
| Europa | 840 |
| Asia | 829 |
| America del Sur | 827 |
| America del Norte | 777 |

## Consultas avanzadas destacadas

### Acceso a recursos vs. aislamiento social

Hay **1,465 empleados** con acceso a recursos de salud mental pero con aislamiento social por encima del promedio de quienes no tienen acceso.

### Horas trabajadas: remoto vs. presencial

| Empleados_Remotos |
| --- |
| 843 |

### Satisfaccion con el trabajo remoto por modalidad

| Ubicacion_de_Trabajo | Satisfecho | Neutral | Insatisfecho |
| --- | --- | --- | --- |
| Hibrido | 564 | 539 | 546 |
| Presencial | 592 | 506 | 539 |
| Remoto | 519 | 603 | 592 |

## Consultas basicas: muestra representativa

Las 35 consultas basicas demuestran dominio tecnico de SQL. En portfolio basta documentar ejemplos representativos.

### Conteo por modalidad de trabajo

| Ubicacion_de_Trabajo | TotalEmpleados |
| --- | --- |
| Remoto | 1714 |
| Hibrido | 1649 |
| Presencial | 1637 |

### Empleados con estres alto y ansiedad

| Cantidad |
| --- |
| 438 |

### Promedio de edad por genero

| Genero | PromedioEdad |
| --- | --- |
| Female | 40.6 |
| Male | 40.8 |
| Non-binary | 40.9 |
| Prefer not to say | 41.6 |

## Conclusiones

- El trabajo remoto no concentra por si solo todos los indicadores negativos.
- Estres, salud mental y sueno pobre son frecuentes en toda la muestra.
- Tener acceso a recursos de salud mental no elimina el aislamiento social.
- Las politicas de bienestar deben considerar horas, sueno y soporte percibido.

## Recomendaciones

1. Monitorear horas trabajadas en modalidad remota e hibrida.
2. Complementar recursos de salud mental con acciones contra el aislamiento.
3. Segmentar intervenciones por region y rol.
4. Medir satisfaccion y productividad de forma periodica.