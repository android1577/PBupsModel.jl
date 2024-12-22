using PBupsModel
using MAT

dt = 0.02

# read test data file
ratdata = matread("ratfile.mat")

train_data, test_data = split_trials_by_parity(ratdata, "even")

# using TrialData load trial data
RightClickTimes, LeftClickTimes, maxT, rat_choice = TrialData(train_data["rawdata"], 1)

Nsteps = Int(ceil(maxT/dt))

# known parameter set (9-parameter)
args = ["sigma_a","sigma_s_R","sigma_i","lambda","B","bias","phi","tau_phi","lapse_R"]

# Compute Loglikelihood value of many trials
ntrials = train_data["total_trials"]

# Model Optimization
init_params = init_params = InitParams(args)
result = ModelFitting(args, init_params, ratdata, ntrials)
FitSummary(mpath, fname, result)

# Calculate eval
args_dict = Dict(zip(args, result["x_bf"]))
args_symbols = Dict(Symbol(k) => v for (k, v) in args_dict)

ntesttrials = test_data["total_trials"] # Might be off by one from ntrials because of odd total trials
LLs = SharedArray(Float64, ntesttrials)
LL_total = ComputeLL(LLs, test_data["rawdata"], ntesttrials; args_symbols...)
eval = exp(-sum(LL_total)/ntesttrials)
