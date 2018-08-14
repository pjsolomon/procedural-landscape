# Procedural Landscapes
The purpose of this project is to explore procedural generation and perlin noise in processing, by generating and rendering landscapes.
The project is entirely written in Processing, with Java syntax. 

![Basic 2D](https://i.imgur.com/IKWIdr0.png) ![Basic 3D](https://i.imgur.com/cXM5V9t.png)

# Island Generation
The central goal with this project was to write a program to generate and display procedurally generated islands using perlin noise.
By altering the output of the noise function, it became possible to alter the landscapes and create islands.
Several different landscape patterns have been hardcoded into the program, which may be utilized by uncommenting where appropriate.

![2D Island Generation](https://i.imgur.com/BdNCSfX.png)

![3D Model of Island](https://i.imgur.com/UAXlCum.png)

# Controls

The program has been updated to utilize the peasycam library, available at http://mrfeinberg.com/peasycam/. This allows for simple navegation of the 3D space using mouse controls.
In addition to transforming the model, the 2D representation may be toggled on or off using the 'm' key, and the stroke can be enabled for easier visualization of the 3D model with the 's' key.
