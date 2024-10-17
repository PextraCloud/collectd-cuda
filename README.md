# collectd-cuda

This is a simple script that can be run with [collectd's](https://www.collectd.org/) `exec` plugin to monitor NVIDIA GPUs. It relies on `nvidia-smi` to gather the data.

## Installation

1. Make sure you have `nvidia-smi` and `collectd` available on your system:
	```sh
	which nvidia-smi
	which collectd
	```
3. Enable the `exec` plugin:
	```
	LoadPlugin exec
	```
4. Copy `collectd-cuda.sh` to a location on your system. Make sure it is executable.
5. Add the following configuration to your collectd configuration file:
	```
	<Plugin exec>
		Exec "nobody:nogroup" "/path/to/collectd-cuda.sh"
	</Plugin>
	```
	where `/path/to/collectd-cuda.sh` is the path to the script, and `nobody:nogroup` is the user and group that collectd should run the script as.
6. Restart collectd.

### Example

This script echos `PUTVAL` ([plain-text protocol](https://github.com/collectd/collectd/wiki/Plain-text-protocol)) lines to stdout.

An example:
```
PUTVAL host.localdomain/cuda-00000000:0A:00.0/percent-utilization_gpu interval=10 N:9
PUTVAL host.localdomain/cuda-00000000:0A:00.0/absolute-pstate interval=10 N:5
PUTVAL host.localdomain/cuda-00000000:0A:00.0/temperature-temperature_gpu interval=10 N:39
PUTVAL host.localdomain/cuda-00000000:0A:00.0/percent-fan_speed interval=10 N:0
PUTVAL host.localdomain/cuda-00000000:0A:00.0/memory-memory_free interval=10 N:19699
PUTVAL host.localdomain/cuda-00000000:0A:00.0/percent-utilization_memory interval=10 N:8
PUTVAL host.localdomain/cuda-00000000:0A:00.0/memory-memory_used interval=10 N:4461
PUTVAL host.localdomain/cuda-00000000:0A:00.0/power-power_draw interval=10 N:38.54
```

## Configuration

Please see [collectd-cuda.sh](./collectd-cuda.sh) for configuration options.
