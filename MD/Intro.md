# Introduction to MGDrivE



## Modules

### Life-History

MGDrivE's life-history structure is based on [Hancock and Godfray (2007)](https://malariajournal.biomedcentral.com/articles/10.1186/1475-2875-6-98) with extended structures to accommodate an arbitrary number of genotypes throughout the development of simulated mosquitos.

**Aquatic Stages:** Individuals go through three aquatic stages: egg, larva, and pupa; with the density-dependence taking place in the larval stage.
**Adult Stages:** Male individuals are counted and aggregated by their genotypes, whereas female adults store both their genotype and the genotype of the male they mated with.


![](https://besjournals.onlinelibrary.wiley.com/cms/asset/b5aa706c-4c3f-462b-aed4-a107a6494554/mee313318-fig-0002-m.jpg)

### Landscape

**Migration**

**Batch Migration**

### Inheritance (cubes)

**Inheritance patterns**

![](https://marshalllab.github.io/MGDrivE/images/crispr.jpg)

**Fitness costs**

* `s`: Genotype-specific fractional reduction(increase) in fertility
* `eta`: Genotype-specific mating fitness
* `phi`: Genotype-specific sex ratio at emergence
* `xiF`: Genotype-specific female pupatory success
* `xiM`: Genotype-specific male pupatory success
* `omega`: Genotype-specific multiplicative modifier of adult mortality


