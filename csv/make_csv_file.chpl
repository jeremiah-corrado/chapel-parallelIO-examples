use IO, Color;

config const numLines = 1000,
             fileName = "colors.csv";

// create a fileWriter
var fw = openWriter(fileName, locking=false);

// write header
fw.writeln("r,g,b");

// write 'numLines' random colors
for 1..numLines do fw.writeln(color.random());
