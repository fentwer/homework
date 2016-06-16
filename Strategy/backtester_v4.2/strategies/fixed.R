# This strategy uses only market orders (and only in the first period).
# It takes a position in the first period and holds it for the duration.
# The backtester automatically exits all positions as market orders at the end.

getOrders <- function(store, newRowList, currentPos, params) {

    allzero      <- rep(0,length(newRowList)) 
    marketOrders <- allzero

    if (is.null(store)) { 
        # take position during first iteration and hold
        marketOrders <- params$sizes
        store <- 1 # not null
    }
    return(list(store=store,marketOrders=marketOrders,
	                        limitOrders1=allzero, 
	                        limitPrices1=allzero,
	                        limitOrders2=allzero,
	                        limitPrices2=allzero))
}
