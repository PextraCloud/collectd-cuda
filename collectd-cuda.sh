#!/bin/bash
# Copyright (C) 2017 Kamil Wilczek, 2024 Pextra Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

### CONFIG ###
# Format: ["query_string"]=value_type
#
# To get list of available parameters,
# run 'nvidia-smi --help-query-gpu'.
# Replace each '.' with  '_'.
#
declare -A config=(
	["temperature_gpu"]=temperature
	["fan_speed"]=percent
	["pstate"]=absolute
	["memory_used"]=memory
	["memory_free"]=memory
	["utilization_gpu"]=percent
	["utilization_memory"]=percent
	["power_draw"]=power
)
### END CONFIG ###

readonly HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname --fqdn)}"
readonly INTERVAL="${COLLECTD_INTERVAL:-10}"
readonly SCRIPTDIR="$(dirname "${0}")"

error() {
	echo "$@" 1>&2
}

# Check nvidia-smi
nvidia-smi &> /dev/null
if [ $? -ne 0 ]; then
	error "nvidia-smi unusable"
	exit 1
fi

query_string="pci.bus_id,"
for parameter in "${!config[@]}"; do
	query_string+="${parameter//_/.},"
done

# Query nvidia-smi
gpus_state=$(nvidia-smi --query-gpu="${query_string%,}" --format=csv,noheader,nounits)

# Output collectd PUTVAL commands
while IFS=',' read -r gpu_id "${!config[@]}"; do
	for parameter in "${!config[@]}"; do
		echo "PUTVAL ${HOSTNAME}/cuda-${gpu_id}/${config[$parameter]}-${parameter} interval=$INTERVAL N:${!parameter//P}"
	done
done <<< "${gpus_state// }"
