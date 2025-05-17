# run_experiments.sh
# Farklı scheduler politikaları ve 3 iş yükü (CPU, I/O, Mixed) için
# perf istatistiklerini toplar ve results/ dizinine CSV olarak yazar.
set -e
mkdir -p results


for policy in fifo rr cfs; do
  echo "=== Policy: $policy ==="
  for workload in cpu io mixed; do
    echo "--- Running $workload under $policy ---"
    
    case "$workload" in
      cpu)
        yes > /dev/null &
        pid=$!
        ;;
      io)
        dd if=/dev/zero of=/tmp/io_test bs=1M count=1024 &>/dev/null &
        pid=$!
        ;;
      mixed)
        dd if=/dev/zero of=/tmp/io_test bs=1M count=512 &>/dev/null &
        pid1=$!
        yes > /dev/null &
        pid2=$!
        wait $pid1
        pid=$pid2
        ;;
    esac
    
    sleep 10 && kill -TERM $pid &

    # perf’le veri topla (cycles, instructions, ctx-switches)
    perf stat -x, -e cycles,instructions,context-switches -p $pid 2> results/${policy}_${workload}_perf.csv

    wait $pid 2>/dev/null || true
    echo "=> done: results/${policy}_${workload}_perf.csv"
  done
done
