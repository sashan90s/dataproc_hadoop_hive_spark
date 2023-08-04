# Check if the commit message is provided as an argument
if ($args.Count -eq 0) {
    Write-Host "Please provide a commit message as an argument."
    exit 1
}

# Change directory to your Git repository
cd E:\programming\hadoop_hive_spark_docker

# Execute Git commands
git status
git add .
git commit -m $args[0]
git push

# .\git_commands.ps1 "10th commit" 