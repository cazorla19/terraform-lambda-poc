# Task 1

This task runs under `terraform apply` command. Terraform should deploy Lambda function to fetch the latest blocks from Blockchain API and send them to SNS topic.

The expected result is the payload being sent to SNS topic in the following format:

```
{"block": "new", "hash": "_block_hash_"}
```

## Requirements

You need to have following programs installed in your $PATH:

* bash
* aws
* python3 and python3-pip
* terraform >= 0.14

