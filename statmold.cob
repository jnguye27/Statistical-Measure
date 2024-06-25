*> program: statistical measures part 1.
*> creator: jessica nguyen.
*> date: 2024-03-11.
*> purpose: to calculate the mean & std dev using the inputted file data and outputting it into another file.

identification division.
program-id. statmold.

environment division.
   *> sets up an input file (to gain data from a file) and an output file (to put results into a3output.txt).
   input-output section.
   file-control.
   select input-file assign to "nums.txt"
      organization is line sequential
      file status is input-status.
   select output-file assign to "a3output.txt"
      organization is line sequential
      file status is output-status.

data division.
   *> declares and initializes the file variables and their structure.
   file section.
   fd input-file.
   01 input-line.
      02 filler            pic 9(6)v9(2).
   fd output-file.
   01 output-line.
      02 filler            pic x(100).

   *> declares and initializes other variables that'll be used.
   working-storage section.
   77 input-status         pic xx.
   77 output-status        pic xx.
   77 sum-of-x-sqr         pic 9(14)v9(2).
   77 sum-of-x             pic s9(10)v9(2).
   77 n                    pic s9(4).
   77 mean                 pic s9(6)v9(2).
   77 i                    pic s9(4).
   01 array-area.
      02 x                 pic s9(6)v9(2) occurs 1000 times.
   01 input-value-record.
      02 in-x              pic s9(6)v9(2).
      02 filler            pic x(72).
   01 output-title-line.
      02 filler            pic x(28) value "MEAN AND STANDARD DEVIATION".
   01 output-underline.
      02 filler            pic x(28) value "----------------------------".
   01 output-col-heads.
      02 filler            pic x(10) value spaces.
      02 filler            pic x(11) value "DATA VALUES".
   01 output-data-line.
      02 filler            pic x(10) value spaces.
      02 out-x             pic -(6)9.9(2).
   01 output-results-line-1.
      02 filler            pic x(9) value " MEAN=   ".
      02 out-mean          pic -(6)9.9(2).
   01 output-results-line-2.
      02 filler            pic x(9) value " STD DEV=".
      02 std-deviation     pic -(6)9.9(2).

procedure division.
   *> opens the files for input and output.
   open input input-file, output output-file.

   *> displays an error if the files cannot be opened for any reason.
   if input-status is not equal to "00"
      display space
      display "input-file error. status: " input-status
      display space
      perform end-of-job
      stop run
   end-if.
   if output-status is not equal to "00"
      display space
      display "output-file error. status: " output-status
      display space
      perform end-of-job
      stop run
   end-if.

   *> sets the value of in-x.
   move zero to in-x.

   *> reads the input file, calculates the statistics, and writes it into the output file.
   perform proc-body
      until in-x is not less than 999999.98.
   perform end-of-job.

proc-body.
   *> writes the display to the output file.
   write output-line from output-title-line
      after advancing 0 lines.
   write output-line from output-underline
      after advancing 1 line.
   write output-line from output-col-heads
      after advancing 1 line.
   write output-line from output-underline
      after advancing 1 line.

   *> resets the sum-of-x value.
   move zero to sum-of-x.

   *> reads in the data from the input file.
   read input-file into input-value-record
      at end perform end-of-job.
   
   *> calculates the sum.
   perform input-loop
      varying n from 1 by 1
      until n is greater than 1000 or in-x is not less than 999999.98.

   *> calculates the mean.
   subtract 1 from n.
   divide n into sum-of-x giving mean rounded.

   *> resets the sum-of-x-sqr value.
   move zero to sum-of-x-sqr.

   *> calculates the sum-of-x-sqr.
   perform sum-loop
      varying i from 1 by 1
      until i is greater than n.

   *> calculates the standard deviation.
   compute std-deviation rounded = (sum-of-x-sqr / n) ** 0.5.

   *> writes the rest of the output to the output file.
   write output-line from output-underline
      after advancing 1 line.
   move mean to out-mean.
   write output-line from output-results-line-1
      after advancing 1 line.
   write output-line from output-results-line-2
      after advancing 1 line.

*> prints a number from a file, adds it to the sum, and goes onto the next number (used in a loop).
input-loop.
   move in-x to x(n), out-x.
   write output-line from output-data-line
      after advancing 1 line.
   add x(n) to sum-of-x.
   read input-file into input-value-record
      at end perform end-of-job.

*> calculates the sum of sqr (used in a loop).
sum-loop.
   compute sum-of-x-sqr = sum-of-x-sqr + (x(i) - mean) ** 2.

*> closes files and terminates the program.
end-of-job.
   close input-file, output-file.
   stop-run.
