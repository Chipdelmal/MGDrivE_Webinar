###############################################################################
#   Homing Drive Example with Epidemiological Output 
#   Author: Agastya Mondal
###############################################################################
rm(list=ls())
if(any(!is.na(dev.list()["RStudioGD"]))){dev.off(dev.list()["RStudioGD"])}
###############################################################################
# Loading Libraries and Setting Paths Up
###############################################################################
library(MGDrivE); library(MGDrivE2); library(ggplot2)
# Get script path and directory -----------------------------------------------
fPath = rstudioapi::getSourceEditorContext()$path 
dirname = dirname(fPath); basename = basename(fPath)
# Set working directory to one above script's location ------------------------
setwd(dirname); setwd('..')
FLD_OUT = tools::file_path_sans_ext(basename)
# Load constants shared across the session ------------------------------------
source("./demos/constants.R")
# Setup output folder and delete CSV files in it ------------------------------
PTH_OUT = file.path(GLB_PTH_OUT, FLD_OUT)
unlink(file.path(PTH_OUT), recursive=TRUE)
dir.create(path=PTH_OUT, recursive=TRUE, showWarnings=FALSE)

# basic homing drive
cube <- MGDrivE::cubeHomingDrive()

# default set of parameters for Gambiae and a 1000-person population
theta <- MGDrivE2::imperial_model_param_list_create()

# setup age structure
age_vector <- c(0, 11 / 12, 1, 4, 5, 14, 15, 59, 60)

# percentage of symptomatic cases that get treatment
ft <- 0.10 

# intervention parameters
IRS_cov <- 0.05
LLIN_cov <- 0.05
theta <- add_interventions(theta, IRS_cov, LLIN_cov)

SPN_P <- spn_P_epi_decoupled_node(params = theta, cube = cube)
SPN_T <- spn_T_epi_decoupled_node(spn_P = SPN_P,
                               params = theta,
                               cube = cube)
# Stoichiometry matrix
S <- spn_S(spn_P = SPN_P, spn_T = SPN_T)

# baseline EIR
eir <- 10

# calculate human and mosquito equilibrium
# this function updates theta and the cube and returns initial conditions
eqm <- equilibrium_Imperial_decoupled(age_vector, ft, eir, theta, cube, SPN_P)

# extract updated theta and full set of initial conditions
theta <- eqm$theta

# modify cube with transmission blocking
theta$b0[grep(pattern = "H",x = names(theta$b0))] <- 0
cube <- eqm$cube
initialCons <- eqm$initialCons

# set up hazard functions
approx_hazards <- spn_hazards_decoupled(spn_P = SPN_P, spn_T = SPN_T, cube = cube,
                              params = theta, type = "Imperial",
                              log_dd = TRUE, exact = FALSE, tol = 1e-8,
                              verbose = FALSE)

# set up releases
r_times <- seq(from = 0,
                length.out = 8,
                by = 7)
r_size <- 50000

events <- data.frame(
    "var" = paste0("M_", cube$releaseType),
    "time" = r_times,
    "value" = r_size,
    "method" = "add",
    stringsAsFactors = FALSE
)

# simulation 
dt <- 1
dt_stoch <- 0.05

tau_out <- sim_trajectory_R_decoupled(
  x0 = initialCons$M0,
  h0 = initialCons$H,
  SPN_P = SPN_P,
  theta = theta,
  tmax = 150,
  inf_labels = SPN_T$inf_labels,
  dt = dt,
  dt_stoch = dt_stoch,
  S = S,
  hazards = approx_hazards,
  sampler = "tau-decoupled",
  events = events,
  verbose = FALSE,
  human_ode = "Imperial",
  cube = cube
)

# summarize females/humans by genotype
tau_female <- summarize_females_epi(out = tau_out$state, spn_P = SPN_P)
tau_humans <- summarize_humans_epiImperial(out = tau_out$state, index=1)

# plot
ggplot(data = tau_female) +
  geom_line(aes(x = time, y = value, color = inf)) +
  facet_wrap(~ genotype, scales = "free_y") +
  theme_bw() +
  ggtitle("SPN: Tau-leaping Decoupled Approximation - Mosquito")
ggplot(data = tau_humans) +
  geom_line(aes(x = time, y = value, color = inf)) +
  facet_wrap(~ genotype, scales = "free_y") +
  theme_bw() +
  ggtitle("SPN: Tau-leaping Decoupled Approximation - Human")
