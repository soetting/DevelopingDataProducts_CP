Options Pricing Application - User Instructions
===============================================

This application will calculate the value of a standard stock option on a non-dividend paying stock. 

There are numerous methods to calculate such values and this applications uses the approximation method developed by 
Bjorksund and Strensland. This methodology is utilized for the BSAmericanApproxOption function which is part of the 
fOptions package support on cran (for more detail on this package, please see 
http://cran.r-project.org/web/packages/fOptions/fOptions.pdf).

Instructions for using this application:

In order to value on option on any stock, the user will need to enter to following information in the left (side) panel:

1. The type of option - whether this is a call option or a put option. A call option provides the buyer of the 
option the right to sell the stock at specified time (the expiration date) for a specified price (aka the exercise price).
A put option provides the buyer the right to sell the stock at a the specified time for the specified price.
2. The current price of the stock
3. The exercise price of the option
4. The expiration date of the option (after which time the buyer will no longer have the right to buy or sell the stock).
This field is entered into the application as a date field.
5. The current risk-free interest rate entered as a decimal value (i.e. use .01 for 1%) on an annualized basis. Currently, 
in the US, these values range from .3% for two months up to 2.6% for ten years.
6. The annualized cost-of-carry rate as a decimal value (i.e. use .03 for 3%). Think of this rate as
the level at which the buyer would be charged if he/she were borrowing funds.
7. The annualized volatility fo the underlying security in a decimal format (i.e. enter 0.3 for 30%). This value needs to
be non-negative and most stocks have levels between 10% and 60% (although this can change over time).

Once all of these variables are entered, the application will calculate the theoretical value of the option as well as 
a payout plot displaying the expected profit or loss over a range of stock prices at the time of expiration.

The final graph plots the theoretical value of the option over a range of different exercise prices. The user may adjust this
graph by selecting to have either the volatility level, interest rate, or carried interest rate replace the exercise price on
the x-axis. When the user does so, the range of the y-axis will not change which illustrates that some variables will have
a significantly larger impact on the option's value than others (in fact, for near-term options, modifications in the 
interest rate variables will not significantly impact the option's values as the current rate levels).
