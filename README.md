# Solución de la Práctica 1
## Author: [AlOrozco53](https://www.github.com/alorozco53/)

Soluciones de las prácticas de laboratorio del curso de Autómatas y Lenguajes Formales, 2107-2. Facultad de Ciencias, UNAM

### UNIX-REGEX --> KLEENE-REGEX

| Símbolo UNIX | Símbolo _equivalente_ usado | Significado |
| ------------ | --------------------------- | ----------- |
| `\b` | `<` | inicio o fin de una palabra |
| `\w` | `(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)` | letra o dígito |
| `\n\r` | `>¬` | saltos de línea |

| UNIX | Kleene |
| ---- | ------ |
| `\b(0[1-9]|(1|2)\d\|3[01])/(0[1-9]\|1[012])/\d{4}\b` | `<(0(1+2+3+4+5+6+7+8+9))+((1+2)(0+1+2+3+4+5+6+7+8+9))/((0(1+2+3+4+5+6+7+8+9))+1(0+1+2))/(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)<` |
| `\b(\w*)ar\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*ar<` |
| `\b(\w*)(er\|ir)\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*(er+ir)<` |
| `^(([^\",\t\n\r^$]*\|\"(\"{2}\|[^\"]\|\s\|^\|$)*\")?($\|,))*$` | `^((.+-+_a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)*+(("(""+(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9+,+.+-+_)+>+!+^+$)*")+!)($+,))*$` |
| `https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)` | `https://((www.)+!)(((a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9))*+!)+((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+.(a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+!)((.net)+!)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+-~.@%&_?)*` |
