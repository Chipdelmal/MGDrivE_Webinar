# Introduction to MGDrivE



## Modules

MGDrivE is structured in three main modules:

* [Life-History](#life-history) deals with the life-stages that mosquitoes go through in their development (egg, larva, pupa, and adults)
* [Inheritance](#inheritance) controls the way genes get inherited from parents to offspring
* [Landscape](#landscape) determines the setting in which individuals will develop and migrate

which connect to each other to generate our simulations.

### Life-History

MGDrivE's life-history structure is based on [Hancock and Godfray (2007)](https://malariajournal.biomedcentral.com/articles/10.1186/1475-2875-6-98) with extended structures to accommodate an arbitrary number of genotypes throughout the development of simulated mosquitos.

**Aquatic Stages:** Individuals go through three aquatic stages: egg, larva, and pupa; with the density-dependence taking place in the larval stage.
**Adult Stages:** Male individuals are counted and aggregated by their genotypes, whereas female adults store both their genotype and the genotype of the male they mated with.


![](https://besjournals.onlinelibrary.wiley.com/cms/asset/b5aa706c-4c3f-462b-aed4-a107a6494554/mee313318-fig-0002-m.jpg)


### Inheritance

**Inheritance patterns**

![](https://marshalllab.github.io/MGDrivE/images/crispr.jpg)

**Fitness costs**

* `s`: Genotype-specific fractional reduction(increase) in fertility
* `eta`: Genotype-specific mating fitness
* `phi`: Genotype-specific sex ratio at emergence
* `xiF`: Genotype-specific female pupatory success
* `xiM`: Genotype-specific male pupatory success
* `omega`: Genotype-specific multiplicative modifier of adult mortality


### Landscape

Finally, the landscape can generally be thought of as a network of panmictic (fully-mixing) populations in which mosquitoes can migrate according to the distances and movement probabilities.


**Migration**


![](https://besjournals.onlinelibrary.wiley.com/cms/asset/d6bd6851-bb6e-492d-a0d8-d6e8a2e71973/mee313318-fig-0003-m.jpg)


**Batch Migration**

This component takes into account the scenario in which a group of mosquitoes can "travel" from one population to another without any distance relationship between the aforementioned nodes (to simulate cases in which mosquitoes can hitchhike in barges or trucks).