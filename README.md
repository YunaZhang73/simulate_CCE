# Simulations of polygenic adaptation to gradually changing environments

We simulated quantitative traits in the face of gradually changing environments which were treated as optimum shifts.

Simulations are based on the Wright-Fisher model, in which generations are discrete and non-overlapping (in each generation the entire population is replaced by the new offspring from the previous parental generation). The population is diploid and randomly mating.

The simulations were performed by SLiM 4.


## Simulation setting

### General parameters
- Fixed population size: 
`N = 10,000`
- Genome length: 
`geno_len = 1e6`
- Recombination rate per site per generation: 
`recombination_rate = 5e-8`
- Mutation rate per site per generation: 
`mutation_rate = 7e-10`,
10% mutations (assuming the total mutation rate is 7e-9) are non-neutral
- Assume only additive effect between alleles, thus the dominance coefficient: 
`h = 0.5`

### Distributions of effect sizes of new mutations (sd_mutation)

We draw effect sizes of new non-neutral mutations from normal distributions:

The mean of the distribution is `mu_mutation = 0`

The standard deviation was set as: 
`sd_mutation = 
0.05,
0.1,
0.5
`

### Strength of stabilizing selection (Vs)
`Vs =
1,
10,
100
`
### Time (generation):
- Simulate the first `10*N` generations to make sure that the population reaches equilibrium under stabilizing selection, the optimum `initial_optimum = 0`. This period is called the fix-optimum phase or burn-in period.
- Simulate the second `10*N` generations when the optimum gradually increases at a constant speed over time. This period is called the moving-optimum phase.


### Optimum shifts
The optimum increases after the fix-optimum phase at a constant speed per generation: `speedCoef * sqrt(VG)`

- `speedCoef` for different parameter combinations:

		Vs sdMutation speedCoef ...
		1 0.05 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.35 0.38 0.39 0.4 0.5 0.53 0.55 0.8 1 1.2 1.4 1.5 1.6 1.7
		1 0.1 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 1 1.1 1.2 1.3 1.6 1.65 2.2 2.8 2.9 3 3.2 3.4 3.6 3.8 4
		1 0.5 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 1 2 3 6.5 10 11 12 12.5 13.5 14 15 16 17 18 18.2 20 20.5 21 21.5 22
		10 0.05 0.002 0.005 0.01 0.02 0.05 0.07 0.08 0.09 0.1 0.11 0.2 0.3 0.4 0.5 0.6
		10 0.1 0.002 0.005 0.01 0.02 0.05 0.1 0.15 0.18 0.2 0.22 0.23 0.24 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
		10 0.5 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 1 1.3 2.3 2.32 2.35 2.4 3.3 3.35 4.3 4.5 4.6 4.9 5 5.2 5.4 6 6.5 7
		100 0.05 0.002 0.005 0.01 0.02 0.025 0.03 0.031 0.035 0.04 0.05 0.1 0.2 0.3 0.4
		100 0.1 0.002 0.005 0.01 0.02 0.03 0.04 0.045 0.05 0.055 0.057 0.1 0.2 0.3 0.4 0.5
		100 0.5 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.35 0.38 0.39 0.4 0.5 0.52 0.55 0.7 0.9 1.1 1.3 1.4 1.5 1.6 1.7
		
- `VG`, the equilibrium genetic variance (same as phenotypic variance since phenotype is completely dependent on genetic effect) under stabilizing selection, was counted by the mean genetic variance of the last 1000 generations in the first 10-N phase and the 100 replicates. `VG` is listed as follows:

		Vs sdMutation SSE_VG
		1 0.05 0.0029300177489
		1 0.1 0.0029996286771
		1 0.5 0.00296582998997
		10 0.05 0.020313248124
		10 0.1 0.028240459227
		10 0.5 0.028907480927
		100 0.05 0.052245441294
		100 0.1 0.133176793742
		100 0.5 0.30291034998

- Thus, the new optimum at a certain generation is `new_optimum = speedCoef * sqrt(VG) * (sim.cycle - 10 * N)`, where `sim.cycle` is the current generation

### Simulation runs
Simulation runs 100 times independently for each `Vs & sd_mutation` combination and each `speedCoef`. Same replicate number means the same burn-in population in the face of different speeds of optimum shift.


## Scripts

The [simulation](./) folder includes subdirectories [code](./code/), [data](./data/) and figures ([output](./output/)). 
The [run_simulation.Rmd](./code/run_simulation.Rmd) file includes the scripts for setting up and run the simulations.

1. Run "burn-in" to get an equilubrium population with [burnin.slim](./code/burnin.slim)
        
2. Run "optimum shift" with [sudden.slim](./code/sudden.slim)


### Run simulations with different parameter combinations on cluster

Each trait (parameter combination) has a directory named `Vs[Vs]sd[sd_mutation]`, in which `burnin.sh` and `sudden.sh` are the scripts for calling burnin.slim and sudden.slim, separately.

    sbatch Vs[Vs]sd[sd_mutation]/burnin.sh
    sbatch Vs[Vs]sd[sd_mutation]/sudden.sh


## Data
Results include phenotype, fitness, segregating mutations and fixed mutations.

The mean and variance of phenotype and fitness at each generation are recorded in `stats_[replicate].txt` (under "burn_in" directory) and `stats_[speedCoef]_[replicate].txt` (under "gradual" directory).  The same naming rule for `muta_*`, `pheno_*`, `fixedMuta_*`, `population10N_*` and `population20N_*` files.

The replicate number is from 1 to 100. For those simulations with a very fast optimum shift, population might go extinct at some point between 10N to 20N generation. In these cases, `fixedMuta_*` files, which only record data at the end of simulation time, are not generated.


### Data files description

#### stats_*.txt

Summary statistics at the phenotypic level in each generation

Fields:

	1. replicate number, each replicate is an independent simulation
	2. generation
	3. mean phenotypic value of the population
	4. phenotypic variance of the population
	5. mean fitness of the population
	6. the variance of fitness of the population

#### pheno_*.txt

Record individual phenotype every 500 generations (every 10 generations during the last 1000 generations in burn-in and first 1000 generations in moving-optimum period).

Fields:

	1. replicate number
	2. generation
	3. individual phenotypic value
	4. individual fitness
	5. number of offSprings (not corresponding)

#### muta_*.txt

Record segregating sites every 500 generations (every 10 generations during the last 1000 generations in burn-in and first 1000 generations in moving-optimum period).

Fields:

	1. replicate number
	2. generation
	3. mutation id
	4. position
	5. allelic frequency
	6. effect size
	7. generation when the mutation arises

#### fixedMuta_*.txt

Record fixed mutations in the end of 10 N and 20 N generations.

Fields:

	1. replicate number
	2. mutation id
	3. position
	4. effect size
	5. generation when the mutation arises
	6. generation when the mutation is fixed

#### population*.txt

Record whole information about the population in the 10 N and 20 N generation, so that SLiM can continue to run the simulation from that time.
