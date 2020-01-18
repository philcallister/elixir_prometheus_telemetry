# Elixir Prometheus Telemetry

  This is a simple, bare-bones example Elixir app, which shows how to add basic instrumentation through [Telemetry](https://github.com/beam-telemetry/telemetry) and deliver it to [Prometheus](https://prometheus.io/)

### Installation
```sh
$ mix deps.get
$ mix deps.compile
```

### Run It
Once you've got all the dependencies pulled, start it up within `iex` so you can add a few counts to some fictitious commands
```sh
iex -S mix run
```
Now that you're within `iex`, you can add some command counts. Try the following
```elixir
iex(1)> Basic.Metrics.CommandInstrumenter.execute("ONE")
:ok
iex(2)> Basic.Metrics.CommandInstrumenter.execute("TWO")
:ok
iex(3)> Basic.Metrics.CommandInstrumenter.execute("TWO")
:ok
```
At this point, you'll have command `ONE` with a count of `1` and command `TWO` with a count of `2`. To see what metrics Prometheus will scrape from the app, you can visit the following endpoint within your browser
```
http://localhost:4000/metrics
```
When you hit this endpoint, you'll see something similar to this
```
# TYPE basic_command_total counter
# HELP basic_command_total Command Count
basic_command_total{command="ONE"} 1
basic_command_total{command="TWO"} 2
...
```

### Prometheus
To see how metrics are actually pulled into Prometheus, you'll first need to install it and configure it. For more information on installation and configuration, check out the [Prometheus Documentation](https://prometheus.io/docs/introduction/first_steps/). To add the app's endopoint to Prometheus, you'll want to add the following configuration to the `prometheus.yml` file under the `scrape_configs:` element within that file. Again, you'll want to check the documentation to figure out where this file is located for your installation.
```yml
scrape_configs:
  - job_name: "basic"
    scheme: "http"
    static_configs:
    - targets: ["localhost:4000"]
```
Once you start the Prometheus service, you should be able to explore the UI by visiting `http://localhost:9090/graph` within your browser. From the dropdown, select the the `basic_command_total` element, and add it to a graph by clicking the `Execute` button. Click on the `Graph` tab, and you'll see your app metrics! Enjoy!

