SELECT
commit,author,
       committer,
       repo_name
FROM `bigquery-public-data.github_repos.commits`
LIMIT 10
