# Circle CI Trigger a job

This action can used to trigger a Circle CI job defined in the ```./circleci/config.yml``` file in your repository. The action needs the below listed 3 parameters.

1. circle_ci_token: The circle ci token to access the circle-ci API.
2. circle_ci_job: The circle ci job to be run. This is defined under the jobs section in ```./circleci/config.yml``` file in your repository.
3. circle_ci_project_url: This is URL of the project. In your github action you can pass this by using ${{ github.ref }} as the argument.

An example github workflow file is shown below:
**Example:** Trigger a build on adding a new label to your pull request.
```yml
name: approved workflow
on:
  pull_request:
   types:
    - labeled
jobs:
  approved_pr_job:
    if: github.event.label.name == 'approved'
    runs-on: ubuntu-latest
    name: Deploy to QA environment
    steps:
    - uses: actions/checkout@v2
    - name: a simple circle-ci deployment trigger
      id: curl-circle-ci
      uses: Open-Source-Contrib/circle-ci-trigger-action@latest
      with:
        circle_ci_token: ${{ secrets.CIRCLE_CI_TOKEN }}
        circle_ci_job: ${{ secrets.CIRCLE_CI_QA_JOB }}
        circle_ci_project_url: ${{ github.event.pull_request.head.ref }}
    # Use the output from the `hello` step
    - name: Get the output response
      run: echo "The response was ${{ steps.curl-circle-ci.outputs.response }}"
```

**Example:** Trigger a build on a new tag creation (when you push a new tag to your repo.)
```yml
name: released workflow
on:
  push:
    # Sequence of patterns matched against refs/tags
    tags:
      - 'v*' # Push events to matching v*, i.e. v1.0, v20.15.10
jobs:
  tag_created_job:
    runs-on: ubuntu-latest
    name: Deploy to Production environment
    steps:
    - uses: actions/checkout@v2
    - name: Run the Circle CI Release build
      id: curl-circle-ci
      uses: Open-Source-Contrib/circle-ci-trigger-action@latest
      with:
        circle_ci_token: ${{ secrets.CIRCLE_CI_TOKEN }}
        circle_ci_job: ${{ secrets.CIRCLE_CI_RELEASE_JOB }}
        circle_ci_project_url: ${{ github.ref }}
    # Use the output from the `curl-circle-ci` step
    - name: Get the output response
      run: echo "The response was ${{ steps.curl-circle-ci.outputs.response }}"
```
