#!/bin/sh -l
echo "Running QA workflow for PR created on $3 branch"
project="https://circleci.com/api/v1.1/project/github/$GITHUB_REPOSITORY/tree/$3"
echo "Running the $2 job for $project"
response=$(curl -u $1: -d build_parameters[CIRCLE_JOB]=$2 $project)
output=$?
echo $response
echo ::set-output name=response::$output
(exit $output)
