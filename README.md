# <center>CIU - Práctica 2</center>

## Contenidos

* [Autoría](#autoría)
* [Introducción](#introducción)
* [Controles](#controles)
* [Implementación base](#implementación-base)
* [Implementaciones adicionales](#implementaciones-adicionales)
* [Animación del programa](#animación-del-programa)
* [Referencias](#referencias)

## Autoría

Esta obra es un trabajo realizado por Benearo Semidan Páez para la asignatura de Creación de Interfaces de Usuario cursada en la ULPGC.

## Introducción

El objetivo de esta práctica consiste en implementar en Processing una superficie de revolución, es decir, el usuario, mediante el trazado de un perfil 2D podrá generar una malla 3D.

## Controles

Haciendo <i>click</i> se marcan puntos de perfilado para posteriormente realizar la rotación.

Para generar la figura 3D, se dispone del botón <i>Create shape</i> arriba a la derecha, conjuntamente con <i>Clear screen</i>, que elimina tanto las figuras 3D como los puntos de perfilado.

Por otra parte, usando las flechas arriba, abajo, izquierda y derecha podemos rotar la figura.

## Implementación base

En la implementación base me centro en realizar el sólido de revolución.

El código involucrado se encuentra en el <i>performAction()</i> de el botón que permite crear figuras, y es el que se muestra a continuación.

    public void performAction() {
        genFigure = createShape();
        genFigure.beginShape(TRIANGLE_STRIP);
        ArrayList<ArrayList<Point3D>> rotatedPoints = new ArrayList<ArrayList<Point3D>>();
        for (int theta = 0; theta <= 360; theta++) {
          rotatedPoints.add(new ArrayList<Point3D>());
          for (Point3D point : points) {
            float x1 = point.getX();
            float y1 = point.getY();
            float z1 = point.getZ();
            float x2 = x1 * cos(theta) - z1 * sin(theta);
            float z2 = x1 * sin(theta) + z1 * cos(theta);
            ArrayList<Point3D> aux = rotatedPoints.get(theta);
            aux.add(new Point3D(x2, y1, z2));
          }
        }

        for (int i = 0; i < rotatedPoints.size()-1; i++) {
          boolean isEven = false;
          if (i % 2 == 0) isEven = true;
          for (int j = 0; j < points.size(); j++) {
            float x1, y1, z1;
            float x2, y2, z2;
            if (isEven) {
              x1 = rotatedPoints.get(i).get(j).getX();
              y1 = rotatedPoints.get(i).get(j).getY();
              z1 = rotatedPoints.get(i).get(j).getZ();
              x2 = rotatedPoints.get(i+1).get(j).getX();
              y2 = rotatedPoints.get(i+1).get(j).getY();
              z2 = rotatedPoints.get(i+1).get(j).getZ();
            } else {
              x1 = rotatedPoints.get(i).get(points.size()-1 - j).getX();
              y1 = rotatedPoints.get(i).get(points.size()-1 - j).getY();
              z1 = rotatedPoints.get(i).get(points.size()-1 - j).getZ();
              x2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getX();
              y2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getY();
              z2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getZ();
            }

            genFigure.vertex(x1, y1, z1);
            genFigure.vertex(x2, y2, z2);
          }
        }
        genFigure.endShape(CLOSE);
        points = new ArrayList<Point3D>();
      }

Descrito de manera simple, este fragmento de código realiza, en primer lugar, la rotación de los puntos los 360 grados de 1 grado en 1 grado.

Una vez tenemos almacenado estas rotaciones en distintos <i>ArrayList</i> que contienen todas las rotaciones de cada punto dibujado en el perfilado,
procedemos a relizar las uniones, usando las posiciones pares del bucle para unir desde arriba y las impares para hacerlo desde abajo, creando una especie de zig-zag que, al haber definido <i>TRIANGLE_STRIP</i> en la creación de figura, realizará los triángulos en todas las uniones, dando lugar a la malla esperada.

## Implementaciones adicionales

Para esta práctica, la única implementación adicional destacable es la capacidad de rotar la figura con las flechas del teclado.

Las teclas arriba/abajo hacen que rote en el eje X mientras que las izquierda/derecha lo hacen en el Y.

## Animación del programa

![GIF](assets/animation.gif)

## Referencias

<b>[[Explicación del procedimiento]](https://stackoverflow.com/questions/4117084/opengl-how-to-lathe-a-2d-shape-into-3d)</b>

<b>[[Referencia de Processing]](https://processing.org/reference/)</b>
