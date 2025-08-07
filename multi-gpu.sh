#!/bin/bash
#SBATCH --job-name=multi-gpu-test
#SBATCH --output=multi_gpu_test.out
#SBATCH --error=multi_gpu_test.err
#SBATCH --partition=debug
#SBATCH --gres=gpu:4          # Use 4 GPUs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time=00:05:00

echo "Running on $(hostname)"
echo "SLURM_JOBID = $SLURM_JOB_ID"

# Start GPU logging in background
nvidia-smi --query-gpu=timestamp,index,name,utilization.gpu,power.draw,memory.used,memory.total,temperature.gpu --format=csv -l 1 > gpu_utilization_$SLURM_JOB_ID.csv &

# Save the PID so we can kill it later
LOGGER_PID=$!

# Dummy GPU workload (replace with your real workload)
/usr/local/cuda/samples/5_Simulations/nbody/nbody -benchmark -numbodies=256000

# Stop the GPU logger
kill $LOGGER_PID

echo "Job completed."
