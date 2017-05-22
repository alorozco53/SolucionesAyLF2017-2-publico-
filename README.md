
# Solución Práctica 2

## Author: [AlOrozco53](https://www.github.com/alorozco53/)

### Implementación del algoritmo CKY en Python

Para ejecutar el programa, ejecutar lo siguiente:

```bash
cd src/python
python cfg.py -g <RUTA_GRAMÁTICA> -w <CADENA> -v
```

donde

- `<RUTA_GRAMÁTICA>` es la ruta a un archivo con extensión `.cfg`. En la carpeta [`examples`](examples/)
hay varios ejemplos de gramáticas.
- `<CADENA>` es la cadena a verificar, va entre comillas ("). **IMPORTANTE**: cada símbolo debe de ir separado por un espacio en blanco.
- `-v` es una bandera opcional que indica el modo _verbose_.

Cabe destacar que esta implementación admite gramáticas que no estén en forma normal de Chomsky, pues
las identifica y transforma adecuadamente.

#### Ejemplo de uso

```bash
python cfg.py -g ../../examples/par.cfg -w "( ( ) )" -v
```
