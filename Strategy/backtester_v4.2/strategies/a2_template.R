getOrders <- function(store, newRowList, currentPos, params) {

    allzero  <- rep(0,length(newRowList)) # used for initializing vectors

    ################################################
    # You do not need to edit this part of the code
    # that initializes and updates the store
    ################################################
    if (is.null(store)) 
        store <- initStore(newRowList)
    else
        store <- updateStore(store, newRowList)
    ################################################
	
    pos <- allzero

    ################################################
    # This next code section is the only one you
    # need to edit for getOrders
    #
    # The if condition is already correct:
    # you should only start computing the moving 
    # averages when you have enough close prices 
    # for the long moving average 
    ################################################
    if (store$iter > params$lookbacks$long) {
        # ENTER STRATEGY LOGIC HERE

        # You will need to get the current_close
        # either from newRowList or from store$close

        # You will also need to get close_prices 
        # from store$cl

        # With these you can use getTMA, getPosSignFromTMA
        # and getPosSize to assign positions to the vector pos
    }

    ################################################
    # You do not need to edit this part of the code
    # that initializes and updates the store
    ################################################
    marketOrders <- -currentPos + pos

    return(list(store=store,marketOrders=marketOrders,
	                    limitOrders1=allzero,limitPrices1=allzero,
	                    limitOrders2=allzero,limitPrices2=allzero))
}

########################################################################
# The following function should be edited to complete steps 1 to 3
# of comp22 assignment 2

getTMA <- function(close_prices, lookbacks) {

    # close_prices should be an xts with a column called "Close"

    # lookbacks should be list with exactly three elements:
    # lookbacks$short  is an integer
    # lookbacks$medium is an integer
    # lookbacks$long   is an integer

    # It should be the case that:
    # lookbacks$short < lookbacks$medium < lookbacks$long

    ####################################################################
    # First we implement checks on the arguments

    # Replace TRUE to
    # check that lookbacks contains named elements short, medium and long
    if (TRUE)
        stop("E01: At least one of \"short\", \"medium\", \"long\" is missing from names(lookbacks)")

    # Replace TRUE to
    # check that the elements of lookbacks are all integers
    if (TRUE)
        stop("E02: At least one of the lookbacks is not an integer according to is.integer()")

    # Replace TRUE to
    # check that lookbacks$short < lookbacks$medium < lookbacks$long
    if (TRUE) 
        stop("E03: The lookbacks do not satisfy lookbacks$short < lookbacks$medium < lookbacks$long")
         
    # Replace TRUE to
    # check that close_prices is an xts
    if (TRUE)
        stop("E04: close_prices is not an xts according to is.xts()")

    # Replace TRUE to
    # check that close_prices has enough rows
    if (TRUE)
        stop("E05: close_prices does not enough rows")

    # Replace TRUE to
    # check that close_prices contains a column called "Close"
    if (TRUE)
        stop("E06: close_prices does not contain a column \"Close\"")

    ret <- 0

    # You need to replace the assignment to ret so that the 
    # returned object:
    #    - is a list 
    #    - has the right names (short, medium, long), and
    #    - contains numeric and not xts objects
    #    - and contains the correct moving average values, which should 
    #      have windows of the correct sizes which should all end in the 
    #      same period which should be the last row of close_prices


    return(ret)

}

getPosSignFromTMA <- function(tma_list) {
    # This function takes a list of numbers tma_list 
    # with three elements called short, medium, and long.

    # These three numbers correspond to the SMA values for 
    # a short, medium and long lookback, respecitvely.

    # Note that if both this function and get TMA 
    # are correctly implemented then the 
    # following should work if the inputs close_prices 
    # and lookbacks are of the correct form:
    # getPositionFromTMA(getTMA(close_prices,lookbacks))

    # This function should return a single number that is:
    #        1 if the short SMA < medium SMA < long SMA
    #       -1 if the short SMA > medium SMA > long SMA
    #        0 otherwise

    return(0)
}

getPosSize <- function(current_close,constant=1000) {
    # This function should return (constant divided
    # by current_close) rounded down to the nearest 
    # integer, i.e., due the quotient and then take 
    # the floor.
    return(0)
}

getInSampleResult <- function() {
    # Here you should replace the return value 0 with
    # the PD ratio for the following lookbacks
    # short: 10
    # medium: 20
    # long: 30
    # when the strategy is run on your 
    # username-specific in-sample period
    # DO NOT PUT THE ACTUAL CODE TO COMPUTE THIS RETURN VALUE HERE
    return(0)
}

getInSampleOptResult <- function() {
    # Here you should replace the return value 0 with
    # the best PD ratio that can be found for the pre-defined
    # parameter ranges 
    # (see the Assignment 2 handout for details of those ranges)
    # and your username-specific in-sample period
    # DO NOT PUT THE ACTUAL CODE TO COMPUTE THIS RETURN VALUE HERE
    return(0)
}

########################################################################
# The functions below do NOT need to be edited for comp226 assignment 2

initClStore  <- function(newRowList) {
  clStore <- lapply(newRowList, function(x) x$Close)
  return(clStore)
}
updateClStore <- function(clStore, newRowList) {
  clStore <- mapply(function(x,y) rbind(x,y$Close),clStore,newRowList,SIMPLIFY=FALSE)
  return(clStore)
}
initStore <- function(newRowList,series) {
  return(list(iter=1,cl=initClStore(newRowList)))
}
updateStore <- function(store, newRowList) {
  store$iter <- store$iter + 1
  store$cl <- updateClStore(store$cl,newRowList) 
  return(store)
}
