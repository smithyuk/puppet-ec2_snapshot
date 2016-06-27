# ec2_snapshot for Puppet

This module will automate AWS EC2 snapshots via [colinbjohnson's aws-missing-tools project](https://github.com/colinbjohnson/aws-missing-tools) and cron. Currently the module does not place credentials for AWS as I have another module to do this for me. It requires [vcsrepo module](https://github.com/puppetlabs/puppetlabs-vcsrepo).

EBS volumes tagged with the configured key/value in EC2 will be backed up (by default Backup=true).

## Example usage

```puppet
class { 'ec2_snapshot':
  region     => 'us-west-2',
  extra_opts => ['-n'],
  mailto     => 'root@localhost',
}
```

## TODO

* Configurable cron time for backup
* Configurable user/group
* Ability to place credentials with module (possibly with hiera-eyaml-gpg or other)

## Notes

I would recommend creating a user specifically to handle backups and placing the relevant credentials in the ec2_snapshot user's `~/.aws/credentials` file.

Here is an example of the IAM policy for the user:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        }
    ]
}
```
