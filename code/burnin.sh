#!/bin/bash -l
#SBATCH -D /scratch/yzhang44/B6/simulation/  # working directory
#SBATCH --nodes=1 # request one node
#SBATCH --time=02:00:00 # ask that the job be allowed to run for 1 hour.
#SBATCH --ntasks=1 # ask for [number] cpus
#SBATCH --mem=100Mb # Maximum amount of memory this job will be given.
#SBATCH --array 0-99
# everything below this line is optional, but are nice to have quality of life things
#SBATCH --mail-type=ALL # if you want emails, otherwise remove
#SBATCH --account=UniKoeln
#SBATCH --mail-user=yzhang44@uni-koeln.de # receive an email with updates
#SBATCH --error /scratch/yzhang44/logs/errors/arrays_trial_%j.err # tell it to store the eroor log console text to a file called job.<assigned job number>.err
#SBATCH --output=/scratch/yzhang44/logs/job.%J.out # tell it to store the output console text to a file called job.<assigned job number>.out

#SBATCH --job-name="burnin" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers



### build environment
module load gnu/9.4.0

# define variables
geno_len=999999
mutation_rate=7e-10
recombination_rate=5e-8
mu_mutation=0
N=10000
h=0.5
initial_optimum=0
folder="/scratch/yzhang44/B6/simulation/"

sd_mutation=0.05
Vs=1
export workfolder=$folder"Vs"$Vs"sd"$sd_mutation"/"

replicates=($(seq 1 1 100))
seeds=($(cat $workfolder"seeds_burnin.txt"))

slim -d seed=${seeds[$SLURM_ARRAY_TASK_ID]} -d replicate=${replicates[$SLURM_ARRAY_TASK_ID]} \
-d geno_len=$geno_len -d recombination_rate=$recombination_rate \
-d mutation_rate=$mutation_rate \
-d mu_mutation=$mu_mutation -d h=$h \
-d initial_optimum=$initial_optimum \
-d N=$N \
-d sd_mutation=$sd_mutation \
-d Vs=$Vs burnin.slim
