use IO, Color, Time, List;

config const fileName = "colors.csv";

var s = new stopwatch();
s.start();

const colors = readColors(fileName);

writeln("time: ", s.elapsed());
writeln("sum: ", + reduce forall c in colors do c.sum());


proc readColors(path: string): [] color {
  var fr = openReader(path, locking=false),
      colors = new list(color);

  // read the header
  fr.readLine();

  // read colors until the end of the file
  var c: color;
  while fr.readln(c) {
    colors.pushBack(c);
  }

  // return an array of colors
  return colors.toArray();
}
