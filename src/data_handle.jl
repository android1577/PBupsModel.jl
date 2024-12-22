# Rawdata Import
function LoadData(mpath, filename)
    # data import
    if contains(filename,".mat")
        ratdata = matread(joinpath(mpath,filename))
    else
        ratdata = matread(joinpath(mpath,*(filename,".mat")))
    end
    println("rawdata from ", filename, " imported" )
    
    # number of trials
    ntrials = size(ratdata["rawdata"]["leftbups"],2)

    return ratdata, ntrials
end

# Get Trial Data
function TrialData(rawdata, trial::Int)
    if rawdata["pokedR"][trial] > 0
        rat_choice = 1;  # "R" 
    else
        rat_choice = -1; # "L"
    end;

    if typeof(rawdata["rightbups"][trial]) <: Array
        rvec = vec(rawdata["rightbups"][trial])::Array{Float64,1};
    else
        rvec = Float64[rawdata["rightbups"][trial]] 
    end
    if typeof(rawdata["leftbups"][trial]) <: Array
        lvec = vec(rawdata["leftbups"][trial])::Array{Float64,1};
    else
        lvec = Float64[rawdata["leftbups"][trial]] 
    end

    return rvec, lvec,
    rawdata["T"][trial]::Float64, rat_choice
end

# Write File
function WriteFile(mpath, filename, D)
   saveto_filename = joinpath(mpath,*("julia_out_",filename))
   matwrite(saveto_filename, D)
end

# Parity Split
function split_trials_by_parity(data::Dict{String,Any}, parity::String)
    total_trials = Int(data["total_trials"])
    rawdata = data["rawdata"]

    if parity == "even"
        train_indices = 1:2:total_trials
        test_indices = 2:2:total_trials
    elseif parity == "odd"
        train_indices = 2:2:total_trials
        test_indices = 1:2:total_trials
    else
        error("Invalid parity choice. Must be 'even' or 'odd'.")
    end

    train_data = Dict("total_trials" => length(train_indices), 
                       "rawdata" => Dict(k => v[train_indices] for (k,v) in rawdata))
    test_data = Dict("total_trials" => length(test_indices),
                      "rawdata" => Dict(k => v[test_indices] for (k, v) in rawdata))

    return train_data, test_data
end
