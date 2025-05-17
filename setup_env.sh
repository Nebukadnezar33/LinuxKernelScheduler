set -e

echo "==> Updating & installing tools"
sudo apt update
sudo apt install -y linux-tools-common linux-tools-$(uname -r) strace

echo "==> Setting perf permissions"
sudo sysctl -w kernel.perf_event_paranoid=-1
sudo sysctl -w kernel.kptr_restrict=0

echo "==> Mounting ftrace"
sudo mount -t tracefs nodev /sys/kernel/debug/tracing || true

echo "Done."
