# chapel-parallelIO-examples

A few examples of using Chapel's [ParallelIO](https://chapel-lang.org/docs/modules/packages/ParallelIO.html) module to read large files in parallel.

* **csv**: read a csv file of RGB color values
    - uses: [`readDelimitedAsArray`](https://chapel-lang.org/docs/modules/packages/ParallelIO.html#ParallelIO.readDelimitedAsArray)
* **fastq**: read a [fastq](https://en.wikipedia.org/wiki/FASTQ_format) (gene sequencing) file in parallel
    - uses: [`readItemsAsArray`](https://chapel-lang.org/docs/modules/packages/ParallelIO.html#ParallelIO.readItemsAsArray)
* **1brc**: an implementation of the [1-billion-rows-challenge](https://github.com/gunnarmorling/1brc/blob/main/README.md) that uses the parallelIO module
    - uses: [`readDelimited`](https://chapel-lang.org/docs/modules/packages/ParallelIO.html#ParallelIO.readDelimited)
