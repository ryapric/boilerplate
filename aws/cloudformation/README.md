AWS CloudFormation
==================

Layout
------

- `stacks/`: The YAML files that are used to deploy CloudFormation Stacks. Named
  according to their Stack contents, and should have corresponding files in the
  `parameters` folder as well (named as `<stackname_envname>.json`)

- `parameters/`: JSON array files containing key-value pairs of parameters for
  Stacks.

- `tags/`: Environment-specific tags to propagate to all resources in a Stack.
  Named according to the environment they're deployed to.

How to use
----------

[WORK IN PROGRESS]

CloudFormation works off of files ("templates") you write, in either JSON
(gross) or YAML.

Makefile targets:

- `create`: requires `env` and `stackname` parameters.

- `update`: same as `create`.

- `status`: only requires `stackname`. Prints Stack event logs via `awscli`.

- `delete`: only requires `stackname`.
