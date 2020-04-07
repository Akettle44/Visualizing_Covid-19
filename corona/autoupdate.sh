#!/bin/bash
message=$(date)
Rscript corona.R
git add index.html
git commit -m "$message"
git push origin master 
