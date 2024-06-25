*> program: statistical measures part 2.
*> creator: jessica nguyen.
*> date: 2024-03-11.
*> purpose: to calculate the given statistics using the inputted file data and outputting it to the terminal.

identification division.
program-id. statmeasure.

environment division.
   *> sets up an input file (to gain data from a user inputted file).
   input-output section.
   file-control.
   select input-file assign to file-name
      organization is line sequential
      file status is input-status.

data division.
   *> declares and initializes the file variable and its structure.
   file section.
   fd input-file.
   01 input-line.
      02 filler              pic 9(6)v9(2).

   *> declares and initializes other variables (and records) that'll be used.
   working-storage section.
   77 file-name              pic x(100).
   77 input-status           pic xx.
   77 eof-toggle             pic 9 value 0.
   77 sum-of-x-sqr           pic 9(14)v9(2).
   77 sum-of-x               pic s9(10)v9(2).
   77 n                      pic s9(4).
   77 mean                   pic s9(19)v9(19).
   77 g-mean                 pic s9(19)v9(19).
   77 sr                     pic s9(19)v9(19).
   77 sx2                    pic s9(19)v9(19).
   77 i                      pic s9(4).
   01 array-area.
      02 x                   pic s9(6)v9(2) occurs 1000 times.
   01 input-value-record.
      02 in-x                pic s9(6)v9(2).
      02 filler              pic x(72).
   01 output-title-line.
      02 filler              pic x(25) value "    STATISTICS CALCULATOR".
   01 output-underline.
      02 filler              pic x(30) value "------------------------------".
   01 output-col-heads-1.
      02 filler              pic x(30) value "VALUES FROM INPUTTED DATA FILE".
   01 output-col-heads-2.
      02 filler              pic x(18) value "           RESULTS".
   01 output-data-line.
      02 filler              pic x(9) value spaces.
      02 out-x               pic -(6)9.9(2).
   01 output-results-line-1.
      02 filler              pic x(9) value "MEAN    =".
      02 out-mean            pic -(6)9.9(2).
   01 output-results-line-2.
      02 filler              pic x(9) value "STD DEV =".
      02 out-std-deviation   pic -(6)9.9(2).
   01 output-results-line-3.
      02 filler              pic x(9) value "G-MEAN  =".
      02 out-g-mean          pic -(6)9.9(2).
   01 output-results-line-4.
      02 filler              pic x(9) value "H-MEAN  =".
      02 out-h-mean          pic -(6)9.9(2).
   01 output-results-line-5.
      02 filler              pic x(9) value "RMS     =".
      02 out-rms             pic -(6)9.9(2).

procedure division.
   *> obtains the filename from the user.
   display space.
   display "Enter the name of the input file: ".
   accept file-name.

   *> opens the file.
   open input input-file.

   *> displays an error if the file cannot be opened for any reason.
   if input-status is not = "00"
      display space
      display "input-file error. status: " input-status
      display space
      perform end-of-job
      stop run
   end-if.

   *> sets the value of in-x.
   move 0 to in-x.

   *> reads the input file, calculates the statistics, and displays it to the terminal.
   perform until eof-toggle is = 1
      *> displays titles, lines, and headers.
      display space
      display output-title-line
      display output-underline
      display output-col-heads-1
      display output-underline

      *> resets the variable values.
      move 0 to sum-of-x
      move 0 to g-mean
      move 0 to sr
      move 0 to sx2

      *> puts data from the file into the record.
      read input-file into input-value-record
         at end perform end-of-job
      end-read

      perform varying n from 1 by 1 until n is > 1000 or eof-toggle is = 1
         *> displays the data amount from the file.
         move in-x to x(n), out-x
         display output-data-line

         *> uses the data for calculations.
         compute sum-of-x = sum-of-x + x(n)
         compute g-mean = g-mean + function log10(x(n))
         compute sr = sr + (1 / x(n))
         compute sx2 = sx2 + (x(n) * x(n))

         *> goes onto the next data amount from the file.
         read input-file into input-value-record
            at end perform end-of-job
         end-read
      end-perform

      *> calculates and displays the statistics to the terminal.
      display output-underline
      display output-col-heads-2
      display output-underline
      perform statistic-mean
      perform statistic-std-dev
      perform statistic-g-mean
      perform statistic-h-mean
      perform statistic-rms
   end-perform.
   
   *> closes the file and terminates the program.
   display space.
   perform end-of-job.
   stop run.

*> a subprogram paragraph for calculating and displaying the mean.
statistic-mean. 
   compute n = n - 1.
   compute mean rounded = sum-of-x / n.
   move mean to out-mean.
   display output-results-line-1.

*> a subprogram paragraph for calculating and displaying the standard deviation.
statistic-std-dev. 
   move 0 to sum-of-x-sqr.
   perform varying i from 1 by 1 until i is > n
      compute sum-of-x-sqr = sum-of-x-sqr + (x(i) - mean) ** 2
   end-perform.
   compute out-std-deviation rounded = (sum-of-x-sqr / n) ** 0.5.
   display output-results-line-2.
   
*> a subprogram paragraph for calculating and displaying the geometric mean.
statistic-g-mean. 
   compute g-mean rounded = 10 ** (g-mean / n).
   move g-mean to out-g-mean.
   display output-results-line-3.
   
*> a subprogram paragraph for calculating and displaying the harmonic mean.
statistic-h-mean. 
   compute sr rounded = n / sr.
   move sr to out-h-mean.
   display output-results-line-4.
   
*> a subprogram paragraph for calculating and displaying the root mean square.
statistic-rms. 
   compute sx2 = sx2 / n.
   compute sx2 rounded = sx2 ** (1/2).
   move sx2 to out-rms.
   display output-results-line-5.

*> activates eof toggle, closes the input file, and terminates the program.
end-of-job. 
   move 1 to eof-toggle.
   close input-file.
