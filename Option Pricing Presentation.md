Option Pricing Application 
========================================================
author: Scott Oetting
date: September 17, 2014
font-family: 'Helvetica'




Option Pricing Application
========================================================
- <small>Stock Options are popular financial instruments as purchasing one allows the buyer to benefit from the appreciation or decline in a stock's price over a designated time period. 
- However, the price of such options are not easy to calculate as they are based on seven different variables.
- This application allows the easy entry of these variables and calculates the theoretical value of the option on a non-dividend paying stock using the valuation methodology was developed by [Bjeksund and Stenslaud][#1].
- This value is determined by using the BSAmericanApproxOption() which is part of the [fOptions Package](http://cran.r-project.org/web/packages/fOptions/fOptions.pdf).

<small>[#1]:Bjerksund P., Stensland G. (1993); Closed Form Approximation of American Options, Scandinavian Journal of Management 9, 87-99.</small></small>

Variables Impacting the Option Price
========================================================
- <small>The type of option
    + <small>A **Call** option is when the buyer wants to buy the stock</small>
    + <small>A **Put** option is when the buyer wants to sell the stock</small>
- The price of the stock at the time the option is purchased
- The time until expiration.
- The strike price - what price to buy or sell the stock at the expiration date
- The volatility of the stock
- The current risk-free interest rate.
- The carry interest rate (the rate that the buyer can borrow at).</small>

Stock Option Calculation Example
========================================================
<small>Here is a example for the pricing of a call option with an expiration date in one-half a year and a strike price of $11 for a stock which has a current price of $10 and a volatility value of 20% when the current risk-free interest rate is 2% and the buyer's carried interest rate is 5%.</small>


```r
library(fOptions)
library(scales)
BSAmericanApproxOption(TypeFlag = "c", 
    S = 10, X = 11, Time = .5, 
    r = .02, b = .05, sigma = .20 )
```

<small>The calculated value of this option is ***``$0.30``***.  
<small>_*Note: The output from the function BSAmericanApproxOption() is fairly lengthly and is not included as it will not fit of the slide.*_</small></small>

Other Features of this Application
========================================================

<small>This application will also create two plots:

1. A Payout Plot comparing the Profit or Loss from purchasing this option to the stock's price at the time of expiration.
2. An Option Valuation chart comparing the option's value over a range of values of one the input variables (which can be selected by the user).</small>


