# trikle-mail

Install with
```
gem install trikle-mail
```

Example usage:

1. Create a .csv file of your recipients.
```
name, email, score
jordan, jordan@example.com, 60
```

2. Write a template to email to your recipients.

Templates are secretly just ruby strings which use [ruby string formating](https://ruby-doc.org/core-2.7.1/String.html#method-i-25) under the hood. All of the columns from your csv are available for use within the template. For example, below we're using the `name` and `score` columns from the csv in our template.
```
Hey %{name},

You scored %{score} out of 100. Well done.

Best,
The People Who Do Scores.
```
3. Run the command!
```
trikle-mail smtp --host smtp.live.com --port 587 --username <username> --password <password> --subject "Hello" --from "Your Name <email>" --template template.txt email.csv
```

FYI, trikle-mail will look for parameters not specified on the command line in the csv. That means you can have a column for any (or all) of the parameters host, port, username, password, subject, from, template and unique values for each recipient. trikle-mail will use each recipeints unique values when sending mail!
