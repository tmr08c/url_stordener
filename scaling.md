# Scaling

This document is intended to cover areas in which scaling and load-testing are important to track.

## Testing methodology
Testing was done via the default settings of the [`wrk`](https://github.com/wg/wrk) CLI tool.

## Areas of test
### URL Redirection
Track requests per second in supporting converting from a shortened URL to the final destination URL (including creating tracking events).

When testing a shortened URL, you should avoid one that redirects somewhere that could get rated limited (e.g., Google). This test used a static site's endpoint (https://tmr08c.github.io/2023/01/2022-gratitude/).

```bash
Running 10s test @ http://localhost:4000/keq3nC
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    87.23ms   25.98ms 281.70ms   95.78%
    Req/Sec    52.74     15.38    90.00     75.26%
  1040 requests in 10.03s, 679.45KB read
  Socket errors: connect 1, read 0, write 0, timeout 0
Requests/sec:    103.66
Transfer/sec:     67.72KB
```

### Stats Page
The stats page can be tested similarly to the URL redirection. Below are some benchmarks on a database of the following size:

```sql
url_stordener_dev=# select count(*) from url_mappings;
 count 
-------
    23
(1 row)

url_stordener_dev=# select count(*) from events;
 count 
-------
 25395
(1 row)
```

This test was done ad hoc after other tests and development. It does not serve as a useful, reproducible testing harness, but serves as a starting point for conversations.

```bash
$ wrk http://localhost:4000/stats
Running 10s test @ http://localhost:4000/stats
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    89.03ms    9.69ms 220.76ms   97.22%
    Req/Sec    50.30     14.30   101.00     90.50%
  1007 requests in 10.03s, 35.07MB read
  Socket errors: connect 1, read 0, write 0, timeout 0
Requests/sec:    100.37
Transfer/sec:      3.50MB
Transfer/sec:      3.45MB
```

### URL Submission
Because the URL submission flow is done via LiveView, testing through `wrk` doesn't work well. 

For this first implementation, I am confident it will support the target 5 RPS. For further scaling tests, we could explore alternative tools, such as https://k6.io/docs/javascript-api/k6-browser/ which could let us interact with the browser.

## Extending and Test Ideas

- Make testing reproducible and trackable (e.g., create scripts to seed data, and scripts to run the same tests)
- Test at different orders of magnitude (e.g., number of URL Mappings, number of Events)
- Instrument metrics and observability
  - Metrics can help us track trends
  - Observability can give us more insight into the components of a given trace (e.g., time for different queries)
