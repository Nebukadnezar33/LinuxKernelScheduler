# LinuxKernelScheduler
Linux Kernel Scheduler for CS350 class.
# CS350 Part 2: Linux Scheduler Benchmark

## Project Overview
We benchmark three Linux scheduling policies (FIFO, RR, CFS) across three workloads (CPU-bound, I/O-bound, mixed) using `perf`, `strace` and `ftrace`, then analyze the results with Python.

## Prerequisites
- Ubuntu/Debian Linux
- Bash shell
- Python 3.7+
- pip

## Setup
```bash
# araçları kur
./setup_env.sh
# Python paketlerini kur
pip install -r requirements.txt
# çalıştırma izinlerini ver
chmod +x run_experiments.sh analyze_results.py
