# Solución de la Práctica 1
## Author: [AlOrozco53](https://www.github.com/alorozco53/)

### Autómatas finitos

Las soluciones a los primeros cinco ejercicios de la práctica se encuentran en la carpeta [`src/`](src/)
bajo el nombre `automata__i__.jff`, donde __i__ indica el número del ejercicio. Los pueden ejecutar
usando JFLAP.

Para el ejercicio _5_, incluí el autómata del lenguaje _L<sub>4</sub>_ en el archivo [`automata5a.jff`](src/automata5a.jff)
y el autómata del lenguaje _N<sub>2</sub>(L<sub>4</sub>)_.




### Transformación de expresiones regulares UNIX a álgebra de Kleene

| Símbolo UNIX | Símbolo _equivalente_ usado | Significado |
| ------------ | --------------------------- | ----------- |
| `\b` | `<` | inicio o fin de una palabra |
| `\w` | `(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)` | letra o dígito |
| `\n\r` | `>¬` | saltos de línea |

| UNIX | Kleene |
| ---- | ------ |
| `\b(0[1-9]\|(1\|2)\d\|3[01])/(0[1-9]\|1[012])/\d{4}\b` | `<(0(1+2+3+4+5+6+7+8+9))+((1+2)(0+1+2+3+4+5+6+7+8+9))/((0(1+2+3+4+5+6+7+8+9))+1(0+1+2))/(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)<` |
| `\b(\w*)ar\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*ar<` |
| `\b(\w*)(er\|ir)\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*(er+ir)<` |
| `^(([^\",\t\n\r^$]*\|\"(\"{2}\|[^\"]\|\s\|^\|$)*\")?($\|,))*$` | `^((.+-+_a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)*+(("(""+(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9+,+.+-+_)+>+!+^+$)*")+!)($+,))*$` |
| `https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)` | `http(s+!)://((www.)+!)(((a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9))*+!)+(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+.(a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+!)((.net)+!)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+-~.@%&_?)*` |
