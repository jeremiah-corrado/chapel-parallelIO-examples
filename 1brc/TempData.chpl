module TempData {
  use IO;
  use Math;

  /*
    A record representing the temperature statistics for a weather station
  */
  record tempStats: writeSerializable {
    var min: real;
    var max: real;
    var total: real;
    var count: int;

    proc init(temp: real) {
      this.min = temp;
      this.max = temp;
      this.total = temp;
      this.count = 1;
    }
  }

  /*
    Update the temperature statistics with a new temperature value
  */
  inline operator tempStats.+=(ref ts: tempStats, temp: real) {
    ts.min = Math.min(ts.min, temp);
    ts.max = Math.max(ts.max, temp);
    ts.total += temp;
    ts.count += 1;
  }

  /*
    Merge two temperature statistics records
  */
  inline operator tempStats.+=(ref ts1: tempStats, ref ts2: tempStats) {
    ts1.min = Math.min(ts1.min, ts2.min);
    ts1.max = Math.max(ts1.max, ts2.max);
    ts1.total += ts2.total;
    ts1.count += ts2.count;
  }

  /*
    Print the temperature statistics in the specified output format: 'min/mean/max'
  */
  proc tempStats.serialize(writer: fileWriter(?), ref serializer) throws {
    writer.writef("%.1dr/%.1dr/%.1dr", this.min, this.total / this.count, this.max);
  }

  /*
    A record representing the city-temperature pairs in the data file
  */
  record cityTemp: readDeserializable {
    var city: string; // city name
    var temp: real;   // temperature value
  }

  proc ref cityTemp.deserialize(reader: fileReader(?), ref deserializer) throws {
    this.city = reader.readThrough(';', stripSeparator=true);
    this.temp = reader.read(real);
  }
}
