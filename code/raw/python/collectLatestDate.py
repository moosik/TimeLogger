import os
from datetime import datetime
import subprocess

emailDirectory = ".reports_from_gmail/GYB-GMail-Backup-vitalina@gmail.com/"
anotherTest = "./test/"

## this function gives all paths to the .eml files (backup from running gyb)
def getFilePath(inputDir):
    allPaths = []
    for root, dirs, files in os.walk(inputDir):
        for file in files:
            if file.endswith(".eml"):
                allPaths.append(os.path.join(root, file))
    return allPaths

## Split the paths to the .eml files to extract the days
def extractDate(paths):
    allDates = []
    for el in paths:
        dateList = el.split("/")[3:6] # extract date related elements
        dateString = "/".join(dateList) # convert elements to string
        dateObj = datetime.strptime(dateString, "%Y/%m/%d")
        allDates.append(dateObj)
    latestDate = max(allDates)
    latestDateString = latestDate.strftime("%Y/%m/%d")
    return latestDateString

## Create a shell command to run GYB
allPaths = []
allPaths = getFilePath(emailDirectory)
dateGYB = extractDate(allPaths)

#lets create a test folder that will have backups from the date I give it to
newtest = ["python", "./reports_from_gmail/gyb.py","--email", "vitalina@gmail.com" ,"--local-folder","./reports_from_gmail/test","--search", "subject:TimeLogger AND after:"+dateGYB]

## Use Python to wrap the code and do the test
subprocess.call(newtest) #how can I supress the output of this?

## Now should I just use dateGYB as the starting point to collect all paths?
## Collect all paths, write them to a file, let R collect the data then kill 
## the file with the paths since I won't need that anymore.

def collectLatestFile(inputDir, latestGYB):
    #The function takes dateGYB as a parameter to get only those dates that are after that date
    allPaths = getFilePath(inputDir)
    f = open("forRtoCollect.txt", "w")
    for el in allPaths:
        dateList = el.split("/")[3:6] # extract date related elements
        dateString = "/".join(dateList) # convert elements to string
        dateObj = datetime.strptime(dateString, "%Y/%m/%d")
        if dateObj >= latestGYB:
            f.write(el+"\n")
    f.close()
