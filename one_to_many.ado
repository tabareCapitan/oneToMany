/*******************************************************************************
* Name: 		one_to_many.ado
*
* Author:		Tabaré Capitán (tcapitan@catie.ac.cr)
*
* Created:		2014/11/03
*
* Last modified:2015/01/14		
*
* Institution:	CATIE
*
* Description:  Convert multiple selection questions coded in a single string
*		 		variable separated by an space into dummies for each option. 
*				
*				Handles 999 codification for N/A (just count it as an option)
*
*				one_to_dummy varname [# of options]
*
*				[ # of options ] 
*					Number of options in the multiple selection 
*					
*				Example:
*
*					one_to_dummy adaptation_measures 8
*										
* Limits:		Up to 98 options.
*
*******************************************************************************/
version 13

program define one_to_many

// ARGUMENTS
gen temp_multiple = `1'

gen temp_size = `2'

/* THIS WAS A PARTIAL SOLUTION FOR THE LACK OF # OF OPTIONS, A FULL SOLUTION
   CANNOT BE IMPLEMENTED
   
if (`2'1 == 1){

	di "There's no number of choices, the maximum one chosen will be used"

	di "0"
	gen temp_max_per_obs = substr(temp_multiple,length(temp_multiple)-1,2)
	
	di "1"
	if(temp_max_per_obs == "99"){
		di "2"
		replace temp_multiple = substr(temp_multiple, 1, length(temp_multiple)-3)
		di "3"
		replace temp_max_per_obs = substr(temp_multiple,length(temp_multiple)-1,2)	
	}
	
	capture destring temp_max_per_obs, replace
	
	egen temp_max_all = max(temp_max_per_obs)
	
	capture destring temp_size, replace
	
	replace temp_size = temp_max_all 
}
else{
	replace temp_size = `2'
}
*/

// ENSURE STRING TYPE
capture tostring temp_multiple, replace

replace temp_multiple = " "+temp_multiple+" "

su temp_size, meanonly

// CREATE DUMMIES
forvalues i = 0/`r(mean)' { // revisar xq mean

	gen temp = `i'
	tostring temp, replace
	replace temp = " "+temp+" "
	
	generate byte q_`i' = ( strpos(temp_multiple, temp) > 0 )
 
	drop temp
}

gen q_999 =  ( temp_multiple == "999" )
 
 
// rename "q_" to "temp_multiple_" 

drop temp_multiple temp_size
	
capture drop temp_max_per_obs 

capture drop temp_max_all	
 
end

