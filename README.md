# Solución de la Práctica 1
## Author: [AlOrozco53](https://www.github.com/alorozco53/)

Primera observación: todo el código está en la carpeta [`src/`](src/), de acuerdo al formato de entrega de
prácticas establecido en la página del curso.

### Autómatas finitos

Las soluciones a los primeros cinco ejercicios de la práctica se encuentran
bajo el nombre `automatai.jff`, donde __i__ indica el número del ejercicio. Los pueden ejecutar
usando JFLAP.

Para el ejercicio _5_, incluí el autómata del lenguaje _L<sub>4</sub>_ en el archivo [`automata5a.jff`](src/automata5a.jff)
y el autómata del lenguaje _N<sub>2</sub>(L<sub>4</sub>)_ en [`automata5b.jff`](src/automata5b.jff).

### Expresiones regulares

Las expresiones regulares de UNIX están en el archivo [`ejercicio_regex.sh`](src/ejercicio_regex.sh). Su ejecución es
análoga a la de los ejemplos que les pasé en [este repositorio](https://github.com/alorozco53/Ejemplos-Laboratorio-AyLF-2017-2).

Si exploran un poco el archivo, se darán cuenta que hay:

- Una regex para el ejercicio 1,
- Dos regex para el ejercicio 2,
- Una regex para el ejercicio 3 a,
- Una regex para el ejercicio 3 b y
- Cuatro regex para el ejercicio 3 c.

### Transformación de expresiones regulares UNIX a álgebra de Kleene

Los autómatas que pedí para ciertas regex se encuentran en los archivos que contienen la subcadena `_regex`. Son cosas monstruosamente
enormes, por lo que sólo los pedí como evidencia de que usaron la herramienta de JFLAP para generarlos.

Para construirlos, utilicé la siguiente tabla de equivalencias, ya que JFLAP trata un símbolo formado por dos carácteres
de manera separada.

| Símbolo UNIX | Símbolo _equivalente_ usado | Significado |
| ------------ | :---------------------------: | ----------- |
| `\b` | `<` | inicio o fin de una palabra |
| `\w` | `(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)` | letra o dígito |
| `\n\r` | `>¬` | saltos de línea |

Finalmente, utilizando lo anterior, hice la conversión de notaciones. Lo que está en la segunda columna de la siguiente
tabla es la regex que le pasé a JFLAP.

| UNIX | Kleene |
| ---- | ------ |
| `\b(0[1-9]\|(1\|2)\d\|3[01])/(0[1-9]\|1[012])/\d{4}\b` | `<(0(1+2+3+4+5+6+7+8+9))+((1+2)(0+1+2+3+4+5+6+7+8+9))/((0(1+2+3+4+5+6+7+8+9))+1(0+1+2))/(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)(0+1+2+3+4+5+6+7+8+9)<` |
| `\b(\w*)ar\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*ar<` |
| `\b(\w*)(er\|ir)\b` | `<(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z)*(er+ir)<` |
| `^(([^\",\t\n\r^$]*\|\"(\"{2}\|[^\"]\|\s\|^\|$)*\")?($\|,))*$` | `^((.+-+_a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)*+(("(""+(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9+,+.+-+_)+>+!+^+$)*")+!)($+,))*$` |
| `https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)` | `http(s+!)://((www.)+!)(((a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9))*+!)+(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+.(a+b+c+d+e+f+g+h+i+j+k+l+m+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)(a+b+c+d+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+!)((.net)+!)((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y+z+0+1+2+3+4+5+6+7+8+9)+-~.@%&_?)*` |
