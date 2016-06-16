source('framework/data.R')
source('framework/backtester.R')
source('framework/processResults.R')

# Read in data
dataList <- getData(directory="A2")

# Choose strategy
strategyFile <-'strategies/a2_template.R'

cat("Sourcing",strategyFile,"\n")
source(strategyFile) # load in getOrders

# Strategy parameters 
params <- list()

print("Parameters:")
print(params)

# Do backtest 
results <- backtest(dataList,getOrders,params,sMult=0.2)
pfolioPnL <- plotResults(dataList,results)
