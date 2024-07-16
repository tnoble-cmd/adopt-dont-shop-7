# 6. Submit an Application

# As a visitor
# When I visit an application's show page
# And I have added one or more pets to the application
# Then I see a section to submit my application

### ACTION OF ADDING PETS TO APPLICATION REVEALS TEXT FIELD FOR USER TO PATCH THEIR PREVIOUS `DESCRIPTION`
### ^^^ This is actually for US#7, but we might be able to just do it all at once and split up the tests later.

### `SUBMIT` BUTTON ASSOCIATED WITH FIELD SENDS PATCH REQUEST TO REPLACE PREVIOUSLY ENTERED `DESCRIPTION`

# And in that section I see an input to enter why I would make a good owner for these pet(s)
# When I fill in that input
# And I click a button to submit this application


# Then I am taken back to the application's show page

### REDIRECT (REFRESH PAGE)


# And I see an indicator that the application is "Pending"

### STATUS UPDATED FROM "IN PROGRESS" TO "PENDING" AFTER APPLICATION SUBMITTED


# And I see all the pets that I want to adopt

### ALL PETS PREVIOUSLY SELECTED (ASSOCIATED WITH APPLICATION) DISPLAYED


# And I do not see a section to add more pets to this application

### CONDITIONAL REQUIRED TO HIDE PET SEARCH FIELD



# 7. No Pets on an Application

# As a visitor
# When I visit an application's show page
# And I have not added any pets to the application

# Then I do not see a section to submit my application

### DESCRIPTION (PATCH) FIELD AND SUBMIT BUTTON HIDDEN UNTIL PETS ADDED TO APPLICATION
### ADDING PETS TO APPLICATION REVEALS DESCRIPTION/SUBMIT FIELD

# Need to make it so that the Submit button for the application does not
# --> appear until pets have been added to the application.
# Will need a conditional to check if pets are present in the @pets array displayed in `Desired Pets` (and elsewhere?)



# 8. Partial Matches for Pet Names

# As a visitor
# When I visit an application show page
# And I search for Pets by name
# Then I see any pet whose name PARTIALLY matches my search
# For example, if I search for "fluff", my search would match pets with names "fluffy", "fluff", and "mr. fluff"


