#!/usr/bin/ruby

# Dependecies
require 'trollop'
require 'csv'

# Command Line Interface
#
# Description: Parse command line and validate inputs
class CLI
  attr_reader :opts

  def initialize
    parser = Trollop::Parser.new do
      version "Batch CSV Parser v0.1.0 (c) 2015 Pasquale D'Agostino"
      banner <<-EOS
Given a directory of CSV files and a column to match on a regular expression,
this program will print the matches to standard out.

Usage:
batch_csv_parser [options]
where [options] are:
EOS
      opt :col, "Column to perform the regex match on (start count at 0)", :type => :integer, :required => true
      opt :dir, "Path to csv files (directory)", :type => :string, :required => true
      opt :regex, "Regex to search for across the csv files", :type => :string, :required => true
      opt :only, "Extract and print only columns of interest", :type => :integers
    end
    @opts = Trollop::with_standard_exception_handling parser do
      raise Trollop::HelpNeeded if ARGV.empty? # show help screen
      parser.parse ARGV
    end
    sanity_checks
  end # End initialize

  # method to check for valid inputs via the CLI
  def sanity_checks
    abort 'The path given does not exist or does not contain csv files' if Dir["#{@opts[:dir]}/*.csv"].empty?
    begin
      Regexp.new @opts[:regex]
    rescue => e
      abort "#{@opts[:regex]} is not a valid regular expression"
    end
  end # End sanity_checks

end # End InterfaceCLI

class BatchCSV

  def initialize(opts)
    @opts = opts
    @regex = Regexp.new @opts[:regex]
    @matches = []
  end # End initialize

  # Grep through each CSV in the directory and then
  # print out any matches to STDOUT
  def run
    Dir["#{@opts[:dir]}/*.csv"].each do |file|
      grep_csv(file)
    end
    if !@matches.empty?
      @matches.each do |row|
        print_match(row)
      end
    end
  end # End run

  # Go through each row in the CSV and find columns that match
  # the regex pattern. Add these matches to an array for printing
  def grep_csv(file)
    csv = CSV.read(file)
    csv.each do |row|
      if row[@opts[:col]] =~ @regex
        @matches.push(row)
      end
    end
  end # end grep_csv

  # Prints out the matches, either columns of interest or the entire CSV row
  def print_match(row)
    string = ""
    if !@opts[:only].nil?
      begin
        @opts[:only].each do |col|
          if col == @opts[:only].last
            string += "#{row[col]}"
          else
            string += "#{row[col]},"
          end
        end
        puts string
      rescue => e
        abort 'Error: Columns of interest out of bounds!'
      end
    else
      string = row.join(',')
      print string 
    end
  end # End print_match

end # End BatchCSV

# if executable, equivalent to main()
if __FILE__ == $0
  cli = CLI.new                   # Parse and validate the CLI
  batch = BatchCSV.new(cli.opts)  # Init a Batch Object w/ CLI arguments
  batch.run                       # Parse and Print matches to STDOUT
end
