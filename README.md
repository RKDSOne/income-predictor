# Shiny app for income prediction

## About

This R/Shiny app uses a model based on Current Population Survey data to predict a person's income based on a handful of demographic and other characteristics.

I wrote it for the Coursera class "Developing Data Products".

## The Data

The data is monthly data from CPS for the year 2014. I've pared it down to the following columns:

 * HRYEAR4
 * HRMONTH
 * PRERELG: earnings available flag
 * PRERNWA: weekly earnings (less overtime/commissions/tips)
 * PESEX: sex
 * PRTAGE: age
 * PEEDUCA: education level
 * PRDTOCC1: occupation category (23)
 * GTMETSTA: lives in metro/nonmetro area
 * PEHRUSL1: usual hours worked, main job
 * PEHRUSL2: usual hours worked, other jobs

In addition, I filtered the data by PRERELG == 1 (earnings available) and hours worked not "varies" (value == -4). Education is recoded to get rid of the detailed "less than high school" categories and treated as an ordered factor.

## The Model

