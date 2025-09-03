#!/bin/bash
#SBATCH -J gpu_burn
#SBATCH -p main
#SBATCH -o gpu_burn.%j.out
#SBATCH -e gpu_burn.%j.err
#SBATCH -N 1
#SBATCH --gres=gpu:1          # start with 1; raise to 8 once it works
#SBATCH --cpus-per-task=4
#SBATCH -t 00:05:00

set -euo pipefail
NGPU=${SLURM_GPUS:-${SLURM_GPUS_ON_NODE:-1}}
#echo "Allocated GPUs: $NGPU  CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"

# telemetry logger
LOG=gpu_telemetry_${SLURM_JOB_ID}.csv
nvidia-smi --query-gpu=timestamp,index,utilization.gpu,power.draw,memory.used,temperature.gpu \
           --format=csv,noheader -l 1 > "$LOG" &
LOGGER_PID=$!
trap 'kill $LOGGER_PID 2>/dev/null || true' EXIT

cd "$HOME/gpu-burn"
srun -n "$NGPU" --gpus-per-task=1 ./gpu_burn 60
