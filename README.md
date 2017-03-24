# Solución de la Práctica 1
## Author: [AlOrozco53](https://www.github.com/alorozco53/)

Soluciones de las prácticas de laboratorio del curso de Autómatas y Lenguajes Formales, 2107-2. Facultad de Ciencias, UNAM

### UNIX-REGEX --> KLEENE-REGEX

| UNIX | Kleene |
| ---- | ------ |
| `\b(0[1-9]|(1|2)\d|3[01])/(0[1-9]|1[012])/\d{4}\b` | `<(0(1+2+3+4+5+6+7+8+9))+((1+2)(0+1+2+3+4+5+6+7+8+9))/((0(1+2+3+4+5+6+7+8+9))+1(0+1+2))/(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)<` |
