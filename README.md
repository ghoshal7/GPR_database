# GPR_database

##### The csv files contain field test Ground Penetrating Radar (GPR) data. The number of features, as well as metadata varied from one csv file to the other. It was  required to collect relevant experimental data and import multiple files with varying fields and finally generate a database (metadata not stored). Here, 4 sample GPR data files are made available, from which the codes for creating the database was developed.

###### multiple_files.m : This contains codes to import multiple csv files and create the database
###### gpr_ghoshal.m :  This contains function to create Structure and Database 
###### summary_stat.m : This calls the ‘gpr_ghoshal’ function, imports single csv file and spits out the summary statistics.

