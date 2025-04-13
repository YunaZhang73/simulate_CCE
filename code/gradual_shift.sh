#!/bin/bash -l
#SBATCH -D /scratch/yzhang44/B6/simulation/  # working directory
#SBATCH --nodes=1 # request one node
#SBATCH --time=50:00:00
#SBATCH --ntasks=1
#SBATCH --mem=300Mb # memory resource can be requested per node
#SBATCH --array 0-99
# everything below this line is optional, but are nice to have quality of life things
#SBATCH --mail-type=ALL # if you want emails, otherwise remove
#SBATCH --account=ag-stetter
#SBATCH --mail-user=yzhang44@uni-koeln.de # receive an email wiht updates
#SBATCH --error /scratch/yzhang44/logs/errors/arrays_trial_%j.err # tell it to store the eroor log console text to a file called job.<assigned job number>.err
#SBATCH --output=/scratch/yzhang44/logs/job.%J.out # tell it to store the output console text to a file called job.<assigned job number>.out

#SBATCH --job-name="shift" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers



### build environment
module load gnu/9.4.0

## define variables

Vs=1
sd_mutation=0.05
VG=0.3
speedCoef_ls=(0.5)

geno_len=999999
mutation_rate=7e-10
recombination_rate=5e-8
mu_mutation=0
N=10000
h=0.5
folder="/scratch/yzhang44/B6/simulation/"
export workfolder=$folder"Vs"$Vs"sd"$sd_mutation"/"

replicates=($(seq 1 1 100))

seeds=($(cat $workfolder"seeds_burnin.txt"))
SSE_fixed=($(cat $workfolder"SSE_fixed.txt"))


for i in {0..speedCoef_num}
do

slim -d seed=${seeds[$SLURM_ARRAY_TASK_ID]} -d replicate=${replicates[$SLURM_ARRAY_TASK_ID]} \
-d geno_len=$geno_len -d recombination_rate=$recombination_rate \
-d mutation_rate=$mutation_rate \
-d mu_mutation=$mu_mutation -d h=$h \
-d speedCoef=${speedCoef_ls[$i]} -d VG=$VG -d SSE_fixed=${SSE_fixed[$SLURM_ARRAY_TASK_ID]} \
-d N=$N \
-d sd_mutation=$sd_mutation \
-d Vs=$Vs gradual_shift.slim

done
