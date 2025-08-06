#!/bin/bash
#SBATCH --job-name=gpu-test
#SBATCH --partition=debug
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:01:00
#SBATCH --output=gpu_test.out

echo "Running on host: $(hostname)"
nvidia-smi
