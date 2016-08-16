# Easy Lotto Benchmarks

## Run the app

```
$ vagrant up
$ vagrant ssh
# on the machine
$ sudo /etc/init.d/postgresql restart
$ cd /webapp
$ rails s -b 0.0.0.0
```

## Benchmarks

`$ ab -n 8000 -c 8 http://127.0.0.1:3000/fake`

### WEBrick/1.3.1

```
Concurrency Level:      8
Time taken for tests:   387.984 seconds
Complete requests:      8000
Failed requests:        0
Total transferred:      22504000 bytes
HTML transferred:       18856000 bytes
Requests per second:    20.62 [#/sec] (mean)
Time per request:       387.984 [ms] (mean)
Time per request:       48.498 [ms] (mean, across all concurrent requests)
Transfer rate:          56.64 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    52  387  24.4    381     531
Waiting:       50  385  24.4    379     528
Total:         52  388  24.4    381     531

Percentage of the requests served within a certain time (ms)
  50%    381
  66%    392
  75%    401
  80%    407
  90%    420
  95%    433
  98%    450
  99%    463
 100%    531 (longest request)
```

### Puma 3.6.0

`$ bundle exec puma -p 3000 -w 1 -t 16:16 -e production`

```
Concurrency Level:      8
Time taken for tests:   391.327 seconds
Complete requests:      8000
Failed requests:        0
Total transferred:      21496000 bytes
HTML transferred:       18856000 bytes
Requests per second:    20.44 [#/sec] (mean)
Time per request:       391.327 [ms] (mean)
Time per request:       48.916 [ms] (mean, across all concurrent requests)
Transfer rate:          53.64 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:   205  391  69.7    400     641
Waiting:      204  386  69.9    395     641
Total:        205  391  69.7    401     641

Percentage of the requests served within a certain time (ms)
  50%    401
  66%    430
  75%    444
  80%    453
  90%    475
  95%    492
  98%    514
  99%    534
 100%    641 (longest request)
 ```

### Unicorn 5.1.0

`$ bundle exec unicorn -p 3000 -c ./config/unicorn.rb -E production`

```
Concurrency Level:      8
Time taken for tests:   384.225 seconds
Complete requests:      8000
Failed requests:        0
Total transferred:      21944000 bytes
HTML transferred:       18856000 bytes
Requests per second:    20.82 [#/sec] (mean)
Time per request:       384.225 [ms] (mean)
Time per request:       48.028 [ms] (mean, across all concurrent requests)
Transfer rate:          55.77 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    55  384  27.6    376     583
Waiting:       55  383  27.6    375     582
Total:         56  384  27.6    376     583

Percentage of the requests served within a certain time (ms)
  50%    376
  66%    386
  75%    394
  80%    399
  90%    419
  95%    438
  98%    465
  99%    483
 100%    583 (longest request)
```
### Passenger

`$ bundle exec passenger start -p 3000 -e production`

```
# not enough memory :(

App 24754 stderr: Cannot allocate memory - fork(2)
[ 2016-08-16 04:31:13.5151 24616/7f2ec6e18700 age/Cor/App/Implementation.cpp:304 ]: Could not spawn process for application /webapp: An error occurred while starting the web application. It exited before signalling successful startup back to Phusion Passenger.
  Error ID: e7cdbb44
```
