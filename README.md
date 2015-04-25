## Ruby Scripts
Place to dump any command line tools or ruby scripts I am developing. Feel free to use at your own risk!

```
$ git clone https://github.com/elauqsap/ruby-scripts.git
```

#### Batch CSV Parser
Purpose: Multiple CSV files with a column pattern you want to search on. Also allows you to extract columns of relevant content instead of having the entire row or just the matched data.

```
$ gem install trollop csv
$ chmod +x batch_csv_parser.rb
$ ./batch_csv_parser.rb
```

Usage:
```
batch_csv_parser [options]\r\nwhere [options] are:
--col=<i>      Column to perform the regex match on (start count at 0)
--dir=<s>      Path to csv files (directory)
--regex=<s>    Regex to search for across the csv files
--only=<i+>    Extract and print only columns of interest
```
