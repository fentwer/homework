source('framework/data.R')
source('framework/backtester.R')
source('framework/processResults.R')

# Read in data
dataList <- getData(directory="EXAMPLE")

# Choose strategy
strategyFile <-'strategies/fixed.R'
# strategyFile <-'strategies/copycat.R'
# strategyFile <-'strategies/bbands.R'
# strategyFile <-'strategies/a2_template.R'

cat("Sourcing",strategyFile,"\n")
source(strategyFile) # load in getOrders

# Strategy parameters 
params <- list(sizes=rep(1,5)) # fixed
# params <- NULL # copycat
# params <- list(lookback=20,sdParam=1.5,series=1:4,posSizes=rep(1,10)) # bbands
# params <- list(lookback=50,sdParam=1.5,
                   #series=c(1,3,5,7,8,9),posSizes=rep(1,10))

print("Parameters:")
print(params)

# BACKTEST PARAMETERS ##########################
# split data in two (e.g. for in/out test)

inSampDays <- 200 
# in-sample period
dataList <- lapply(dataList, function(x) x[1:inSampDays])

# out-of-sample period
# numDays <- nrow(dataList[[1]])
# dataList <- lapply(dataList, function(x) 
#                               x[(inSampDays+1):numDays)

# Do backtest 
results <- backtest(dataList,getOrders,params,sMult=0.2)
pfolioPnL <- plotResults(dataList,results)


#params <- list(sizes=c(1,2,0,0,-1)) 
#source('framework/utilities.R'); 
#backtestAndPlot(path='images','main_fixed_params2')

