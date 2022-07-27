#!/usr/bin/env bash

# script usage
usage() {
    cat <<USAGE
Usage: $0 [-n name_cron] [-s /opt/cronscritps/example.sh]
Options:
    -n, --name:     (required) cron job name suffix with '_cron'. Example: name_cron
    -s, --script:   (required) path to the cron job script
USAGE
    exit 1
}

# show uage if no arguments provided
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

# parse flag variables
while [ "$1" != "" ]; do
    case $1 in
    -n | --name)
        shift
        name=$1
        ;;

    -s | --script)
        shift
        script=$1
        ;;

    -h | --help)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

# check for name and script arguments
if [[ -z "$name" || -z "$script" ]]; then
    echo "ERROR: Missing arguments.";
    usage
    exit 1;
fi

write_to_file() {
    #create a temporary file
    local tmpf="${1}_$(< /dev/urandom tr -dc A-Za-z0-9 | head -c16)"
    #redirect the result
    cat > $tmpf
    #replace the original file
    mv -f $tmpf "${1}"
}

get_exporter_file() {
    local exporter_file_path="/var/tmp/prometheus"
    # check and create exporter_file_path dir
    [ ! -d "$exporter_file_path" ] &&  mkdir -pm 777 "$exporter_file_path"
    echo "${exporter_file_path}/${cron_job_name}.prom"  
}

# start time in seconds
start=$(date +%s)
# name of the job
cron_job_name="$name"
# path to script
cron_job_script="$script"


# Run the script.
if [[ ! -x "$script" || -d "$script" ]]; then
    echo "ERROR: Can't find script for '$cron_job_name'. Aborting."
    cron_job_exit_code=2
else 
    bash "$script" 2>&1 >/dev/null
    # Get results and clean up.
    cron_job_exit_code=${PIPESTATUS[0]}
fi

# set values for prometheus metrcis
cron_job_finish_time=$(date +%s)
cron_job_duration=$(( cron_job_finish_time - start ))
exporter_file=$(get_exporter_file)

# prometheus cron job metrics
output="
# HELP cron_job_exitcode Exit code of cron job.
# TYPE cron_job_exitcode gauge
cron_job_exitcode{name=\"$cron_job_name\"} $cron_job_exit_code
# HELP cron_job_finish_time The time latest cron job finished.
# TYPE cron_job_finish_time gauge
cron_job_finish_time{name=\"$cron_job_name\"} $cron_job_finish_time
# HELP cron_job_duration_seconds Duration of latest cron job run in seconds.
# TYPE cron_job_duration gauge
cron_job_duration_seconds{name=\"$cron_job_name\"} $cron_job_duration
"

# write metrcis to exporter file
echo "$output" | write_to_file $exporter_file 
