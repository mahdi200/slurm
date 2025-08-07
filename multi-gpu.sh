#!/bin/bash
#SBATCH --job-name=gpu-burn
#SBATCH --output=gpu_burn.out
#SBATCH --error=gpu_burn.err
#SBATCH --partition=debug
#SBATCH --gres=gpu:4
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=8

# Start logging GPU usage
nvidia-smi --query-gpu=timestamp,index,utilization.gpu,power.draw,memory.used,temperature.gpu --format=csv -l 1 > gpu_log_$SLURM_JOB_ID.csv &
LOGGER_PID=$!

# Run gpu_burn on all GPUs for 60 seconds
cd ~/gpu-burn
./gpu_burn 60

# Stop GPU logger
kill $LOGGER_PID
