library(tidyverse)

ach_profile <- read_csv("data/achievement_profile_data_with_CORE.csv")

## Exercise 1
# Use filter() to find the number of districts with a 100% Algebra I proficiency rate.



## Exercise 2
# Create a new variable called `math_achievement` with a value of:
#     * `"High"` if a district's Math proficiency is 75% or higher;
#     * `"Medium"` if a district's Math proficiency is between 50% and 75%;
#     * `"Low"` if a district's Math proficiency is below 50%.



## Exercise 3
# Filter down to district 792 (Shelby County), then pipe the result to `View()`.



## Exercise 4
# Do the following in one sequence of function calls, piped together:
# 1. Read in the `data/tvaas.csv` file.
# 2. Rename variables as follows:
#     * `District Name` to `system`.
#     * `District-Wide: Composite` to `TVAAS Composite`.
#     * `District-Wide: Literacy` to `TVAAS Literacy`.
#     * `District-Wide: Numeracy` to `TVAAS Numeracy`.
# 3. Drop the `District Name` variable.



## Exercise 5
# Sort alphabetically by CORE region, then by Algebra I proficiency in descending order.
# Then, keep just the district name, Algebra I proficiency, and CORE region variables.



## Exercise 6
# Use `summarise()` to find the mean, minimum, and maximum district grad rate.
# Assign variable names to the resulting data frame.



## Exercise 7
# Identify districts with a higher Percent ED than the median district, and a
# higher Math proficiency than the median district.



# Exercise 8
# Identify districts with a higher dropout rate than the average of districts
# in the same CORE Region.



## Exercise 9
# Calculate three variables:
# * A district's average proficiency in math subjects (Math, Algebra I-II)
# * A district's average proficiency in English subjects (ELA, English I-III)
# * A district's average proficiency in science subjects (Science, Biology I, Chemistry)
# Then, reorder variables such that:
# * The math average is next to the individual math variables.
# * The English average is next to the individual English variables.
# * The science average is next to the individual science variables.



## Exercise 10
# Create a data frame with the number of districts at each TVAAS level, by CORE region.



## Exercise 11
# Reshape the `tvaas` data frame long by subject, then arrange by system.


