"""
A package for fitting data from auditory evidence accumulation task (Poisson clicks task) 
to evidence accumulation model.
"""
__precompile__()

module PBupsModel

# 3rd party
import Base.convert

using MAT
using ForwardDiff
using Optim
using GeneralUtils

import ForwardDiff.DiffBase
# using DiffBase

export 
    
# data_handle
    LoadData,
    TrialData,
    WriteData,
    split_trials_by_parity,

# model_likelihood 
    logProbRight,
    LogLikelihood, 

# all_trials
    ComputeLL,
    ComputeLL_bbox,
    ComputeGrad,
    ComputeHess,
    TrialsLikelihood,

# optimization
    InitParams,
    ModelFitting,
    FitSummary

include("data_handle.jl")
include("model_likelihood.jl")
include("all_trials.jl")
include("model_optimization.jl")

end # module
