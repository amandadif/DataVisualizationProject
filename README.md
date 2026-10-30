# Data Visualization Project

For this project I took my cleaned data that I created in my previous "Data Cleaning Project". This data consists of 5 email addresses in the Enron dataset (https://www.cs.cmu.edu/~enron/), around 9,900 emails total. I created a Shiny dashboard that displays email activity over time and allows a user to search through the cleaned records. Both of these features rely on the cleaning process. The year plot requires dates to work properly. The sender search functions because the sender names were standardized. The numbers below are based on the parts of app.R.

## How to run it:
Put app.R and emails_clean.csv into the same folder. The app needs the shiny and ggplot2 packages. Open app.R in RStudio or posit cloud and hit run.

## Explaining each part:
1. This section consists of loading emails_clean.csv, converting the dates to real dates, and adding a year column. Emails with a missing date are given the value "Unknown" for the year.
   
2. This section builds the options for the menus. The mailboxes variable is a sorted list of unique mailbox names, and years is a sorted list of the years in that data. "Unknown" is sorted separately.

3. This section creates the layout of the app with a title and two tabs. Email Activity tab has a mailbox dropdown, a plot area and a summary table. Explore Emails tab has a mailbox dropdown, a year dropdown a sender search box, a results table and a match count. User interface only sets up these spaces. The server fills them in.

4. This section covers the server.
- Starts with all the emails and if the user picks a mailbox on the first tab keeps only that mailbox's rows. The plot and the summary table both use this result so they always match.

- Takes those emails  and removes the "Unknown" years and draws a bar chart of the number of emails per year. This is only possible because the dates were cleaned into real dates.

- Builds the summary table with three numbers: how many emails are selected, how many mailboxes are included (5 for "All users" 1 for a mailbox), and how many emails have missing dates.

- Applies the three filters on the second tab one after another: mailbox, then year, then sender search. The search ignores capitalization and looks in the cleaned sender_name column so searching "arora" finds "harry arora". An empty search box skips that filter.

- Displays the matching emails in a table with the mailbox, folder, sender, subject and date limited to the 50 rows so the page loads quickly. It also shows the number of matches so the user can tell when there are more, than the 50 displayed.

## What the dashboard shows:

The dashboard shows that most of the emails are from 2000 and 2001 with a few from 1999 or 2002. The mailbox dropdown lets you compare mailboxes by size and by when the emails were sent. The summary table shows how many emails have no date. The same email can appear more than once in the table because the email can be stored in several folders of one mailbox. I did not remove these copies when cleaning.
