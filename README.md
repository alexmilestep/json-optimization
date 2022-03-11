# json-optimization

Get json file example 
```
https://drive.google.com/file/d/14XPIA19CQi59aOpjZCKKkJzpERT2KpHw/view
```
Run command
```
ruby optimization.rb -f path_to_file -d xx (e.g. ruby json-optimization.rb -f appland.example.json -d 80)
```
or
```
ruby optimization.rb -f path_to_file -c xx (e.g. ruby optimization.rb -f appland.example.json -c 10)
```
### Options

* -f path to file
* -d desired size reduction in % (from 10 to 90)
* -c remove events with count more than
* -h show help
* You can provide only one option from [-c, -d] at moment to reduce events
