charToDigit <- function(string,i,const)
    (i+const)*strtoi(substr(string,start=i,stop=i),36L)

getDigits <- function(string,const) 
    sapply(1:nchar(string),function(x) charToDigit(string,x,const))
 
library(digest)
getInSamplePeriod <- function(user) {
    dig <- digest(user,'crc32')
    startIn <- round(sum(getDigits(dig,0)))
    endIn <- round(sum(getDigits(dig,9)))
    return(c(startIn,endIn))
}
# example: getInSamplePeriod('x2jw2')
# example: getInSamplePeriod('u3ab1')
