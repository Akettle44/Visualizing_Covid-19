#!/bin/bash
cd /home/andrew/projects/R/corona
message=$(date)
Rscript corona.R
mv index.html ..
cd .. 
git add index.html
git commit -m "$message"
git push origin1 master 
